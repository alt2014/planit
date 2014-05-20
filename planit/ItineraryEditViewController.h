//
//  ItineraryEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SaveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddTransport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddLodging;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddPOI;

@end
