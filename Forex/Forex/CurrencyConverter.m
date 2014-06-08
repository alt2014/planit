//
//  CurrencyConverter.m
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import "CurrencyConverter.h"

@implementation CurrencyConverter
+ (Currency *) currencyRatesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    // Parses JSON and stores into dictionary
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    // Returns array containing results of invoking valueForKey on "rates" (should return all currencies relative to USD)
    NSDictionary *rateData = [parsedObject valueForKey:@"rates"];
    
    Currency *currencyRates = [[Currency alloc] init];
    
    // TEST CODE - DELETE WHEN DONE!
    [currencyRates setValue:@"CNY" forKey:@"countryCode1"];
    [currencyRates setValue:@"GBP" forKey:@"countryCode2"];
    
    NSDecimalNumber *firstCountryRate = nil;
    NSDecimalNumber *secondCountryRate = nil;
    
    // Find the rate to USD for the user selected countries
    for (NSString *key in rateData) {
        //NSLog(@"Key: %@", key);
        if ([key isEqualToString:[currencyRates countryCode1]] || [key isEqualToString:[currencyRates countryCode2]]) {
            NSNumber *rate = [rateData objectForKey:key];
          
            if ([key isEqualToString:[currencyRates countryCode1]]) {
                firstCountryRate = [NSDecimalNumber decimalNumberWithDecimal:[rate decimalValue]];
                NSLog(@"First country rate: %@", firstCountryRate);
            } else {
                secondCountryRate = [NSDecimalNumber decimalNumberWithDecimal:[rate decimalValue]];
                NSLog(@"Second country rate: %@", secondCountryRate);
            }
        }
    }
    
    // Find the conversion rate between the two currencies.
    [currencyRates setValue:[secondCountryRate decimalNumberByDividingBy:firstCountryRate] forKey:@"exchangeRate"];
    
    NSLog(@"Exchange rate: %@", [currencyRates exchangeRate]);
    
    return currencyRates;
}

@end
