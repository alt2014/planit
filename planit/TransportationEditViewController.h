//
//  TransportationEditViewController.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIEditViewController.h"

@class PIEvent;
@class PITrip;
@class PITransportation;


@interface TransportationEditViewController : POIEditViewController<UITextFieldDelegate>
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) PITrip *trip;
- (IBAction)saveClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) PIEvent *event;
@property (weak, nonatomic) id<AddEventDelegate> delegate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@end
