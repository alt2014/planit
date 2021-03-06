//
//  ItineraryViewController.h
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PITrip;


@interface ItineraryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableIndexSet *expandedSections;
    __weak IBOutlet UIBarButtonItem *sidebarButton;
}

- (void)updateTableView:(NSInteger)lastAddDate;

- (IBAction)doneClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) PITrip *trip;
@property  (weak, nonatomic) ItineraryViewController* presentingController;

@end
