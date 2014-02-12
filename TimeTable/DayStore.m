//
//  DayStore.m
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "DayStore.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"
#import "config.h"

@implementation DayStore

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext {
  self = [super init];
  if (self) {
    self.context = managedObjectContext;
  }
  return self;
}

- (NSSet *)daysWithTimeIntervalsFromDictionary:(NSDictionary *)dictionary {
  NSError *error;
  NSMutableArray *days = [@[] mutableCopy];
  NSArray *daysArray = WEEKDAYS;
  for (NSString *currentDay in daysArray ) {
    if ([dictionary[currentDay] count]!=0) {
      Day *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.context];
      newDay.dayName = currentDay;
      
      for (NSDate *date in dictionary[currentDay]) {
        NSDate *from = date;
        NSDate *to = [from dateByAddingTimeInterval:60*60];
        TimeInterval *newTimeInterval = [NSEntityDescription insertNewObjectForEntityForName:@"TimeInterval"
                                                                      inManagedObjectContext:self.context];
        newTimeInterval.from =from;
        newTimeInterval.to = to;
        [newDay addTimeIntervalObject:newTimeInterval];
        if (![newDay.managedObjectContext save:&error])
          NSLog(@"Problem saving: %@", [error localizedDescription]);
      }
      [days addObject:newDay];
    }
  }
  return [[NSSet alloc] initWithArray:days];
}

- (NSDictionary *)timeIntervalsForDay:(Day *)day {
  NSMutableArray *timeIntervals = [@[] mutableCopy];
  for (TimeInterval *time in day.timeInterval) {
    [timeIntervals addObject:time];
  }
  NSDictionary *dayDictionary = @{day.dayName: [self sortTimeIntervalArray:timeIntervals]};
  return dayDictionary;
}

- (NSArray *)sortTimeIntervalArray:(NSMutableArray *)toSort {
  TimeInterval *aux;
  int n = [toSort count];
  for (int i=0; i<n-1; i++) {
    for (int j = i+1; j<n; j++) {
      TimeInterval *first = toSort[i];
      TimeInterval *second = toSort[j];
      if ([[self numberFromDate:first.from] integerValue]>[[self numberFromDate:second.from] integerValue]) {
        aux = toSort[i];
        toSort[i] = toSort[j];
        toSort[j] = aux;
      }
    }
  }
//  NSLog(@"%@",toSort);
  return toSort;
}

- (NSArray *)hoursInDay:(NSString *)day {
  NSMutableArray *hours = [@[] mutableCopy];
  NSError *error;
  NSFetchRequest *fetcher = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.context];
  [fetcher setEntity:entity];
  NSArray *search = [self.context executeFetchRequest:fetcher error:&error];
  for (Subject *subj in search) {
    for (Day *testDay in subj.days) {
      if ([testDay.dayName isEqualToString:day]) {
        [hours addObjectsFromArray:[self timesFromDay:testDay]];
      }
    }
    
  }
  return hours;
}

- (NSArray *)timesFromDay:(Day *)day {
  NSMutableArray *times = [@[] mutableCopy];
  for (TimeInterval *time in day.timeInterval) {
    [times addObject:[self numberFromDate:time.from]];
  }
  return times;
}


- (NSNumber *)numberFromDate:(NSDate *)date {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *hour = [cal components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
  return [NSNumber numberWithInteger:hour.hour];
}


@end
