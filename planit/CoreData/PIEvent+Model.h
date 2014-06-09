//
//  PIEvent+Model.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "PIEvent.h"

#define E_NAME_KEY @"E_NAME"
#define E_NOTES_KEY @"E_NOTES"
#define E_ADDR_KEY @"E_ADDR"
#define E_START_KEY @"E_START"
#define E_END_KEY @"E_END"
#define E_PHONE_KEY @"E_PHONE"

@interface PIEvent (Model)

+ (PIEvent*)createEvent:(NSDictionary*)event inManagedObjectContext:(NSManagedObjectContext*)context;

@end
