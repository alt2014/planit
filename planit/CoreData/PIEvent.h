//
//  PIEvent.h
//  planit
//
//  Created by Anh Truong on 6/8/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIDay;

@interface PIEvent : NSManagedObject

@property (nonatomic, retain) NSString *addr;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) PIDay *day;

@end
