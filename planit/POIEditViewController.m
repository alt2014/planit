//
//  POIEditViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "POIEditViewController.h"
#import "Event.h"
#import "Address.h"

#define whenPickerIndex 2
#define startPickerIndex 5
#define endPickerIndex 7
#define addrIndex 3
#define notesIndex 8
#define datePickerCellHeight 164

@interface POIEditViewController ()
@property (assign) BOOL whenPickerIsShowing;
@property (assign) BOOL startPickerIsShowing;
@property (assign) BOOL endPickerIsShowing;
@property (assign) BOOL isNewEvent;
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
    if (!self.event){
        self.event = [[Event alloc] init];
        self.isNewEvent = YES;
    } else
        self.isNewEvent = NO;
    [self initFields];
    [self signUpForKeyboardNotifications];
    [self hideDatePickerCell:self.startDatePicker pickerIsShowing:self.startPickerIsShowing];
    [self hideDatePickerCell:self.endDatePicker pickerIsShowing:self.endPickerIsShowing];
    [self hideDatePickerCell:self.whenDatePicker pickerIsShowing:self.whenPickerIsShowing];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Helper methods

- (void)initFields {
    if (self.event.name) {
        self.nameField.text = self.event.name;
    }
    if (self.event.notes) {
        self.notesTextView.text = self.event.notes;
    }
    
    if (self.event.addr) {
        self.streetField.text = self.event.addr.street;
        self.cityField.text = self.event.addr.city;
        self.postalCodeField.text = [NSString stringWithFormat: @"%d", (int)self.event.addr.postal];        self.countryField.text = self.event.addr.country;
    }
    //if the event exists, then prefill in all values
    NSDate *defaultDate = [NSDate date]; //eventually make this the trip start date

    self.startLabel.text = self.event.start ? [self.timeFormatter stringFromDate:self.event.start] : [self.timeFormatter stringFromDate:defaultDate];
    self.endLabel.text = self.event.end ? [self.timeFormatter stringFromDate:self.event.end] : [self.timeFormatter stringFromDate:defaultDate];
    self.whenLabel.text = self.event.when ? [self.timeFormatter stringFromDate:self.event.when] : [self.dateFormatter stringFromDate:defaultDate];
    self.selectedStart = self.event.start ? self.event.start : defaultDate;
    self.selectedEnd = self.event.end? self.event.end : defaultDate;
    //make when the first day of the trip
    self.selectedWhen = self.event.when ? self.event.when : defaultDate;
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.endPickerIsShowing || self.startPickerIsShowing || self.whenPickerIsShowing){
        
        [self hideDatePickerCell:self.startDatePicker pickerIsShowing:self.startPickerIsShowing];
        [self hideDatePickerCell:self.endDatePicker pickerIsShowing:self.endPickerIsShowing];
        [self hideDatePickerCell:self.whenDatePicker pickerIsShowing:self.whenPickerIsShowing];
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

-(void)dateLabelSelectHandler:(BOOL)pickerIsShowing datePicker:(UIDatePicker *)datePicker {
    if (pickerIsShowing) {
        [self hideDatePickerCell:datePicker pickerIsShowing:pickerIsShowing];
        //hide the picker
    } else {
        [self showDatePickerCell:datePicker pickerIsShowing:pickerIsShowing];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == startPickerIndex - 1)
        [self dateLabelSelectHandler:self.startPickerIsShowing datePicker:self.startDatePicker];
    if (indexPath.row == endPickerIndex - 1)
        [self dateLabelSelectHandler:self.startPickerIsShowing datePicker:self.endDatePicker];
    
    if (indexPath.row == whenPickerIndex - 1){
        [self dateLabelSelectHandler:self.startPickerIsShowing datePicker:self.whenDatePicker];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) showDatePickerCell:(UIDatePicker *)datePicker pickerIsShowing:(BOOL)pickerIsShowing
{
    pickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    datePicker.hidden = NO;
    datePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        datePicker.alpha = 1.0f;
    }];
}

/*
 

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
 */

- (void)hideDatePickerCell:(UIDatePicker *)datePicker pickerIsShowing:(BOOL) pickerIsShowing
{
    pickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         datePicker.hidden = YES;
                     }];
}
/*
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
*/

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
    Address *addr = [[Address alloc] initWithStreet:self.streetField.text city:self.cityField.text state:NULL country:self.countryField.text postal:[self.postalCodeField.text integerValue]];
    
    self.event.name = self.nameField.text;
    self.event.when = self.selectedWhen;
    self.event.start = self.selectedStart;
    self.event.end = self.selectedEnd;
    self.event.addr = addr;
    self.event.notes = self.notesTextView.text;
    
    [self.delegate saveEventDetails:self.event isNewEvent:self.isNewEvent];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
