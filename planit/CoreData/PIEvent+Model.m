//
//  PIEvent+Model.m
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PIEvent+Model.h"
#import "DataManager.h"

@implementation PIEvent (Model)

+ (PIEvent*)createEvent:(NSDictionary*)event
inManagedObjectContext:(NSManagedObjectContext*)context {
    PIEvent *result = [NSEntityDescription insertNewObjectForEntityForName:@"PIEvent" inManagedObjectContext:context];
    
    result.uid = [DataManager uuid];
    result.name = [event objectForKey:E_NAME_KEY];
    result.notes = [event objectForKey:E_NOTES_KEY];
    result.start = [event objectForKey:E_START_KEY];
    result.end = [event objectForKey:E_END_KEY];
    result.addr = [event objectForKey:E_ADDR_KEY];
    result.phone = [event objectForKey:E_PHONE_KEY];
    
    return result;
}

@end
