//
//  SubjectStore.m
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "SubjectStore.h"
#import "DayStore.h"
#import "Subject.h"
#import "Day.h"
#import "config.h"

@implementation SubjectStore

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext {
  self = [super init];
  if (self) {
    self.context = managedObjectContext;
    self.fetcher = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.context];
    [self.fetcher setEntity:entity];
  }
  return self;
}

- (void)addSubjectWithName:(NSString *)name onDays:(NSSet *)days {
  NSError *error;
  Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.context];
  newSubject.name = name;
  [newSubject addDays: days];
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
}

- (void)addTimeInterval:(NSDate *)date forSubject:(Subject *)subject andDayName:(NSString *)day {
  NSError *error;
  Day *newDay;
  TimeInterval *timeInterval = [NSEntityDescription insertNewObjectForEntityForName:@"TimeInterval" inManagedObjectContext:self.context];
  timeInterval.from = date;
  timeInterval.to = [date dateByAddingTimeInterval:60*60];
  for (Day *search in subject.days) {
    if ([search.dayName isEqualToString:day]) {
      newDay = search;
    }
  }
  if (!newDay) {
    newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.context];
    newDay.dayName=day;
    [subject addDaysObject:newDay];
  }
  [newDay addTimeIntervalObject:timeInterval];
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  
}

- (NSArray *)subjects {
  NSError *error;
  return [self.context executeFetchRequest:self.fetcher error:&error];
}

- (NSArray *)subjectsTitles {
  NSArray *subjects = [self subjects];
  NSMutableArray *subjectsTitle = [@[] mutableCopy];
  for (Subject *subject in subjects)
    [subjectsTitle addObject:subject.name];
  NSArray *sortedArray = [subjectsTitle sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  return sortedArray;
}

- (Subject *)subjectForTitle:(NSString *)title {
  NSArray *subjects = [self subjects];
  for (Subject *subject in subjects) {
    if ([subject.name isEqualToString:title]) {
      return subject;
    }
  }
  return 0;
}

- (NSDictionary *)dictionaryforSubject:(Subject *)subject {
  DayStore *dayStore = [[DayStore alloc] initWithContext:self.context];
  NSMutableDictionary *mutableDictionary = [@{} mutableCopy];
  for (Day *day in subject.days ) {
    [mutableDictionary addEntriesFromDictionary:[dayStore timeIntervalsForDay:day]];
  }
  return mutableDictionary;
}

- (NSArray *)subjectsForDay:(NSString *)day {
  NSArray *subjects = [self subjects];
  NSMutableArray *toSort = [@[] mutableCopy];
  for (Subject *subject in subjects){
    for (Day *currentDay in subject.days){
      if ([currentDay.dayName isEqualToString:day]) {
        for (TimeInterval *timeInterval in currentDay.timeInterval){
          [toSort addObject:timeInterval];
        }
      }
    }
  }
  if (toSort.count != 0) {
    return [self sortSubjects:toSort];
  } else {
    return @[];
  }
}

- (NSArray *)sortSubjects:(NSMutableArray *)toSort {
  NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
  [timeFormat setDateFormat:@"HH:00"];
  for (int i=0; i<toSort.count-1; i++) {
    for (int j=i+1; j<toSort.count; j++) {
      NSString *from1 = [timeFormat stringFromDate:[toSort[i] from]];
      NSString *from2 = [timeFormat stringFromDate:[toSort[j] from]];
      if (from1.intValue>from2.intValue) {
        id aux = toSort[i];
        toSort[i] = toSort[j];
        toSort[j] = aux;
      }
    }
  }
  NSArray *sorted = [[NSArray alloc] initWithArray:toSort];
  return sorted;
}

- (void)deleteSubjectWithName:(NSString *)name {
  Subject *subjectToDelete;
  NSError *error;
  NSArray *subjects = [self subjects];
  for (Subject *subject in subjects) {
    if ([subject.name isEqualToString:name]) {
      subjectToDelete = subject;
      break;
    }
  }
  for (Day *day in subjectToDelete.days) {
    for (TimeInterval *timeInt in day.timeInterval){
      [day.managedObjectContext deleteObject:timeInt];
    }
    [subjectToDelete.managedObjectContext deleteObject:day];
  }
  [self.context deleteObject:subjectToDelete];
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
}

- (void)deleteTimeInterval:(TimeInterval *)timeInterval {
  NSError *error;
  Day *day = timeInterval.day;
  Subject *subject = day.subjects;
  [day.managedObjectContext deleteObject:timeInterval];
  
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  
  if (day.timeInterval.count==0)
    [subject.managedObjectContext deleteObject:day];
  
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  
  if (subject.days.count==0)
    [self.context deleteObject:subject];
  
  if (![self.context save:&error])
    NSLog(@"Problem saving: %@", [error localizedDescription]);
}

- (void)changeSubject:(Subject *)subjectToChange inName:(NSString *)subjectName {
  NSSet *daysToMove = subjectToChange.days;
  [self addSubjectWithName:subjectName onDays:daysToMove];
  [self deleteSubjectWithName:subjectToChange.name];
}

@end
