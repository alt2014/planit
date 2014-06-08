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
    return [components day] + 1;
}

- (id) initWithName: (NSString*)name
              start: (NSDate *)start
                end: (NSDate*)end {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.start = start;
        self.end = end;
        
        int daysbetween = [Trip daysBetween:start and:end];
        
        // Set up days array
        for (int i = 0; i < daysbetween; i++) {
            NSDate *curr = [NSDate date];
            
            if (i == 0) {
                // first day so use start date
                curr = start;
            } else if (i == daysbetween - 1) {
                // last day of trip so use end date
                curr = end;
            } else {
                // add however many days to the start day
                curr = [start dateByAddingTimeInterval:NUM_SECONDS_IN_MIN * NUM_MINS_IN_HOUR * NUM_HRS_IN_DAY * i];
            }

            Day *day = [[Day alloc] initWithDate:curr];
            [self.days addObject:day];
           
        }
    }
    
    return self;
}

- (NSArray*)getDays {
    return [NSArray arrayWithArray:self.days];
}

@end
