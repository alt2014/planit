//
//  TransportationViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "TransportationViewController.h"
#import "PITransportation.h"

@interface TransportationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *transportationName;
@property (weak, nonatomic) IBOutlet UILabel *routeNumber;
@property (weak, nonatomic) IBOutlet UILabel *confirmationNumber;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *location;
//@property (weak, nonatomic) IBOutlet UITextView *arrivalLocation;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UITextView *notesField;

@end

@implementation TransportationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLabels];
    // Do any additional setup after loading the view.
}

- (void)setLabels
{
    self.transportationName.text = self.event.name;
    self.routeNumber.text = self.event.routeNumber;
    self.confirmationNumber.text = self.event.confirmationNumber;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"MMM dd, YYYY"];
    NSString *date = [dateFormatter stringFromDate:self.event.start];
    self.dateLabel.text = date;
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *startTime = [dateFormatter stringFromDate:self.event.start];
    NSString *endTime = [dateFormatter stringFromDate:self.event.end];
    NSString *time = [NSString stringWithFormat:@"%@ to %@", startTime, endTime];
    self.time.text = time;
    NSLog(@"Departure Location: %@", self.event.addr);
    NSString *tripLocations = [NSString stringWithFormat:@"%@ to %@", self.event.addr, self.event.arrivalLocation];
    self.location.text = tripLocations;
    
    self.notesField.text = self.event.notes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
