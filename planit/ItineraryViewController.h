//
//  ItineraryViewController.h
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;



@interface ItineraryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableIndexSet *expandedSections;
    __weak IBOutlet UIBarButtonItem *sidebarButton;
}

@property  (strong, nonatomic) NSArray *daysInTrip;


@end
