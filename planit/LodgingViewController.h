//
//  LodgingViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LodgingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UITextView *AddressField;
@property (weak, nonatomic) IBOutlet UILabel *CheckInLabel;
@property (weak, nonatomic) IBOutlet UILabel *CheckOutLabel;
@property (weak, nonatomic) IBOutlet UITextView *PhoneField;
@property (weak, nonatomic) IBOutlet UILabel *ConfirmationLabel;
@property (weak, nonatomic) IBOutlet UITextView *NotesField;

@end
