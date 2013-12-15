//
//  Subject.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *days;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
