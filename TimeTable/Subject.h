//
//  Subject.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *days;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inDaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDaysAtIndex:(NSUInteger)idx;
- (void)insertDays:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDaysAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceDaysAtIndexes:(NSIndexSet *)indexes withDays:(NSArray *)values;
- (void)addDaysObject:(NSManagedObject *)value;
- (void)removeDaysObject:(NSManagedObject *)value;
- (void)addDays:(NSOrderedSet *)values;
- (void)removeDays:(NSOrderedSet *)values;
@end
