//
//  CurrencyCommunicator.m
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import "CurrencyCommunicator.h"
#import "CurrencyCommunicatorDelegate.h"

#define API_KEY @"a7c9542a45fa48bcb9d2f7fcc201eea1"

@implementation CurrencyCommunicator

- (void)getCurrentCurrencyRates:(Currency*)exchangeRate callback:(void (^)(NSError *error, Currency *currency))callback
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://openexchangerates.org/api/latest.json?app_id=%@", API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    // logs url
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            callback(error, nil);
        } else {
            
            NSLog(@"calling receivedCurrencyJSON");
            
            // Parses JSON and stores into dictionary
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            // Returns array containing results of invoking valueForKey on "rates" (should return all currencies relative to USD)
            NSDictionary *rateData = [parsedObject valueForKey:@"rates"];
            
            
            
            
            
            NSDecimalNumber *firstCountryRate = nil;
            NSDecimalNumber *secondCountryRate = nil;
            
            // Find the rate to USD for the user selected countries
            for (NSString *key in rateData) {
                //NSLog(@"Key: %@", key);
                if ([key isEqualToString:[exchangeRate countryCode1]] || [key isEqualToString:[exchangeRate countryCode2]]) {
                    NSNumber *rate = [rateData objectForKey:key];
                    
                    if ([key isEqualToString:[exchangeRate countryCode1]]) {
                        firstCountryRate = [NSDecimalNumber decimalNumberWithDecimal:[rate decimalValue]];
                        NSLog(@"First country rate: %@", firstCountryRate);
                    } else {
                        secondCountryRate = [NSDecimalNumber decimalNumberWithDecimal:[rate decimalValue]];
                        NSLog(@"Second country rate: %@", secondCountryRate);
                    }
                }
            }
            
            // Find the conversion rate between the two currencies.
            [exchangeRate setValue:[secondCountryRate decimalNumberByDividingBy:firstCountryRate] forKey:@"exchangeRate"];
            
            NSLog(@"Exchange rate: %@", [exchangeRate exchangeRate]);
            
            callback(error, exchangeRate);
            // [self.delegate receivedCurrencyJSON:data countries:exchangeRate];
        }
    }];
}

@end
