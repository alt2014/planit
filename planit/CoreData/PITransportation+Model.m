//
//  PITransportation+Model.m
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PITransportation+Model.h"
#import "DataManager.h"

@implementation PITransportation (Model)

+ (PITransportation*)createTransportation:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context {
    PITransportation *result = [NSEntityDescription insertNewObjectForEntityForName:@"PITransportation" inManagedObjectContext:context];
    
    result.uid = [DataManager uuid];
    result.name = [event objectForKey:E_NAME_KEY];
    result.notes = [event objectForKey:E_NOTES_KEY];
    result.start = [event objectForKey:E_START_KEY];
    result.end = [event objectForKey:E_END_KEY];
    result.addr = [event objectForKey:E_ADDR_KEY];
    result.phone = [event objectForKey:E_PHONE_KEY];
    result.arrivalLocation = [event objectForKey:ET_ARRIVAL_KEY];
    result.confirmationNumber = [event objectForKey:ET_CONFIRMATION_KEY];
    result.departureLocation = [event objectForKey:ET_DEPARTURE_KEY];
    result.routeNumber = [event objectForKey:ET_ROUTE_KEY];
    
    return result;
}

@end
