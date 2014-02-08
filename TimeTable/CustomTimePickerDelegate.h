//
//  CustomTimePickerDelegate.h
//  TimeTable
//
//  Created by Victor Ursan on 2/8/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomTimePickerDelegate <NSObject>

- (void)addTime:(NSDate *)time;

@end
