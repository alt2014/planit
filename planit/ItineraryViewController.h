//
//  ItineraryViewController.h
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableIndexSet *expandedSections;
    NSArray *dummyData;
    __weak IBOutlet UIBarButtonItem *sidebarButton;
}

@end
