//
//  PITrip.h
//  planit
//
//  Created by Peter Phan on 6/6/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIDay;

@interface PITrip : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSSet *days;
@end

@interface PITrip (CoreDataGeneratedAccessors)

- (void)addDaysObject:(PIDay *)value;
- (void)removeDaysObject:(PIDay *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
