//
//  Yelp.m
//  yelpapitest
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "Yelp.h"
#import "OAuthConsumer.h"
#import <YAJL/YAJL.h>
#import "YelpSearchResult.h"

@interface Yelp()

@property (strong, nonatomic) OAConsumer *consumer;
@property (strong, nonatomic) OAToken *token;
@property (strong, nonatomic) id<OASignatureProviding, NSObject> provider;

@end

#define YELP_URL_PREFIX @"http://api.yelp.com/v2/search?"

@implementation Yelp

- (id)init {
    self = [super init];
    
    if (self) {
        self.consumer = [[OAConsumer alloc] initWithKey:@"TCbD1DubslkgMWxUsLafPg" secret:@"hNCSOZAArk5g6EXVdr8Zd_NCJ4g"];
        self.token = [[OAToken alloc] initWithKey:@"cDbHnyiyHFA_9GWb4psZwKoeQwj-S6oF" secret:@"sUgKWhL3E60a0TAqU_0bYoNL_b4"];
        self.provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    }
    
    return self;
}

- (NSURL*)getURLWithTerm:(NSString*)term location:(NSString*)location {
    term = [term stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    location = [location stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *urlAsString = [NSString stringWithFormat:@"%@term=%@&location=%@", YELP_URL_PREFIX, term, location];
    return [NSURL URLWithString:urlAsString];
}

- (void)search:(NSString*)term
      location:(NSString*)location
      callback:(void (^) (BOOL success, NSArray *results))block
{
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[self getURLWithTerm:term location:location]
                                                                   consumer:self.consumer
                                                                      token:self.token
                                                                      realm:nil
                                                          signatureProvider:self.provider];
    [request prepare];
    
    NSURLSessionTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            block(NO, nil);
        } else {
            NSError *e;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&e];
            if (e) {
                block(NO, nil);
            } else {
                NSMutableArray *yelpResponse = [[NSMutableArray alloc] init];
                
                NSArray *arr = [json valueForKey:@"businesses"];
                
                for (NSDictionary *d in arr) {
                    NSNumber *reviewCount = [d objectForKey:@"review_count"];
                    NSNumber *phone = [d objectForKey:@"phone"];
                    
                    YelpSearchResult *y = [[YelpSearchResult alloc] init];
                    y.name = [d objectForKey:@"name"];
                    y.rating = [d objectForKey:@"rating"];
                    y.numReviews = [reviewCount integerValue];
                    y.phone = [phone integerValue];
                    y.url = [d objectForKey:@"url"];
                    y.imageURL = [d objectForKey:@"image_url"];
                    
                    [yelpResponse addObject:y];
                }
                
                block(YES, yelpResponse);
            }
        }
    }];
    [task resume];
}

@end
