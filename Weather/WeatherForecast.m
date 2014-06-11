//
//  WeatherForecast.m
//  Weather
//
//  Created by John Wu on 6/8/14.
//  Copyright (c) 2014 planit. All rights reserved.
//

#import "WeatherForecast.h"

#define API_KEY @"29e76fbddc8d7c49"
#define FORECAST @"forecast"
#define SIMPLEFORECAST @"simpleforecast"
#define FORECASTDAY @"forecastday"
#define TXTFORECAST @"txt_forecast"
#define FCTTEXT @"fcttext"
#define FCTTEXTMETRIC @"fcttext_metric"
#define ICON @"icon"
#define HIGH @"high"
#define LOW @"low"
#define DEGREEF @"fahrenheit"
#define DEGREEC @"celsius"
#define DATE @"date"
#define MONTH @"monthname_short"
#define DAY @"day"
#define ERROR @"error"
#define DESCRIPTION @"description"
#define RESPONSE @"response"
#define LOCATION @"location"



@implementation WeatherForecast

+(void) getFourDayForecast:(WeatherForecast*)forecast location:(CLLocationCoordinate2D)coordinate callback:(void (^)(WeatherForecast* forecast, NSError *error))block
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/forecast/geolookup/conditions/q/%f,%f.json", API_KEY, coordinate.latitude, coordinate.longitude];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could not connect to the Internet"
                                                                    message:@"Please try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            });
            
            block(forecast, error);
        } else {
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *errorDict = [parsedObject valueForKey:RESPONSE];
            if ([errorDict objectForKey:ERROR]) {
                
                NSDictionary *errors =[errorDict valueForKey:ERROR];
                
                for (NSString *key in errors) {
                    NSLog(@"%@:%@", key, [errors objectForKey:key]);
                }
                // Some error occured and no weather data was given
                NSString *message = [NSString stringWithFormat:@"%@. Please try again.",[errors objectForKey:DESCRIPTION]];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
//                                                                        message:message
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                });
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:message forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"invalid_location" code:NO_WEATHER userInfo:errorDetail];
            } else {
                [WeatherForecast parseWeather:forecast parsedObject:parsedObject];
            }
            block(forecast, error);
        }
    }];

}

// Parses the JSON file and stores the information into the WeatherForecast struct
+(void)parseWeather:(WeatherForecast *)forecast parsedObject:(NSDictionary *)parsedObject
{
    NSDictionary *location = [parsedObject valueForKey:LOCATION];
    forecast.location = [NSString stringWithFormat:@"for %@", [location objectForKey:@"city"]];
    
    NSDictionary *forecastDict = [parsedObject valueForKey:FORECAST];
    
    NSDictionary *simpleforecast = [forecastDict valueForKey:SIMPLEFORECAST];
    NSArray *arrayInfo = [simpleforecast valueForKey:FORECASTDAY];
    for (int i = 0; i < 4; i++) {
        DailyForecast *dayForecast = [[DailyForecast alloc] init];
        NSDictionary *nextDay = [arrayInfo objectAtIndex:i];
        dayForecast.iconurl = [NSString stringWithFormat:@"%@.gif", [nextDay objectForKey:ICON]];
        
        NSDictionary *date = [nextDay valueForKey:DATE];
        if (i > 0) {
            dayForecast.day = [NSString stringWithFormat:@"%@ %@",[date objectForKey:MONTH], [date objectForKey:DAY]];
        } else {
            dayForecast.day = [NSString stringWithFormat:@"%@ %@, %@", [date objectForKey:@"monthname"], [date objectForKey:DAY], [date objectForKey:@"year"]];
        }
        
        NSDictionary *highTemp = [nextDay valueForKey:HIGH];
        dayForecast.highf = [highTemp objectForKey:DEGREEF];
        dayForecast.highc = [highTemp objectForKey:DEGREEC];
        
        
        NSDictionary *lowTemp = [nextDay valueForKey:LOW];
        dayForecast.lowf = [lowTemp objectForKey:DEGREEF];
        dayForecast.lowc = [lowTemp objectForKey:DEGREEC];
     
        [forecast.forecast addObject:dayForecast];
    }
    
    [WeatherForecast getCurrentDay:forecast forecastday:forecastDict];
    
    for (int i = 0; i < 4; i++) {
        DailyForecast *dayForecast = [forecast.forecast objectAtIndex:i];
        NSLog(@"Day: %@", dayForecast.day);
        NSLog(@"High: %@, %@", dayForecast.highf, dayForecast.highc);
        NSLog(@"Low: %@, %@", dayForecast.lowf, dayForecast.lowc);
        NSLog(@"URL: %@", dayForecast.iconurl);
        NSLog(@"FCT: %@", dayForecast.fcttext);
        NSLog(@"FCTM: %@", dayForecast.fcttext_metric);
    }
    

}

// Parses the extra information (text descriptions) for the current day
+(void)getCurrentDay:(WeatherForecast *)forecast forecastday:(NSDictionary *)forecastday
{
    NSArray *array = [[forecastday valueForKey:TXTFORECAST] valueForKey:FORECASTDAY];
    NSDictionary *currDay = [array objectAtIndex:0];
    DailyForecast *currentDayWeather = [forecast.forecast objectAtIndex:0];
    currentDayWeather.fcttext = [currDay valueForKey:FCTTEXT]; //Get text descriptions
    currentDayWeather.fcttext_metric = [currDay valueForKey:FCTTEXTMETRIC];
}


@end
