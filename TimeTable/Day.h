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
@property (nonatomic, retain) NSOrderedSet *timeInterval;
@end

@interface Day (CoreDataGeneratedAccessors)

- (void)insertObject:(TimeInterval *)value inTimeIntervalAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTimeIntervalAtIndex:(NSUInteger)idx;
- (void)insertTimeInterval:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTimeIntervalAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTimeIntervalAtIndex:(NSUInteger)idx withObject:(TimeInterval *)value;
- (void)replaceTimeIntervalAtIndexes:(NSIndexSet *)indexes withTimeInterval:(NSArray *)values;
- (void)addTimeIntervalObject:(TimeInterval *)value;
- (void)removeTimeIntervalObject:(TimeInterval *)value;
- (void)addTimeInterval:(NSOrderedSet *)values;
- (void)removeTimeInterval:(NSOrderedSet *)values;
@end
