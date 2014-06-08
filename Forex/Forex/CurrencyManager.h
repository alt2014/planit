//
//  CurrencyManager.h
//  Forex
//
//  Created by John Wu on 6/6/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyManagerDelegate.h"
#import "CurrencyCommunicatorDelegate.h"

@class CurrencyCommunicator;

@interface CurrencyManager : NSObject<CurrencyCommunicatorDelegate>

@property (strong, nonatomic) CurrencyCommunicator *communicator;
@property (weak, nonatomic) id<CurrencyManagerDelegate> delegate;

@end
