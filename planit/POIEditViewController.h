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
@end

@interface POIEditViewController : UITableViewController<UITextFieldDelegate>
@property (strong, nonatomic) PIEvent *event;
@property (strong, nonatomic) PITrip *trip;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property  (weak, nonatomic) id<AddEventDelegate> delegate;
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
- (IBAction)saveClicked:(UIBarButtonItem *)sender;



@end
