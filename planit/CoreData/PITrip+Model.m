//
//  PITrip+Model.m
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PITrip+Model.h"
#import "DataManager.h"
#import "PIDay+Model.h"
#import "PIEvent+Model.h"

#define SECS_IN_A_DAY 60*60*24

@implementation PITrip (Model)

+ (PITrip*)createTripFromDictionary:(NSDictionary *)trip inManagedObjectContext:(NSManagedObjectContext *)context {
    PITrip *result = [NSEntityDescription insertNewObjectForEntityForName:@"PITrip" inManagedObjectContext:context];
    
    result.name = [trip objectForKey:T_NAME_KEY];
    result.notes = [trip objectForKey:T_NOTES_KEY];
    result.uid = [DataManager uuid];
    
    NSDate *start = [trip objectForKey:T_START_KEY];
    NSDate *end = [trip objectForKey:T_END_KEY];
    
    int daysbetween = [PITrip daysBetween:start and:end] + 1;
    
    // Set up days array
    for (int i = 0; i < daysbetween; i++) {
        NSDate *curr = [NSDate date];
        
        if (i == 0) {
            // first day so use start date
            curr = [[NSDate alloc] initWithTimeInterval:0 sinceDate:start];
        } else if (i == daysbetween - 1) {
            // last day of trip so use end date
            curr = [[NSDate alloc] initWithTimeInterval:0 sinceDate:end];
        } else {
            // add however many days to the start day
            curr = [start dateByAddingTimeInterval: SECS_IN_A_DAY * i];
        }
        
        PIDay *day = [PIDay createDay:curr inManagedObjectContext:context];
        [result addDaysObject:day];
    }
    
    [context save:NULL];
    
    DataManager *dm = [[DataManager alloc] init];
    [dm addTrip:result];
    
    return result;
}

+ (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    
//    NSUInteger unitFlags = NSDayCalendarUnit;
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
//    return [components day];
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:dt1];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:dt2];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSArray*)sortTrips:(NSArray*)trips {
    return [trips sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[PITrip class]] && [obj2 isKindOfClass:[PITrip class]]) {
            PITrip *a = obj1;
            PITrip *b = obj2;
            NSDate *date1 = [a start];
            NSDate *date2 = [b start];
            
            return [date1 compare:date2];
        }
        
        return NSOrderedSame;
    }];
}

+ (NSArray*)fetchTripsInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PITrip"];
    request.predicate = nil;
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error) {
        return nil;
    }
    
    NSArray *sorted = [self sortTrips:matches];
    return sorted;
}


- (PIDay*)getDayForDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    for (PIDay *d in self.days) {
        NSDate *curr = d.date;
        
        NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:curr];
        
        NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
        
        if (comparison == NSOrderedSame) {
            return d;
        }
    }
    
    return nil;
}

- (NSArray*)getDaysArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.days allObjects]];
    
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[PIDay class]] && [obj2 isKindOfClass:[PIDay class]]) {
            PIDay *a = obj1;
            PIDay *b = obj2;
            NSDate *first = a.date;
            NSDate *second = b.date;
            return [first compare:second];
        }
        
        NSLog(@"Yo man why are there objects that aren't DAYS in this Trip.days array!");
        return NSOrderedSame;
    }];
    
    return sorted;
}

- (NSDate*)start {
    if ([self.days count]) {
        PIDay *d = [[self getDaysArray] firstObject];
        return d.date;
    }
    
    return nil;
}

- (NSDate*)end {
    if ([self.days count]) {
        PIDay *d = [[self getDaysArray] lastObject];
        return d.date;
    }
    
    return nil;
}

- (void)moveStartDateTo: (NSDate*)date {
    int daysBetween = [PITrip daysBetween:self.start and:date];
    
    if (daysBetween == 0) {
        return;
    }
    
    int daysToAdd =  SECS_IN_A_DAY * daysBetween;
    
    NSArray *days = [self getDaysArray];
    
    for (int i = 0; i < [self.days count]; i++) {
        PIDay *d = [days objectAtIndex: i];
        d.date = [d.date dateByAddingTimeInterval: daysToAdd];
        NSSet *events = d.events;
        
        // Update Events too
        for (PIEvent *e in events) {
            e.start = [e.start dateByAddingTimeInterval:daysToAdd];
            e.end = [e.end dateByAddingTimeInterval:daysToAdd];
        }
    }
}

- (BOOL)changeStartDateTo: (NSDate*)date {
    int daysBetween = [PITrip daysBetween: self.start and: date];
    NSArray *days = [self getDaysArray];
    
    // don't allow changing start day to be after the end date
    if (daysBetween == 0 || (daysBetween >= [days count] && daysBetween > 0)) {
        return NO;
    }
    
    int countOfNewDaysAdded = -1;
    NSDate *start = [NSDate dateWithTimeInterval:0 sinceDate:self.start];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    // Add new days to the beginning
    while (daysBetween < 0) {
        int daysToAdd = SECS_IN_A_DAY * countOfNewDaysAdded;
        PIDay *d = [PIDay createDay:[NSDate dateWithTimeInterval:daysToAdd sinceDate: start] inManagedObjectContext: context];
        [self addDaysObject:d];
        
        countOfNewDaysAdded--;
        daysBetween++;
    }
    
    for (int i = 0 ; i < daysBetween; i++) {
        [context deleteObject:[days objectAtIndex:i]];
    }
    
    return YES;
}

- (BOOL)changeEndDateTo: (NSDate *)date {
    int daysBetween = [PITrip daysBetween:self.end and:date];
    int daysBeforeStart = [PITrip daysBetween:self.start and:date];
    
    if (daysBetween == 0 || daysBeforeStart < 0) {
        return NO;
    }
    
    NSArray *days = [self getDaysArray];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    int count = 1;
    
    while (daysBetween < 0) {
        [context deleteObject:[days objectAtIndex:[days count] - count]];
        count++;
        daysBetween++;
    }
    
    for (int i = 0; i < daysBetween; i++) {
        int daysToAdd = SECS_IN_A_DAY * i;
        PIDay *d = [PIDay createDay:[NSDate dateWithTimeInterval:daysToAdd sinceDate:date] inManagedObjectContext:self.managedObjectContext];
        [self addDaysObject:d];
    }
    
    return YES;
}

- (int)lengthOfTrip {
    return [self.days count];
}

@end
