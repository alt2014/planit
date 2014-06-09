//
//  PILodging+Model.m
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PILodging+Model.h"
#import "DataManager.h"

@implementation PILodging (Model)

+ (PILodging*)createLodging:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context {
    PILodging *result = [NSEntityDescription insertNewObjectForEntityForName:@"PILodging" inManagedObjectContext:context];
    
    result.uid = [DataManager uuid];
    result.name = [event objectForKey:E_NAME_KEY];
    result.notes = [event objectForKey:E_NOTES_KEY];
    result.start = [event objectForKey:E_START_KEY];
    result.end = [event objectForKey:E_END_KEY];
    result.addr = [event objectForKey:E_ADDR_KEY];
    result.phone = [event objectForKey:E_PHONE_KEY];
    result.confirmationNumber = [event objectForKey:EL_CONFIRMATION_KEY];
    
    return result;
}\
@end
