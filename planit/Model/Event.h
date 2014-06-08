//
//  Event.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSDate *when;
@property (strong, nonatomic) Address *addr;
@property (strong, nonatomic) NSDate *start; // start time
@property (strong, nonatomic) NSDate *end; // end time

@end
