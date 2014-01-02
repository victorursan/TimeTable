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

@implementation SubjectStore

-(id) initWithContext:(NSManagedObjectContext *)managedObjectContext {
  self = [super init];
  
  if (self) {
    self.context = managedObjectContext;
    self.fetcher = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext: self.context];
    [self.fetcher setEntity:entity];
  }
  
  return self;
}

-(void) addSubjectWithName:(NSString *)name onDays:(NSSet *)days {
  
  NSError *error;
  
  Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext: self.context];
  newSubject.name = name;
  [newSubject addDays: days];
  
  if (![self.context save:&error]) {
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  }
}

@end
