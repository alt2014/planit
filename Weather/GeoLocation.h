//
//  GeoLocation.h
//  Weather
//
//  Created by John Wu on 6/8/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecast.h"
#import <CoreLocation/CoreLocation.h>

#define INVALID_LOCATION 400

@interface GeoLocation : NSObject

+(void)geocodeLocation:(NSString *)location callback:(void (^)(WeatherForecast *forecast, NSError *error))block;

+(CLLocationCoordinate2D)parseData:(NSDictionary*)data;

@end
