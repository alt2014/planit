//
//  CurrencyCommunicatorDelegate.h
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CurrencyCommunicatorDelegate <NSObject>

- (void)receivedCurrencyJSON:(NSData *)objectNotation countries:(Currency*)exchangeRate;
- (void)fetchingCurrencyFailedWithError:(NSError *)error;

@end
