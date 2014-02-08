//
//  CustomTimePicker.h
//  TimeTable
//
//  Created by Victor Ursan on 2/8/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTimePickerDelegate.h"

@interface CustomTimePicker : UIView  <UIPickerViewDataSource, UIPickerViewDelegate>

@property(strong, nonatomic) id<CustomTimePickerDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;
- (void)pickerWithoutHours:(NSArray *)hours;

@end
