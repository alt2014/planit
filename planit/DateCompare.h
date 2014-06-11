//
//  DateCompare.h
//  planit
//
//  Created by John Wu on 6/10/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCompare : NSDate

+ (NSComparisonResult)timelessCompare:(NSDate *)date1 date2:(NSDate *)date2;
+ (NSDate *)dateByZeroingOutTimeComponents:(NSDate*)date;
+ (void)zeroOutTimeComponents:(NSDateComponents **)components;
+ (NSInteger)getDayFromArray:(NSArray*)daysArray date:(NSDate*)date;

@end
