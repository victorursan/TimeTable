//
//  DayStore.m
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "DayStore.h"
#import "Day.h"
#import "TimeInterval.h"
#import "config.h"

@implementation DayStore

-(id) initWithContext:(NSManagedObjectContext *)managedObjectContext {
  self = [super init];
  
  if (self) {
    self.context = managedObjectContext;
  }
  
  return self;
}

-(NSSet *) daysWithTimeIntervalsFromDictionary:(NSDictionary *)dictionary {
  NSError *error;
  NSMutableArray *days = [@[] mutableCopy];
  NSArray *daysArray = WEEKDAYS;
  for (NSString *currentDay in daysArray ) {
//  for (int i=0 ; i<WEEKDAYSNUM; i++) {
    if ([dictionary[currentDay] count]!=0) {
      Day *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.context];
      newDay.dayName = currentDay;
      
      if (![self.context save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
      }
      
      for (int j=0; j<[dictionary[currentDay] count]; j++) {
        NSDate *from = [dictionary valueForKey:currentDay][j];
        NSDate *to = [from dateByAddingTimeInterval:60*60];
        TimeInterval *newTimeInterval = [NSEntityDescription insertNewObjectForEntityForName:@"TimeInterval"
                                                                      inManagedObjectContext:self.context];
        newTimeInterval.from =from;
        newTimeInterval.to = to;
        if (![self.context save:&error]) {
          NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
        [newDay addTimeIntervalObject:newTimeInterval];
        if (![newDay.managedObjectContext save:&error]) {
          NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
      }
      [days addObject:newDay];
    }
  }
  return [[NSSet alloc] initWithArray:days];
}


@end
