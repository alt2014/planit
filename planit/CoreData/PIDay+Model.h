//
//  PIDay+Model.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PIDay.h"

@interface PIDay (Model)

+ (PIDay*)createDay:(NSDate*)day inManagedObjectContext:(NSManagedObjectContext*)context;

- (void)addEvent:(PIEvent*)event;
- (NSArray*)getEvents;

@end
