//
//  WeatherForecast.h
//  Weather
//
//  Created by John Wu on 6/8/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyForecast.h"
#import <CoreLocation/CoreLocation.h>
#define NO_WEATHER 401

@interface WeatherForecast : NSObject

@property (strong, nonatomic) NSMutableArray* forecast;
@property (strong, nonatomic) NSString *location;
+(void) getFourDayForecast:(WeatherForecast*)forecast location:(CLLocationCoordinate2D)coordinate callback:(void (^)(WeatherForecast *weather, NSError *error))block;

@end
