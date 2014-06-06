//
//  Day.m
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "Day.h"

@interface Day()

@property (strong, nonatomic)  NSMutableArray *events;

@end

@implementation Day

- (NSMutableArray*)events {
    if (!_events) {
        _events = [[NSMutableArray alloc] init];
    }
    
    return _events;
}

- (void)addEvent:(Event *)event {
    if (event) {
        [self.events addObject:event];
        NSArray *sorted = [self.events sortedArrayUsingComparator:^NSComparisonResult(Event *obj1, Event *obj2) {
            if ([obj1 isKindOfClass:[Event class]] && [obj2 isKindOfClass:[Event class]]) {
                NSDate *first = obj1.start;
                NSDate *second = obj2.start;
                return [first compare:second];
            }
            
            NSLog(@"Yo man why are there objects that ARENT EVENTS in this Day.Events array?!");
            return NSOrderedSame;
        }];
        self.events = [NSMutableArray arrayWithArray:sorted];
    }
}

- (NSArray*)getEvents {
    return [NSArray arrayWithArray: self.events];
}

- (id) initWithDate: (NSDate*)date {
    self = [super init];
    
    if (self) {
        self.date = date;
    }
    
    return self;
}

@end
