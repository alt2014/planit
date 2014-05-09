//
//  Event.h
//  planit
//
//  Created by Peter Phan on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *where;
@property (strong, nonatomic) NSString *when;

@end
