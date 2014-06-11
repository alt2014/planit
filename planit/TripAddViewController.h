//
//  TripAddViewController.h
//  planit
//
//  Created by Anh Truong on 5/29/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PITrip;

@protocol ChangeTrip <NSObject>

- (void)updateTableDataSource;

@end

@interface TripAddViewController : UITableViewController <UITextFieldDelegate>
@property  (weak, nonatomic) id<ChangeTrip> delegate;
- (IBAction)startDateChanged:(UIDatePicker *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;
- (IBAction)endDateChanged:(UIDatePicker *)sender;
- (IBAction)savePressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) PITrip *trip;
@end