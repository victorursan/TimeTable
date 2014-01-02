//
//  SubjectStore.h
//  TimeTable
//
//  Created by Victor Ursan on 1/2/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectStore : NSObject

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchRequest *fetcher;

-(id) initWithContext:(NSManagedObjectContext *)managedObjectContext;
-(void) addSubjectWithName:(NSString *)name onDays:(NSSet *)days;

@end
