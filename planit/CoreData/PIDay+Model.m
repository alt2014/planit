//
//  PIDay+Model.m
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PIDay+Model.h"
#import "DataManager.h"
#import "PIEvent+Model.h"

@implementation PIDay (Model)

+ (PIDay *)createDay:(NSDate*)day inManagedObjectContext:(NSManagedObjectContext *)context {
    PIDay *result = [NSEntityDescription insertNewObjectForEntityForName:@"PIDay" inManagedObjectContext:context];
    result.uid = [DataManager uuid];
    result.date = day;
    
    return result;
}

- (void)addEvent:(PIEvent *)event {
    [self addEventsObject:event];
}

- (NSArray*)getEvents {
    NSArray *array = [NSArray arrayWithArray:[self.events allObjects]];
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[PIEvent class]] && [obj2 isKindOfClass:[PIEvent class]]) {
            PIEvent *a = obj1;
            PIEvent *b = obj2;
            NSDate *first = a.start;
            NSDate *second = b.start;
            return [first compare:second];
        }
        
        NSLog(@"Yo man why are there objects that ARENT EVENTS in this Day.Events array?!");
        return NSOrderedSame;
    }];
    
    return sorted;
}

@end
