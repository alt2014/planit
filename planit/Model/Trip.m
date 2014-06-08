//
//  Trip.m
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "Trip.h"

@interface Trip()

@property (strong, nonatomic) NSMutableArray *days;

@end

@implementation Trip

#define NUM_SECONDS_IN_MIN 60
#define NUM_MINS_IN_HOUR 60
#define NUM_HRS_IN_DAY 24

- (NSMutableArray*)days {
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    }
    
    return _days;
}

- (Day*)getDayForDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
    for (Day *d in self.days) {
        NSDate *curr = d.date;
        
        NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:curr];
        
        NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
        
        if (comparison == NSOrderedSame) {
            return d;
        }
    }
    
    return nil;
}


+ (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day];
}

- (id) initWithName: (NSString*)name
              start: (NSDate *)start
                end: (NSDate*)end {
    self = [super init];
    
    if (self) {
        self.name = name;
        
        int daysbetween = [Trip daysBetween:start and:end] + 1;
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
                curr = [start dateByAddingTimeInterval: NUM_SECONDS_IN_MIN * NUM_MINS_IN_HOUR * NUM_HRS_IN_DAY * i];
            }

            Day *day = [[Day alloc] initWithDate:curr];
            [self.days addObject:day];
           
        }
    }
    
    return self;
}

- (NSDate*)start {
    if ([self.days count]) {
        Day *d = [self.days firstObject];
        return d.date;
    }
    
    return nil;
}

- (NSDate*)end {
    if ([self.days count]) {
        Day *d = [self.days lastObject];
        return d.date;
    }
    
    return nil;
}

- (NSArray*)getDays {
    return [NSArray arrayWithArray:self.days];
}

- (void)moveStartDateTo: (NSDate*)date {
    int daysBetween = [Trip daysBetween:self.start and:date];
    
    if (daysBetween == 0) {
        return;
    }
    
    int daysToAdd = NUM_SECONDS_IN_MIN * NUM_MINS_IN_HOUR * NUM_HRS_IN_DAY * daysBetween;
    
    for (int i = 0; i < [self.days count]; i++) {
        Day *d = [self.days objectAtIndex: i];
        d.date = [d.date dateByAddingTimeInterval: daysToAdd];
        
        // Update Events too
        for (Event *e in [d getEvents]) {
            e.start = [e.start dateByAddingTimeInterval:daysToAdd];
            e.end = [e.end dateByAddingTimeInterval:daysToAdd];
        }
    }
}

- (BOOL)changeStartDateTo: (NSDate*)date {
    int daysBetween = [Trip daysBetween: self.start and: date];
    NSArray *days = [self getDays];
    
    // don't allow changing start day to be after the end date
    if (daysBetween == 0 || (daysBetween >= [days count] && daysBetween > 0)) {
        return NO;
    }
    
    int countOfNewDaysAdded = -1;
    NSDate *start = self.start;
    
    // Add new days to the beginning
    while (daysBetween < 0) {
        int daysToAdd = NUM_SECONDS_IN_MIN * NUM_MINS_IN_HOUR * NUM_HRS_IN_DAY * countOfNewDaysAdded;
        Day *d = [[Day alloc] initWithDate:[NSDate dateWithTimeInterval:daysToAdd sinceDate: start]];
        [self.days insertObject:d atIndex:0];

        countOfNewDaysAdded--;
        daysBetween++;
    }
    
    for (int i = 0 ; i < daysBetween; i++) {
        [self.days removeObjectAtIndex:0];
    }
    
    return YES;
}

- (BOOL)changeEndDateTo: (NSDate *)date {
    int daysBetween = [Trip daysBetween:self.end and:date];
    int daysBeforeStart = [Trip daysBetween:self.start and:date];
    
    if (daysBetween == 0 || daysBeforeStart < 0) {
        return NO;
    }
    
    while (daysBetween < 0) {
        daysBetween++;
        [self.days removeLastObject];
    }
    
    for (int i = 0; i < daysBetween; i++) {
        int daysToAdd = NUM_SECONDS_IN_MIN * NUM_MINS_IN_HOUR * NUM_HRS_IN_DAY * i;
        Day *d = [[Day alloc] initWithDate:[NSDate dateWithTimeInterval:daysToAdd sinceDate:date]];
        [self.days addObject:d];
    }
    
    
    
    return YES;
}

- (int)lengthOfTrip {
    if ([self.days count]) {
        return [self.days count];
    }
    
    return 0;
}

@end
