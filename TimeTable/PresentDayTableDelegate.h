//
//  PresentDayTableDelegate.h
//  TimeTable
//
//  Created by Victor Ursan on 1/30/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PresentDayTableDelegate <NSObject>

- (void)presentViewControllerForDay:(NSString *)day;

@end
