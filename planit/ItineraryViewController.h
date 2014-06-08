//
//  ItineraryViewController.h
//  planit
//
//  Created by Anh Truong on 5/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PITrip;



@interface ItineraryViewController : UIViewController{
    NSMutableIndexSet *expandedSections;
    __weak IBOutlet UIBarButtonItem *sidebarButton;
}

@property (strong, nonatomic) PITrip *trip;

@end
