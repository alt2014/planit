//
//  TripAddViewController.m
//  planit
//
//  Created by Anh Truong on 5/29/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "TripAddViewController.h"
#import "PITrip+Model.h"
#import "DataManager.h"

#define startPickerIndex 2
#define endPickerIndex 4
#define datePickerCellHeight 164

@interface TripAddViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign) BOOL startPickerIsShowing;
@property (assign) BOOL endPickerIsShowing;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(nonatomic, readonly, getter=isEditing) BOOL editing;

@property (strong, nonatomic) NSDate *selectedStart;

@property (strong, nonatomic) NSDate *selectedEnd;
 
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleButton;

@end



@implementation TripAddViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDateLabels];
    [self signUpForKeyboardNotifications];
    [self hideDatePickerCell:@"start"];
    [self hideDatePickerCell:@"end"];
    if (!self.trip)
        self.title = @"Add a Trip";
}

-(void)dismissKeyboard
{
    if (self.nameTextField) [self.nameTextField resignFirstResponder];
}

#pragma mark - Helper methods

- (void)setupDateLabels {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self.startLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.endLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.selectedStart = defaultDate;
    self.selectedEnd = defaultDate;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.endPickerIsShowing || self.startPickerIsShowing){
        
        [self hideDatePickerCell:@"start"];
        [self hideDatePickerCell:@"end"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.row == startPickerIndex){
         height = self.startPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if(indexPath.row == endPickerIndex){
        height = self.endPickerIsShowing ? datePickerCellHeight : 0.0f;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1){
        [self hideDatePickerCell:@"end"];
        if (self.startPickerIsShowing){
            
            [self hideDatePickerCell:@"start"];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell:@"start"];
        }
    } else if (indexPath.row == 3){
        [self hideDatePickerCell:@"start"];
        if (self.endPickerIsShowing){
            
            [self hideDatePickerCell:@"end"];
            
        }else {
            
            [self.activeTextField resignFirstResponder];
            [self showDatePickerCell:@"end"];
        }
    } else {
        [self hideDatePickerCell:@"start"];
        [self hideDatePickerCell:@"end"];
    }
    
    [self dismissKeyboard];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"]) {
        self.startPickerIsShowing = YES;
    } else
        self.endPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    if ([which isEqualToString:@"start"]) {
        self.startDatePicker.hidden = NO;
        self.startDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.startDatePicker.alpha = 1.0f;
        }];
    } else {
        self.endDatePicker.hidden = NO;
        self.endDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            self.endDatePicker.alpha = 1.0f;
        }];
    }
}

- (void)hideDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"])
        self.startPickerIsShowing = NO;
    else
        self.endPickerIsShowing = NO;
    
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
    else
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.endDatePicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.endDatePicker.hidden = YES;
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

- (IBAction)startDateChanged:(UIDatePicker *)sender {
    
    self.startLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    self.selectedStart = sender.date;
}

- (IBAction)endDateChanged:(UIDatePicker *)sender {
    
    self.endLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    
    self.selectedEnd = sender.date;
}


- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)savePressed:(UIBarButtonItem *)sender {
    NSMutableDictionary *trip = [[NSMutableDictionary alloc] init];
    NSDate *start = self.selectedStart;
    NSDate *end = self.selectedEnd;
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startComps = [calendar components:unitFlags fromDate:start];
    startComps.hour = 0;
    startComps.minute = 0;
    startComps.second = 0;
    start = [calendar dateFromComponents:startComps];
    
    NSDateComponents *endComps = [calendar components:unitFlags fromDate:end];
    endComps.hour = 23;
    endComps.minute = 59;
    endComps.second = 59;
    end = [calendar dateFromComponents:endComps];
    if (!self.trip) {
        [trip setObject:self.nameTextField.text forKey:T_NAME_KEY];
        [trip setObject:start   forKey:T_START_KEY];
        [trip setObject:end forKey:T_END_KEY];
        [trip setObject:@"with some freindss" forKey:T_NOTES_KEY];
        NSManagedObjectContext *context = [DataManager getManagedObjectContext];
        PITrip *t = [PITrip createTripFromDictionary:trip inManagedObjectContext:context];
    } else {
        
    }
    [self.delegate updateTableDataSource];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
