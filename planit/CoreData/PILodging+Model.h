//
//  PILodging+Model.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PILodging.h"
#import "PIEvent+Model.h"

#define EL_CONFIRMATION_KEY @"EL_CONFIRMATION"

@interface PILodging (Model)

+ (PILodging*)createLodging:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context;

@end