//
//  TimeInterval.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day;

@interface TimeInterval : NSManagedObject

@property (nonatomic, retain) NSDate * from;
@property (nonatomic, retain) NSDate * to;
@property (nonatomic, retain) Day *day;

@end
