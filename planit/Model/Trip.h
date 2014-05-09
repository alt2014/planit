//
//  Trip.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"

@interface Trip : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

- (Day*)getDayForDate:(NSDate*)date;


@end
