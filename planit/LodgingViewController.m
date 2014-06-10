//
//  LodgingViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "LodgingViewController.h"
#import "PILodging.h"

@interface LodgingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *checkInTime;
@property (weak, nonatomic) IBOutlet UILabel *checkOutTime;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmationNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesField;

@end

@implementation LodgingViewController

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
    [self displayLabels];
    // Do any additional setup after loading the view.
}
- (void)displayLabels
{
    self.title = self.event.name;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"MMM dd at h:mm a"];
    NSString *dateStart = [dateFormatter stringFromDate:self.event.start];
    self.checkInTime.text = dateStart;
    NSString *dateEnd = [dateFormatter stringFromDate:self.event.end];
    self.checkOutTime.text = dateEnd;
    
    self.addressLabel.text = self.event.addr;
    self.phoneLabel.text = self.event.phone;
    self.confirmationNumberLabel.text = self.event.confirmationNumber;
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
