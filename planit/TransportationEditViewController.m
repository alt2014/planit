//
//  TransportationEditViewController.m
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//
#define numRows 12
#define datePickerCellHeight 168
#define deleteRowHeight 39
#define notesRowHeight 67
#define firstCellHeight 68
#define startPickerRow 7
#define endPickerRow 9
#define notesRow 10
#define deleteRow 11
#define standardRowHeight 44

#import "TransportationEditViewController.h"
#import "POIEditViewController.h"
#import "PIEvent.h"
#import "PIDay+Model.h"
#import "PIEvent+Model.h"
#import "PIDay.h"
#import "PITrip.h"
#import "PITrip+Model.h"
#import "DataManager.h"
#import "PITransportation+Model.h"
#import "PITransportation.h"
#import "DateCompare.h"

@interface TransportationEditViewController ()
@property (assign) BOOL startPickerIsShowing;
@property (assign) BOOL endPickerIsShowing;
@property (strong, nonatomic) NSDate *selectedStart;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) NSDate *selectedEnd;
@property (strong, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITextField *routeNumberField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *confirmationNumberField;
@property (weak, nonatomic) IBOutlet UITextField *departureLocField;
@property (weak, nonatomic) IBOutlet UITextField *ArrivalLocField;
@property (weak, nonatomic) IBOutlet UITextView *NotesField;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
- (IBAction)startDatePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
- (IBAction)endDatePickerChanged:(UIDatePicker *)sender;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@end

@implementation TransportationEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dateTimeFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateTimeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self initFields];
    [self signUpForKeyboardNotifications];
    [self hideDatePickerCell:@"start"];
    [self hideDatePickerCell:@"end"];
    self.title = @"Add Transportation";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper methods

- (void)initFields {
    // Actually force these to be midnight and 11:59!!!
    //send in the trip
    self.startDatePicker.minimumDate = self.trip.start;
    self.startDatePicker.maximumDate = self.trip.end;
    
    if (!self.event) {
        self.startDatePicker.date = self.startDatePicker.minimumDate;
        self.endDatePicker.date = [NSDate dateWithTimeInterval:60 sinceDate:self.startDatePicker.date];
    } else {
        self.nameField.text = self.event.name;
        self.routeNumberField.text = ((PITransportation *)self.event).routeNumber;
        self.NotesField.text = self.event.notes;
        self.startDatePicker.date = self.event.start;
        self.endDatePicker.date = self.event.end;
        self.departureLocField.text = self.event.addr;
        self.ArrivalLocField.text = ((PITransportation *)self.event).arrivalLocation;
        self.confirmationNumberField.text = ((PITransportation *)self.event).confirmationNumber;
        self.phoneNumberField.text = self.event.phone;
    }
    
    self.selectedStart = self.startDatePicker.date;
    self.startLabel.text = [self.dateTimeFormatter stringFromDate:self.selectedStart];
    self.selectedEnd = self.endDatePicker.date;
    self.endLabel.text = [self.dateTimeFormatter stringFromDate:self.selectedEnd];
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
    
    if (self.startPickerIsShowing || self.endPickerIsShowing){
        
        [self hideDatePickerCell:@"start"];
        [self hideDatePickerCell:@"end"];
    }
}

- (NSDate *)dateFromDayAndTime:(NSDate *)day time:(NSDate *)time {
    NSDateComponents *dayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:day];
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
    return [self createNSDate:dayComponents.month day:dayComponents.day year:dayComponents.year hour:timeComponents.hour minute:timeComponents.minute];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numRows;
}

#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == startPickerRow){
        return self.startPickerIsShowing ? datePickerCellHeight : 0.0f;
    } else if(indexPath.row == endPickerRow){
        return self.endPickerIsShowing ? datePickerCellHeight : 0.0f;
    }
    
    if (indexPath.row == notesRow) {
        return notesRowHeight;
    }
    
    if (indexPath.row == 0)
        return firstCellHeight;
    
    if (indexPath.row == deleteRow) {
        return self.event ? deleteRowHeight : 0.0f;
    }
    
    
    return standardRowHeight;
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

    if (indexPath.row == deleteRow){
        [self.event.day removeEventsObject:self.event];
        [self.delegate updateTableView:-1];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"]) {
        self.startPickerIsShowing = YES;
    } else if([which isEqualToString:@"end"]){
        self.endPickerIsShowing = YES;
    }
    
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
    }
}

- (void)hideDatePickerCell:(NSString *)which {
    if ([which isEqualToString:@"start"])
        self.startPickerIsShowing = NO;
    else if ([which isEqualToString:@"end"])
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
    else if([which isEqualToString:@"end"])
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

#pragma mark - Table view delegate

- (IBAction)startDatePickerChanged:(UIDatePicker *)sender {
    self.startLabel.text = [self.dateTimeFormatter stringFromDate:sender.date];
    self.selectedStart = sender.date;
    if (self.selectedEnd < self.selectedStart) {
        self.endDatePicker.minimumDate = [NSDate dateWithTimeInterval:60 sinceDate:sender.date];
        self.endDatePicker.date = self.endDatePicker.minimumDate;
        self.endLabel.text = [self.dateTimeFormatter stringFromDate:self.endDatePicker.date];
        self.selectedEnd = self.endDatePicker.date;

    }
}

- (IBAction)endDatePickerChanged:(UIDatePicker *)sender {
    self.endLabel.text = [self.dateTimeFormatter stringFromDate:sender.date];
    self.selectedEnd = sender.date;
}
- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)createNewEvent
{
    NSMutableDictionary *eventDetails = [[NSMutableDictionary alloc] init];
    [eventDetails setObject:self.nameField.text forKey:E_NAME_KEY];
    
    [eventDetails setObject:self.selectedStart   forKey:E_START_KEY];
    [eventDetails setObject:self.selectedEnd forKey:E_END_KEY];
    [eventDetails setObject:self.NotesField.text forKey:E_NOTES_KEY];
    [eventDetails setObject:self.departureLocField.text forKey:E_ADDR_KEY];
    [eventDetails setObject:self.ArrivalLocField.text forKey:ET_ARRIVAL_KEY];
    [eventDetails setObject:self.phoneNumberField.text forKey:E_PHONE_KEY];
    [eventDetails setObject:self.confirmationNumberField.text forKey:ET_CONFIRMATION_KEY];
    [eventDetails setObject:self.routeNumberField.text forKey:ET_ROUTE_KEY];
    
    NSManagedObjectContext *context = [DataManager getManagedObjectContext];
    PITransportation *t = [PITransportation createTransportation:eventDetails inManagedObjectContext:context];
    [[self.trip getDayForDate:self.selectedStart] addEvent:t];


}

- (IBAction)saveClicked:(UIBarButtonItem *)sender {
    

    if (self.event) {
        [self.event.day removeEventsObject:self.event];
        self.event.name = self.nameField.text;
        self.event.addr = self.departureLocField.text;
        self.event.notes = self.NotesField.text;
        self.event.start = self.selectedStart;
        self.event.end = self.selectedEnd;
        self.event.phone = self.phoneNumberField.text;
        ((PITransportation *)self.event).arrivalLocation = self.ArrivalLocField.text;
        ((PITransportation *)self.event).confirmationNumber = self.confirmationNumberField.text;
        ((PITransportation *)self.event).routeNumber = self.routeNumberField.text;
        [[self.trip getDayForDate:self.event.start] addEvent:self.event];
    } else {
        [self createNewEvent];
    }
    
    NSInteger day = [DateCompare getDayFromArray:self.trip.getDaysArray date:self.selectedStart];
    [self.delegate updateTableView:day];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
