//
//  ItineraryHeaderTableCell.m
//  planit
//
//  Created by Anh Truong on 5/15/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "ItineraryHeaderTableCell.h"

@implementation ItineraryHeaderTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
