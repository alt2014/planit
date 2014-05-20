//
//  POIViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POIViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UITextView *AddressField;
@property (weak, nonatomic) IBOutlet UILabel *HoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UITextView *NotesField;

@end
