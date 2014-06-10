//
//  POIEditViewController.m
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "POIEditViewController.h"
#import "PIEvent.h"
#import "PIDay+Model.h"
#import "PIEvent+Model.h"
#import "PIDay.h"
#import "PITrip.h"
#import "PITrip+Model.h"
#import "DataManager.h"

#define numRows 12
#define datePickerCellHeight 168
#define deleteRowHeight 39
#define notesRowHeight 67
#define firstCellHeight 68
#define dayPickerRow 4
#define startPickerRow 6
#define endPickerRow 8
#define notesRow 10
#define deleteRow 11
#define standardRowHeight 44

@interface POIEditViewController ()
@property (assign) BOOL dayPickerIsShowing;
@property (assign) BOOL startPickerIsShowing;
@property (assign) BOOL endPickerIsShowing;
@property (assign) BOOL isNewEvent;
@property (strong, nonatomic) NSDate *selectedWhen;
@property (strong, nonatomic) NSDate *selectedStart;
@property (strong, nonatomic) NSDate *selectedEnd;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
- (IBAction)whenDatePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *whenDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *whenDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
- (IBAction)startDatePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDatePickerCell;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
- (IBAction)endDatePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
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
    self.isNewEvent = self.event ? NO : YES;
    [self initFields];
    [self signUpForKeyboardNotifications];
    [self hideDatePickerCell:@"start"];
    [self hideDatePickerCell:@"end"];
    [self hideDatePickerCell:@"when"];
    
    self.title = @"Add Point of Interest";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods

- (void)initFields {
    //regardless of whether or not there's event exists
    //force min day to be strart of trip and max day to be end of trip
    //send in the trip
    self.whenDatePicker.minimumDate = self.trip.start;
    self.whenDatePicker.maximumDate = self.trip.end;
    
    //if the event is blank
    if (!self.event) {
        self.whenDatePicker.date = self.trip.start;
        self.startDatePicker.date = self.trip.start;
        self.endDatePicker.date = [NSDate dateWithTimeInterval:60 sinceDate:self.startDatePicker.date];
    } else {
        self.nameField.text = self.event.name;
        self.notesTextView.text = self.event.notes;
        self.whenDatePicker.date = self.event.day.date;
        self.startDatePicker.date = self.event.start;
        self.endDatePicker.date = self.event.end;
        self.locationField.text = self.event.addr;
        self.phoneField.text = self.event.phone;
    }
    
    self.selectedWhen = self.whenDatePicker.date;
    self.whenLabel.text = [self.dateFormatter stringFromDate:self.selectedWhen];
    self.selectedStart = self.startDatePicker.date;
    self.startLabel.text = [self.timeFormatter stringFromDate:self.selectedStart];
    self.selectedEnd = self.endDatePicker.date;
    self.endLabel.text = [self.timeFormatter stringFromDate:self.selectedEnd];
}

- (NSDate *)createNSDate:(NSInteger)month day:(NSInteger)day year:(NSInteger)year hour:(NSInteger)hour minute:(NSInteger)minute {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour];
    [comps setMinute:minute];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (void)signUpForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow {
    
    if (self.endPickerIsShowing || self.startPickerIsShowing || self.dayPickerIsShowing){
        
        [self hideDatePickerCell:@"start"];
        [self hideDatePickerCell:@"end"];
        [self hideDatePickerCell:@"when"];
    }
}

- (NSDate *)dateFromDayAndTime:(NSDate *)day time:(NSDate *)time {
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:day];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
    return [self createNSDate:dayComponents.month day:dayComponents.day year:dayComponents.year hour:timeComponents.hour minute:timeComponents.minute];
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = standardRowHeight;
    
    if (indexPath.row == startPickerRow){
        height = self.startPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if(indexPath.row == endPickerRow){
        height = self.endPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if (indexPath.row == dayPickerRow){
        height = self.dayPickerIsShowing ? datePickerCellHeight : 0.0f;
    }
    
    if (indexPath.row == notesRow) {
        return notesRowHeight;
    }
    
    if (indexPath.row == deleteRow) {
        return self.event? deleteRowHeight: 0.0f;
    }
    
    if (indexPath.row == 0)
        return firstCellHeight;
    
    return height;
}

-(void)dateLabelSelectHandler:(BOOL)pickerIsShowing pickerName:(NSString *)pickerName {
    if (pickerIsShowing) {
        [self hideDatePickerCell:pickerName];
    } else {
        [self showDatePickerCell:pickerName];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == startPickerRow - 1)
        [self dateLabelSelectHandler:self.startPickerIsShowing pickerName:@"start"];
    if (indexPath.row == endPickerRow - 1)
        [self dateLabelSelectHandler:self.endPickerIsShowing pickerName:@"end"];
    if (indexPath.row == dayPickerRow - 1){
        [self dateLabelSelectHandler:self.dayPickerIsShowing pickerName:@"when"];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == deleteRow){
        [self.event.day removeEventsObject:self.event];
        [self.delegate updateTableView];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}

- (void)showDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"]) {
        self.startPickerIsShowing = YES;
    } else if([which isEqualToString:@"end"]){
        self.endPickerIsShowing = YES;
    } else
        self.dayPickerIsShowing = YES;
    
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
        self.dayPickerIsShowing = NO;
    
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


#pragma mark - IBAction Listeners
- (IBAction)whenDatePickerChanged:(UIDatePicker *)sender {
    self.whenLabel.text =  [self.dateFormatter stringFromDate:sender.date];
    self.selectedWhen = sender.date;
}

- (IBAction)startDatePickerChanged:(UIDatePicker *)sender {
    self.startLabel.text = [self.timeFormatter stringFromDate:sender.date];
    self.selectedStart = sender.date;
    self.endDatePicker.minimumDate = [NSDate dateWithTimeInterval:60 sinceDate:sender.date];
    if (self.selectedEnd < self.selectedStart){
        self.endDatePicker.date = self.endDatePicker.minimumDate;
        self.endLabel.text = [self.timeFormatter stringFromDate:self.endDatePicker.date];
        self.selectedEnd = self.endDatePicker.date;
    }
}

- (IBAction)endDatePickerChanged:(UIDatePicker *)sender {
    self.endLabel.text = [self.timeFormatter stringFromDate:sender.date];
    self.selectedEnd = sender.date;
}

- (IBAction)saveClicked:(UIBarButtonItem *)sender {
    NSDate *start = [self dateFromDayAndTime:self.selectedWhen time:self.selectedStart];
    NSDate *end = [self dateFromDayAndTime:self.selectedWhen time:self.selectedEnd];
    if (self.event) {
        [self.event.day removeEventsObject:self.event];
        self.event.name = self.nameField.text;
        self.event.addr = self.locationField.text;
        self.event.notes = self.notesTextView.text;
        self.event.start = start;
        self.event.end = end;
        self.event.phone = self.phoneField.text;
        [[self.trip getDayForDate:self.event.start] addEvent:self.event];
    } else {
        NSMutableDictionary *eventDetails = [[NSMutableDictionary alloc] init];
        [eventDetails setObject:self.nameField.text forKey:E_NAME_KEY];
        [eventDetails setObject:start   forKey:E_START_KEY];
        [eventDetails setObject:end forKey:E_END_KEY];
        [eventDetails setObject:self.notesTextView.text forKey:E_NOTES_KEY];
        [eventDetails setObject:self.locationField.text forKey:E_ADDR_KEY];
        [eventDetails setObject:self.phoneField.text forKey:E_PHONE_KEY];
        NSManagedObjectContext *context = [DataManager getManagedObjectContext];
        PIEvent *e = [PIEvent createEvent:eventDetails inManagedObjectContext:context];
        [[self.trip getDayForDate:self.selectedWhen] addEvent:e];
    }
    [self.delegate updateTableView];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
