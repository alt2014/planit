//
//  ItineraryEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface ItineraryEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)doneClicked:(UIBarButtonItem *)sender;


@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddTransport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddLodging;
@property (strong, nonatomic) NSMutableArray *itineraryEvents;
@property (strong, nonatomic) NSArray *listOfDays;


@end
