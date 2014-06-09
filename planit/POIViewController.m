//
//  POIViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "POIViewController.h"
#import "PIEvent.h"


@interface POIViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation POIViewController

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
    self.eventName.text = self.event.name;
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"MMM dd h:mm a"];
    NSString *dateStart = [dateFormatter stringFromDate:self.event.start];
    self.startLabel.text = dateStart;
    
    NSString *dateEnd = [dateFormatter stringFromDate:self.event.end];
    self.endLabel.text = dateEnd;
    
    self.addressLabel.text = self.event.addr;
    self.phoneLabel.text = self.event.phone;
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
