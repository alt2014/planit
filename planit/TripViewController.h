//
//  TripViewController.h
//  planit
//
//  Created by Anh Truong on 5/11/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTripDelegate <NSObject>

- (void)updateTableDataSource;

@end

@interface TripViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
- (IBAction)doneClicked:(UIBarButtonItem *)sender;
@property TripViewController<AddTripDelegate>* delegate;
@end
