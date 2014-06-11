//
//  LodgingEditViewController.h
//  planit
//
//  Created by Anh Truong on 6/9/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "POIEditViewController.h"

@interface LodgingEditViewController : POIEditViewController<UITextFieldDelegate>
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) PITrip *trip;
- (IBAction)saveClicked:(UIBarButtonItem *)sender;
@property (strong, nonatomic) PIEvent *event;
@property (weak, nonatomic) id<AddEventDelegate> delegate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@end
