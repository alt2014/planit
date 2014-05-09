//
//  Day.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Day : NSObject

@property (strong, nonatomic) NSDate *day;

- (NSArray *)getEvents;
- (void)addEvent: (Event*)event;

@end
