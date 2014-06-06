//
//  PIDay.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIEvent, PITrip;

@interface PIDay : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) PITrip *trip;
@property (nonatomic, retain) NSSet *events;
@end

@interface PIDay (CoreDataGeneratedAccessors)

- (void)addEventsObject:(PIEvent *)value;
- (void)removeEventsObject:(PIEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
