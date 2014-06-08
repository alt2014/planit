//
//  ItineraryEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PITrip;
@protocol updateTableDelegate <NSObject>
- (void)updateTableView;

//- (void)saveEventDetails:(Event *)eventn isNewEvent:(BOOL)isNewEvent;
@end

@interface ItineraryEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)doneClicked:(UIBarButtonItem *)sender;


@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property  (weak, nonatomic) id<updateTableDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddTransport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddLodging;
@property (strong, nonatomic) PITrip *trip;


@end
