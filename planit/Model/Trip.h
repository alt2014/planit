//
//  Trip.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

// designed initializer
- (id) initWithName: (NSString*)name
              start: (NSDate *)start
                end: (NSDate*)end;

// Returns a Day for the given date
// Note: For the date comparison, only year, month, and day are compared.
//       Time is ignored.
- (Day*)getDayForDate:(NSDate*)date;

// Returns an array of Days for this Trip
- (NSArray*)getDays;

/*
 Moves down or up the start date and retains event and duration

 Example: Trip from 1/1/2011 to 1/4/2011
 Setting date to 1/5/2011 will change the start and end date to
 StartDate = 1/5/2011
 EndDate = 1/8/2011 and events will
*/
- (void)moveStartDateTo:(NSDate*)date;

/*
 Changes the start date to a later or earlier time.
 If the new start date is earlier than the old start date, days will be
 added to the beginning of the days array.
 If the new start date is later than the old, days before the new start date
 will be deleted.
 */
- (BOOL)changeStartDateTo:(NSDate*)date;
/* Similar to start date */
- (BOOL)changeEndDateTo:(NSDate*)date;

+ (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;

// Returns the length of the trip in days
- (int)lengthOfTrip;

@end
