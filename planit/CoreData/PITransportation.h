//
//  PITransportation.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PIEvent.h"


@interface PITransportation : PIEvent

@property (nonatomic, retain) NSString * arrivalLocation;
@property (nonatomic, retain) NSString * confirmationNumber;
@property (nonatomic, retain) NSString * departureLocation;
@property (nonatomic, retain) NSString * routeNumber;

@end
