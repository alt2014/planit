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

- (void)getCurrentCurrencyRates
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://openexchangerates.org/api/latest.json?app_id=%@", API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    // logs url
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingCurrencyFailedWithError:error];
        } else {
            [self.delegate receivedCurrencyJSON:data];
        }
    }];
}

@end
