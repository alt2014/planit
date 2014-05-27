//
//  Address.h
//  planit
//
//  Created by Peter Phan on 5/26/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (strong, nonatomic) NSString *street; // 111 street ave.
@property (strong, nonatomic) NSString *city; // Redwood
@property (strong, nonatomic) NSString *state; // CA
@property (strong, nonatomic) NSString *country; // US
@property (nonatomic) NSUInteger postal; // 94541

- (id) initWithStreet: (NSString*)street
                 city: (NSString *)city
                state: (NSString*)state
              country: (NSString*)country
               postal:(NSUInteger)postal;

- (NSString*) asString;

@end
