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

- (NSMutableArray*)days {
    if (!_days) {
        _days = [[NSMutableArray alloc] init];
    }
    
    return _days;
}


// TODO
- (Day*)getDayForDate:(NSDate *)date {
    return nil;
}

- (id) initWithStart: (NSDate *)start andEnd: (NSDate*)end {
    self = [super init];
    if (self) {
        self.start = start;
        self.end = end;
    }
    
    return self;
}



@end
