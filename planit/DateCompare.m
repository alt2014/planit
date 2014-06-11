//
//  DateCompare.m
//  planit
//
//  Created by John Wu on 6/10/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "DateCompare.h"
#import "PIDay.h"

@implementation DateCompare

#pragma mark - date comparison
+ (NSComparisonResult)timelessCompare:(NSDate *)date1 date2:(NSDate *)date2
{
    NSDate *dt1 = [DateCompare dateByZeroingOutTimeComponents:date1];
    NSDate *dt2 = [self dateByZeroingOutTimeComponents:date2];
    return [dt1 compare:dt2];
}

+ (NSDate *)dateByZeroingOutTimeComponents:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:date];
    [self zeroOutTimeComponents:&components];
    return [calendar dateFromComponents:components];
}

+ (void)zeroOutTimeComponents:(NSDateComponents **)components
{
    [*components setHour:0];
    [*components setMinute:0];
    [*components setSecond:0];
}

+ (NSInteger)getDayFromArray:(NSArray*)daysArray date:(NSDate*)date
{
    NSInteger numDays = [daysArray count];
    for (NSInteger i = 0; i < numDays; i++) {
        NSDate *date1 = ((PIDay*)[daysArray objectAtIndex:i]).date;
        /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/YYYY HH:mm"];
        NSLog(@"One: %@, Two: %@", date, date1);*/
        if ([DateCompare timelessCompare:date date2:date1]== NSOrderedSame) {
            return i;
        
        }
    }
    return -1;
}
@end
