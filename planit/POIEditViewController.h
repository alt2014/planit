//
//  POIEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface POIEditViewController : UITableViewController
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
- (IBAction)saveClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) Event *POIEvent;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
- (IBAction)whenDatePickerChanged:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *whenDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *whenDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *secStreetField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
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
