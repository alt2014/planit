//
//  TransportationViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RouteNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *ConfirmationLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UITextView *DepartAddrField;
@property (weak, nonatomic) IBOutlet UITextView *ArriveAddrField;
@property (weak, nonatomic) IBOutlet UILabel *DepartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ArriveTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *NotesField;

@end
