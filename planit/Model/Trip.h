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


@end
