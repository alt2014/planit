//
//  DailyForecast.h
//  Weather
//
//  Created by John Wu on 6/8/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyForecast : NSObject

@property (strong, nonatomic) NSString *day; // "Jun 6"
@property (strong, nonatomic) NSString *iconurl; // Web URL of icon corresponding to weather
@property (strong, nonatomic) NSString *fcttext; // Description: "Sunny. Lows overnight in the low 60s"
@property (strong, nonatomic) NSString *fcttext_metric; // Same as above in metric
@property (strong, nonatomic) NSString *highf; // high temp in Fahrenheit
@property (strong, nonatomic) NSString *lowf; // low temp in F
@property (strong, nonatomic) NSString *highc; //high temp in celsius
@property (strong, nonatomic) NSString *lowc; //low temp in celsius


@end
