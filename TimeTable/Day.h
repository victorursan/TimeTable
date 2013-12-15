//
//  Day.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject, TimeInterval;

@interface Day : NSManagedObject

@property (nonatomic, retain) NSString * dayName;
@property (nonatomic, retain) Subject *subjects;
@property (nonatomic, retain) NSSet *timeInterval;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addTimeIntervalObject:(TimeInterval *)value;
- (void)removeTimeIntervalObject:(TimeInterval *)value;
- (void)addTimeInterval:(NSSet *)values;
- (void)removeTimeInterval:(NSSet *)values;

@end
