//
//  POIViewController.h
//  planit
//
//  Created by Anh Truong on 5/20/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEvent;

@interface POIViewController : UIViewController
@property (weak, nonatomic) PIEvent *event;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end
