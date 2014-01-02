//
//  SubjectStore.m
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "SubjectStore.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"

@implementation SubjectStore

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext {
  self = [super init];
  if (self) {
    self.context = managedObjectContext;
    self.fetcher = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext: self.context];
    [self.fetcher setEntity:entity];
  }
  return self;
}

- (void)addSubjectWithName:(NSString *)name onDays:(NSSet *)days {
  NSError *error;
  Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext: self.context];
  newSubject.name = name;
  [newSubject addDays: days];
  
  if (![self.context save:&error]) {
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  }
}

- (NSArray *)subjects {
  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.context];
  [fetchRequest setEntity:entity];
  return [self.context executeFetchRequest:fetchRequest error:&error];
}

- (NSArray *)subjectsTitles {
  NSArray *subjects = [self subjects];
  NSMutableArray *subjectsTitle = [@[] mutableCopy];
  for (Subject *subject in subjects) {
    [subjectsTitle addObject:subject.name];
  }
  NSArray *sortedArray = [subjectsTitle sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  return sortedArray;
}

- (void)deleteSubjectWithName:(NSString *)name {
  Subject *subjectToDelete;
  NSError *error;
  NSArray *subjects = [self subjects];
  for (Subject *subject in subjects) {
    if ([subject.name isEqualToString:name]) {
      subjectToDelete = subject;
    }
  }
  for (Day *day in subjectToDelete.days) {
    for (TimeInterval *timeInt in day.timeInterval){
      [day.managedObjectContext deleteObject:timeInt];
    }
    [subjectToDelete.managedObjectContext deleteObject:day];
  }
  [self.context deleteObject:subjectToDelete];
  if (![self.context save:&error]) {
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  }

}

@end
