//
//  PITrip+Model.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PITrip.h"

#define T_NAME_KEY @"T_NAME"
#define T_NOTES_KEY @"T_NOTES"
#define T_START_KEY @"T_START"
#define T_END_KEY @"T_END"

@interface PITrip (Model)

+ (PITrip*)createTripFromDictionary:(NSDictionary*)trip
           inManagedObjectContext:(NSManagedObjectContext*)context;

+ (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;
+ (NSArray*)fetchTripsInContext:(NSManagedObjectContext *)context;

// Returns a Day for the given date
// Note: For the date comparison, only year, month, and day are compared.
//       Time is ignored.
- (PIDay*)getDayForDate:(NSDate*)date;

- (NSArray*)getDaysArray;

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

// Returns the length of the trip in days
- (int)lengthOfTrip;

- (NSDate*)start;
- (NSDate*)end;

@end
