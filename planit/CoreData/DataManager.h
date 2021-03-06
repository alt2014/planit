//
//  DataManager.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PITrip.h"
#import "PITrip+Model.h"

@interface DataManager : NSObject

// Returns an array of all trips
- (void)loadTrips:(void (^) (BOOL success, NSArray *trips))block;

+ (NSString *)uuid;

+ (NSManagedObjectContext*)getManagedObjectContext;

- (NSArray*)getTrips;
- (void)addTrip:(PITrip*)trip;

@end
