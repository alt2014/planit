//
//  Currency.h
//  Forex
//
//  Currency class is used to store the two country codes and the exchange rate
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (strong, nonatomic) NSString *countryCode1;
@property (strong, nonatomic) NSString *countryCode2;
@property (strong, nonatomic) NSDecimalNumber *exchangeRate;

@end
