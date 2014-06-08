//
//  CurrencyManager.m
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import "CurrencyManager.h"
#import "Currency.h"
#import "CurrencyConverter.h"

@implementation CurrencyManager

#pragma mark - CurrencyCommunicatorDelegate

- (void)receivedCurrencyJSON:(NSData *)objectNotation countries:(Currency*)exchangeRate
{
    NSError *error = nil;
    Currency *currencyRates = [CurrencyConverter currencyRatesFromJSON:objectNotation error:&error countries:exchangeRate];
    
    if (error != nil) {
        [self.delegate fetchingCurrencyFailedWithError:error];
    } else {
        [self.delegate didReceiveRates:currencyRates];
    }
    
}

- (void)fetchingCurrencyFailedWithError:(NSError *)error
{
    [self.delegate fetchingCurrencyFailedWithError:error];
}


@end
