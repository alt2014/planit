//
//  POIEditViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "POIEditViewController.h"

#define whenPickerIndex 2
#define startPickerIndex 5
#define endPickerIndex 7
#define addrIndex 3
#define notesIndex 8
#define datePickerCellHeight 164

@interface POIEditViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (assign) BOOL whenPickerIsShowing;
@property (assign) BOOL startPickerIsShowing;
@property (assign) BOOL endPickerIsShowing;
@property (strong, nonatomic) NSDate *selectedWhen;
@property (strong, nonatomic) NSDate *selectedStart;
@property (strong, nonatomic) NSDate *selectedEnd;
@property (strong, nonatomic) UITextField *activeTextField;
@end


@implementation POIEditViewController

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
    [self setUpLabels];
    [self signUpForKeyboardNotifications];
    [self hideDatePickerCell:@"start"];
    [self hideDatePickerCell:@"end"];
    [self hideDatePickerCell:@"when"];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Helper methods

- (void)setUpLabels {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [self.timeFormatter setDateStyle:NSDateFormatterNoStyle];
    
    //if the event exists, then prefill in all values
    NSDate *defaultDate = [NSDate date]; //eventually make this the trip start date
    
    self.startLabel.text = [self.timeFormatter stringFromDate:defaultDate];
    self.endLabel.text = [self.timeFormatter stringFromDate:defaultDate];
    self.whenLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.selectedStart = defaultDate;
    self.selectedEnd = defaultDate;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.endPickerIsShowing || self.startPickerIsShowing || self.whenPickerIsShowing){
        
        [self hideDatePickerCell:@"start"];
        [self hideDatePickerCell:@"end"];
        [self hideDatePickerCell:@"when"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == startPickerIndex){
        height = self.startPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if(indexPath.row == endPickerIndex){
        height = self.endPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if (indexPath.row == whenPickerIndex){
        height = self.whenPickerIsShowing ? datePickerCellHeight : 0.0f;
    }
    
    if (indexPath.row == addrIndex || indexPath.row == notesIndex) {
        height = datePickerCellHeight;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == startPickerIndex - 1){
        
        if (self.startPickerIsShowing){
            
            [self hideDatePickerCell:@"start"];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell:@"start"];
        }
    }
    if (indexPath.row == endPickerIndex - 1){
        
        if (self.endPickerIsShowing){
            
            [self hideDatePickerCell:@"end"];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell:@"end"];
        }
    }
    
    if (indexPath.row == whenPickerIndex - 1){
        
        if (self.whenPickerIsShowing){
            
            [self hideDatePickerCell:@"when"];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell:@"when"];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"]) {
        self.startPickerIsShowing = YES;
    } else if([which isEqualToString:@"end"]){
        self.endPickerIsShowing = YES;
    } else
        self.whenPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    if ([which isEqualToString:@"start"]) {
        self.startDatePicker.hidden = NO;
        self.startDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.startDatePicker.alpha = 1.0f;
        }];
    } else if ([which isEqualToString:@"end"]){
        self.endDatePicker.hidden = NO;
        self.endDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.endDatePicker.alpha = 1.0f;
        }];
    } else {
        self.whenDatePicker.hidden = NO;
        self.whenDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.whenDatePicker.alpha = 1.0f;
        }];
    }
}

- (void)hideDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"])
        self.startPickerIsShowing = NO;
    else if ([which isEqualToString:@"end"])
        self.endPickerIsShowing = NO;
    else
        self.whenPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if ([which isEqualToString:@"start"])
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.startDatePicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.startDatePicker.hidden = YES;
                         }];
    else if([which isEqualToString:@"end"])
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.endDatePicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.endDatePicker.hidden = YES;
                         }];
    else
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.whenDatePicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.whenDatePicker.hidden = YES;
                         }];
}


#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
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

- (IBAction)whenDatePickerChanged:(UIDatePicker *)sender {
    self.whenLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    
    self.selectedWhen = sender.date;
}

- (IBAction)startDatePickerChanged:(UIDatePicker *)sender {
    self.startLabel.text = [self.timeFormatter stringFromDate:sender.date];
    self.selectedStart = sender.date;
}

- (IBAction)endDatePickerChanged:(UIDatePicker *)sender {
    self.endLabel.text = [self.timeFormatter stringFromDate:sender.date];
    self.selectedEnd = sender.date;
}

- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveClicked:(UIBarButtonItem *)sender {
}
@end
