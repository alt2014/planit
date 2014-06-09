//
//  PITransportation+Model.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PITransportation.h"
#import "PIEvent+Model.h"

#define ET_ARRIVAL_KEY @"ET_ARRIVAL"
#define ET_CONFIRMATION_KEY @"ET_CONFIRMATION"
#define ET_DEPARTURE_KEY @"ET_DEPARTURE"
#define ET_ROUTE_KEY @"ET_ROUTE"

@interface PITransportation (Model)

+ (PITransportation*)createTransportation:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context;

@end
