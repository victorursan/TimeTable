//
//  CustomTimePicker.m
//  TimeTable
//
//  Created by Victor Ursan on 2/8/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "CustomTimePicker.h"

@interface CustomTimePicker ()

@property(strong, nonatomic) UIPickerView *timePicker;
@property(strong, nonatomic) UIButton *done;
@property(strong, nonatomic) UIButton *cancel;
@property(strong, nonatomic) NSMutableArray *hours;
@property(strong, nonatomic) NSDateFormatter *timeFormat;
@property(strong, nonatomic) NSMutableArray *dates;
@property NSInteger selected;

@end

@implementation CustomTimePicker

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.timeFormat = [[NSDateFormatter alloc] init];
    [self.timeFormat setDateFormat:@"HH:00"];
    
    self.delegate = delegate;
    
    self.hours = [@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24] mutableCopy];
    self.selected = 0;
    [self createDates];
    
    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-180, self.frame.size.width, 180)];
    self.timePicker.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    
    self.done = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height-180, 50, 30)];
    [self.done setTitle:@"Done" forState:UIControlStateNormal];
    [self.done setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.done sizeToFit];
    [self.done addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-180, 50, 30)];
    [self.cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.cancel sizeToFit];
    [self.cancel addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self addSubview:self.timePicker];
    [self addSubview:self.cancel];
    [self addSubview:self.done];
  }
  return self;
}

- (void)doneButtonPressed {
  [self.timePicker reloadAllComponents];
  [self.delegate addTime:self.dates[self.selected]];
  [self removeFromSuperview];
}

- (void)cancelButtonPressed {
  [self.timePicker reloadAllComponents];
  [self removeFromSuperview];
}

- (NSDate *)timeFromNumber:(NSNumber *)number {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *hour = [cal components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
  [hour setHour:number.integerValue];
  [hour setMinute:0];
  return [cal dateFromComponents:hour];
}

- (void)pickerWithoutHours:(NSArray *)hours {
  self.hours = [@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24] mutableCopy];
  for (NSNumber *toDelete in hours) {
    [self.hours removeObject:toDelete];
  }
  [self createDates];
  [self.timePicker reloadAllComponents];
}

- (void)createDates {
  self.dates = [@[] mutableCopy];
  for (NSNumber *current in self.hours) {
    [self.dates addObject:[self timeFromNumber:current]];
  }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.hours count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [self.timeFormat stringFromDate:self.dates[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  self.selected = row;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
