//
//  PEvent.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "Event.h"
#import "Pin.h"

@interface PEvent : Event

@property (strong, nonatomic) Pin *pin;

@end
