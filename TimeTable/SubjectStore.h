//
//  SubjectStore.h
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeInterval.h"
#import "Subject.h"

@interface SubjectStore : NSObject

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchRequest *fetcher;

- (id)initWithContext:(NSManagedObjectContext *)managedObjectContext;
- (void)addSubjectWithName:(NSString *)name onDays:(NSSet *)days;
- (void)addTimeInterval:(NSDate *)date forSubject:(Subject *)subject andDayName:(NSString *)day;
- (NSArray *)subjectsTitles;
- (void)deleteSubjectWithName:(NSString *)name;
- (NSArray *)subjectsForDay:(NSString *)day;
- (NSDictionary *)dictionaryforSubject:(Subject *)subject;
- (void)deleteTimeInterval:(TimeInterval *)timeInterval;
- (Subject *)subjectForTitle:(NSString *)title;
- (void)changeSubject:(Subject *)subjectToChange inName:(NSString *)subjectName;

@end
