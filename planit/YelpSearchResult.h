//
//  YelpSearchResult.h
//  yelpapitest
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpSearchResult : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *rating;
@property (nonatomic) NSInteger numReviews;
@property (nonatomic) NSInteger phone;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *imageURL;

@end
