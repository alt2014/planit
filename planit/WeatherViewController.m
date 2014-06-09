//
//  WeatherViewController.m
//  planit
//
//  Created by Peter Phan on 6/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherForecast.h"
#import "GeoLocation.h"
#import "SWRevealViewController.h"
@interface WeatherViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) WeatherForecast *forecast;
@property (weak, nonatomic) IBOutlet UILabel *primaryWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *primaryH;
@property (weak, nonatomic) IBOutlet UILabel *primaryL;
@property (weak, nonatomic) IBOutlet UITextView *primaryDesc;

@property (weak, nonatomic) IBOutlet UILabel *day1;
@property (weak, nonatomic) IBOutlet UILabel *day2;
@property (weak, nonatomic) IBOutlet UILabel *day3;
@property (weak, nonatomic) IBOutlet UILabel *h1;
@property (weak, nonatomic) IBOutlet UILabel *h2;
@property (weak, nonatomic) IBOutlet UILabel *h3;
@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;
@property (weak, nonatomic) IBOutlet UILabel *l3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *temperatureControl;
@property (strong, nonatomic) UIImageView *primary;
@property (strong, nonatomic) UIImageView *i1;
@property (strong, nonatomic) UIImageView *i2;
@property (strong, nonatomic) UIImageView *i3;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

BOOL usingFahrenheit;

@implementation WeatherViewController

- (void)loadWeatherManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
    
    
    self.forecast = [[WeatherForecast alloc] init];
    self.forecast.forecast = [[NSMutableArray alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    if (!self.forecast) {
        self.forecast = [[WeatherForecast alloc] init];
    }
    
    NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [WeatherForecast getFourDayForecast:self.forecast location:location.coordinate callback:^(WeatherForecast *weather, NSError *error) {
        if (error) {
            self.forecast = nil;
        } else {
            self.forecast = weather;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setABunchOfShit];
            });
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

- (void)setLabelsForForecast:(DailyForecast*)forecast high:(UILabel *)high low:(UILabel *)low {
    if (usingFahrenheit) {
        high.text = [NSString stringWithFormat:@"H: %@°F", forecast.highf];
        low.text = [NSString stringWithFormat:@"L: %@°F", forecast.lowf];
    } else {
        high.text = [NSString stringWithFormat:@"H: %@°C", forecast.highc];
        low.text = [NSString stringWithFormat:@"L: %@°C", forecast.lowc];
    }
    
    if ([forecast.highf length] == 0) {
        high.text = @"";
    }
    if ([forecast.lowc length] == 0) {
        low.text = @"";
    }
}

- (void)setABunchOfShit {
    NSMutableArray *forecasts = self.forecast.forecast;
    DailyForecast *primary = [forecasts objectAtIndex:0];
    DailyForecast *one = [forecasts objectAtIndex:1];
    DailyForecast *two = [forecasts objectAtIndex:2];
    DailyForecast *three = [forecasts objectAtIndex:3];
    
    self.primaryWeatherLabel.text = primary.day;
    [self setLabelsForForecast:primary high:self.primaryH low:self.primaryL];
    [self setLabelsForForecast:one high:self.h1 low:self.l1];
    [self setLabelsForForecast:two high:self.h2 low:self.l2];
    [self setLabelsForForecast:three high:self.h3 low:self.l3];
    if (usingFahrenheit) {
        self.primaryDesc.text = primary.fcttext;
    } else {
        self.primaryDesc.text = primary.fcttext_metric;
    }
    self.day1.text = one.day;
    self.day2.text = two.day;
    self.day3.text = three.day;

    BOOL alloced = self.primary != nil;
    
    int size = 50;
    int offset = 30;
    
    if (!alloced) {
        CGPoint pp = self.primaryWeatherLabel.frame.origin;
        CGPoint d1 = self.day1.frame.origin;
        CGPoint d2 = self.day2.frame.origin;
        CGPoint d3 = self.day3.frame.origin;
        
        self.primary = [[UIImageView alloc] initWithFrame:CGRectMake(pp.x, pp.y+offset, size, size)];
        self.i1 = [[UIImageView  alloc] initWithFrame:CGRectMake(d1.x, d1.y+offset, size, 50)];
        self.i2 = [[UIImageView alloc] initWithFrame:CGRectMake(d2.x, d2.y+offset, size, size)];
        self.i3 = [[UIImageView alloc] initWithFrame:CGRectMake(d3.x, d3.y+offset, size, size)];
    }
    

    [self.primary setImage:[UIImage imageNamed:primary.iconurl]];
    [self.i1 setImage:[UIImage imageNamed:one.iconurl]];
    [self.i2 setImage:[UIImage imageNamed:two.iconurl]];
    [self.i3 setImage:[UIImage imageNamed:three.iconurl]];
    
    if (!alloced) {
        [self.view addSubview:self.primary];
        [self.view addSubview:self.i1];
        [self.view addSubview:self.i2];
        [self.view addSubview:self.i3];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    [GeoLocation geocodeLocation:@"Stanford" callback:^(WeatherForecast *forecast, NSError *error) {
        if (error) {
            if (error.code == NO_WEATHER) {
                // Some error occured and no weather data was given
                NSString *message = [NSString stringWithFormat:@"Please try again."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Not Found"
                                                                        message:@"Please check spelling and try again."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.forecast = forecast;
                [self setABunchOfShit];
            });
        }
    }];

}

- (IBAction)backButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    [GeoLocation geocodeLocation:@"Stanford" callback:^(WeatherForecast *weather, NSError *error) {
    //       //Show the views or handle the errors
    //        //Code: 400 - can't be geocoded
    //        //code: 401 - location has no weather data but was geocoded
    //    }];
    NSLog(@"%@", searchBar.text);
    [GeoLocation geocodeLocation:searchBar.text callback:^(WeatherForecast *forecast, NSError *error) {
        if (error) {
            if (error.code == NO_WEATHER) {
                // Some error occured and no weather data was given
                NSString *message = [NSString stringWithFormat:@"Please try again."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Not Found"
                                                                        message:@"Please check spelling and try again."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.forecast = forecast;
                [self setABunchOfShit];
            });
        }
    }];
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Do any additional setup after loading the view.
    [self loadWeatherManager];
    
    if (self.temperatureControl.selectedSegmentIndex == 0) {
        usingFahrenheit = YES;
    } else {
        usingFahrenheit = NO;
    }
    
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changedTemperatureMetric:(id)sender {
    if (self.temperatureControl.selectedSegmentIndex == 0) {
        usingFahrenheit = YES;
    } else {
        usingFahrenheit = NO;
    }
    [self setABunchOfShit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
