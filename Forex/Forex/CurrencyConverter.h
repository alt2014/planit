//
//  CurrencyConverter.h
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface CurrencyConverter : NSObject

+ (Currency *) currencyRatesFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
