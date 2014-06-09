//
//  Yelp.h
//  yelpapitest
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Yelp : NSObject

- (void)search:(NSString*)term location:(NSString*)location callback:(void (^) (BOOL success, NSArray *results))block;

@end
