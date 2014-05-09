//
//  Day.m
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "Day.h"

@interface Day()
@property (strong, nonatomic) NSMutableArray *events;
@end

@implementation Day

- (NSMutableArray*)events {
    if (!_events) {
        _events = [[NSMutableArray alloc] init];
    }
    return _events;
}

- (NSArray*) getEvents {
    return [NSArray arrayWithArray: self.events];
}

- (void)addEvent:(Event *)event {
    if (event) {
        [self.events addObject:event];
    }
}

@end
