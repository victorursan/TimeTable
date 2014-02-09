//
//  DayStore.h
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"

@interface DayStore : NSObject

@property (nonatomic, retain) NSManagedObjectContext *context;

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext;
- (NSSet *)daysWithTimeIntervalsFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)timeIntervalsForDay:(Day *)day;
- (NSArray *)hoursInDay:(NSString *)day;

@end
