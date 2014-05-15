//
//  ItineraryItemTableCell.h
//  planit
//
//  Created by Anh Truong on 5/11/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryItemTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *TypeImage;
@property (weak, nonatomic) IBOutlet UITextView *TimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *AddressLabel;

@end
