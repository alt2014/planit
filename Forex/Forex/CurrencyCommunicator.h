//
//  CurrencyCommunicator.h
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CurrencyCommunicatorDelegate;

@interface CurrencyCommunicator : NSObject

@property (weak, nonatomic) id<CurrencyCommunicatorDelegate> delegate;
// Figure out what to pass in here - a currency class var?
- (void)getCurrentCurrencyRates;

@end
