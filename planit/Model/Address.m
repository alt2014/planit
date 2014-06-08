//
//  Address.m
//  planit
//
//  Created by Peter Phan on 5/26/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "Address.h"

@implementation Address

- (id) initWithStreet: (NSString*)street
                 city: (NSString *)city
                state:(NSString *)state
              country:(NSString *)country
               postal:(NSUInteger)postal {
    self = [super init];
    
    if (self) {
        self.street = street;
        self.city = city;
        self.state = state;
        self.country = country;
        self.postal = postal;
    }
    
    return self;
}

// street, city, state, country, postal
- (NSString*)asString {
    return [NSString stringWithFormat:@"%@, %@, %@, %@ %d", self.street, self.city, self.state, self.country, self.postal];
}

@end
