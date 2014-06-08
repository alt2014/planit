//
//  ItineraryEditViewController.h
//  planit
//
//  Created by Anh Truong on 5/19/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@protocol EditEventsDelegate <NSObject>

- (void)changeItineraryEvent:(NSMutableArray *)event;
- (void)addItineraryEvent:(Event*)event;

@end

@interface ItineraryEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)doneClicked:(UIBarButtonItem *)sender;

@property  (weak, nonatomic) id<EditEventsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddTransport;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddLodging;
@property (strong, nonatomic) NSMutableArray *itineraryEvents;


@end
