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
@property (weak, nonatomic) IBOutlet UILabel *travelEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmationNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *departureLocationLabel;
@property (weak, nonatomic) IBOutlet UITextView *arrivalLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
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
    self.travelEventLabel.text = self.event.name;
    self.routeLabel.text = self.event.routeNumber;
    self.confirmationNumberLabel.text = self.event.confirmationNumber;
    self.departureLocationLabel.text = self.event.departureLocation;
    self.arrivalLocationLabel.text = self.event.arrivalLocation;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"MMMM dd YYYY"];
    NSString *dateStart = [dateFormatter stringFromDate:self.event.start];
    self.dateLabel.text = dateStart;
    
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *startTime = [dateFormatter stringFromDate:self.event.start];
    self.departureTimeLabel.text = startTime;
    NSString *endTime = [dateFormatter stringFromDate:self.event.end];
    self.arrivalTimeLabel.text = endTime;
    
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
