//
//  CustomNavigationController.h
//  TimeTable
//
//  Created by Victor Ursan on 11/10/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentDayTableDelegate.h"

@interface CustomNavigationController : UINavigationController <PresentDayTableDelegate>

@property(strong, nonatomic) UIButton *middleButton;

@end
