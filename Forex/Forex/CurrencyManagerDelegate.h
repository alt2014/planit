//
//  CurrencyManagerDelegate.h
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@protocol CurrencyManagerDelegate <NSObject>

- (void)didReceiveRates:(Currency *)currencyRates;
- (void)fetchingCurrencyFailedWithError:(NSError *)error;

@end
