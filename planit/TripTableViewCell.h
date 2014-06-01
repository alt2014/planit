//
//  TripTableViewCell.h
//  planit
//
//  Created by Anh Truong on 5/29/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripEndLabel;

@end
