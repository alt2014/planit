//
//  POIEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEvent;
@class PITrip;

@protocol AddEventDelegate <NSObject>
- (void)updateTableView;

//- (void)saveEventDetails:(Event *)eventn isNewEvent:(BOOL)isNewEvent;

@end

@interface POIEditViewController : UITableViewController
@property (strong, nonatomic) PIEvent *event;
@property (strong, nonatomic) PITrip *trip;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property  (weak, nonatomic) id<AddEventDelegate> delegate;
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
- (IBAction)saveClicked:(UIBarButtonItem *)sender;
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
