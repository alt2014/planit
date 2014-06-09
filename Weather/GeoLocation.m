//
//  GeoLocation.m
//  Weather
//
//  Created by John Wu on 6/8/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import "GeoLocation.h"
#import "DailyForecast.h"

#define API_KEY @"AIzaSyBgGT3MCcdLtYh06ORqwTBX-7-k-oYi57U"
#define OKAY @"OK"
#define STATUS @"status"
#define RESULTS @"results"
#define GEOMETRY @"geometry"
#define LOCATION @"location"
#define LATITUDE @"lat"
#define LONGITUDE @"lng"


@implementation GeoLocation

/* Calling this will call a callback function with the WeatherForecast for the next four days (see DailyForecast.h and WeatherForecast.h)
 */

+(void)geocodeLocation:(NSString *)location callback:(void (^)(WeatherForecast *forecast, NSError *error))block
{
    NSString * escapedLocation = [location stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlAsString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=%@", escapedLocation, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    WeatherForecast *forecast = [[WeatherForecast alloc] init];
    forecast.forecast = [[NSMutableArray alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // Could not connect to internet?
        if (error) {
            block(forecast, error);
        } else {
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (error != nil) {
                block(forecast, error); //could not properly parse JSON
            } else {
                if ([[parsedObject valueForKey:STATUS] isEqualToString:OKAY]) {
                    CLLocationCoordinate2D coordinate = [GeoLocation parseData:parsedObject];
                    NSLog(@"LAT: %f, LNG: %f", coordinate.latitude, coordinate.longitude);
                    [WeatherForecast getFourDayForecast:forecast location:coordinate callback:^(WeatherForecast *forecast,NSError *error) {
                        block(forecast, error);
                    }];
                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Not Found"
//                                                                            message:@"Please check spelling and try again."
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
//                    });
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:@"Location request was invalid" forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"invalid_location" code:INVALID_LOCATION userInfo:errorDetail];
                    block(forecast, error);
                }
            }
        }
    }];
    
}

+(CLLocationCoordinate2D)parseData:(NSDictionary*)data
{
    CLLocationCoordinate2D coordinate;
    NSDictionary *coordinates = [[data valueForKey:RESULTS] objectAtIndex:0];
    NSDictionary *geometry = [coordinates valueForKey:GEOMETRY];
    NSDictionary *location = [geometry valueForKey:LOCATION];
    coordinate.latitude = [[location objectForKey:LATITUDE] doubleValue];
    coordinate.longitude = [[location objectForKey:LONGITUDE] doubleValue];
    return coordinate;
}
@end
