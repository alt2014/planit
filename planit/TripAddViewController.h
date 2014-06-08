//
//  TripAddViewController.h
//  planit
//
//  Created by Anh Truong on 5/29/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Trip;

@protocol AddTripDelegate <NSObject>

- (void)saveTripDetails:(Trip *)trip;

@end

@interface TripAddViewController : UITableViewController <UITextFieldDelegate>
@property  (weak, nonatomic) id<AddTripDelegate> delegate;
- (IBAction)startDateChanged:(UIDatePicker *)sender;
- (IBAction)cancelPressed:(UIBarButtonItem *)sender;
- (IBAction)endDateChanged:(UIDatePicker *)sender;
- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end