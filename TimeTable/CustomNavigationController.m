//
//  CustomNavigationController.m
//  TimeTable
//
//  Created by Victor Ursan on 11/10/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "CustomNavigationController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "PresentDayTable.h"

@interface CustomNavigationController ()

@property(strong, nonatomic) PresentDayTable *presentDayTable;
@property(strong, nonatomic) UIView *arrowView;

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.barTintColor = [UIColor orangeColor];
  self.navigationBar.barStyle = UIBarStyleBlackOpaque;
  self.navigationBar.tintColor =[UIColor whiteColor];
  
  self.arrowView = [[UIView alloc] initWithFrame:CGRectMake(self.navigationBar.frame.size.width/2+45,self.navigationBar.frame.size.height/2+8,22,21)];
  UIImageView *arrow = [[UIImageView alloc] initWithImage:[self imageForSelector:@selector(drawRectActive)]];
  [self.arrowView addSubview:arrow];
  [self.view addSubview:self.arrowView];
  
  self.middleButton = [[UIButton alloc] init];
  [self.middleButton addTarget:self action:@selector(middleButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.middleButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
  self.middleButton.frame = CGRectMake(self.navigationBar.frame.size.width/2-70, self.navigationBar.frame.size.height/2, 140, 40);
  self.middleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview: self.middleButton];
  
  self.presentDayTable = [[PresentDayTable alloc] initWithFrame:CGRectMake(self.navigationBar.frame.size.width/2-105, 45, 210, 240) andDelegate:self];
}


- (void)setTitle:(NSString *)title {
  NSString *newTitle;
  if (self.middleButton.enabled) {
    newTitle = [NSString stringWithFormat:@"%@    ",title];
  } else {
    newTitle = title;
  }
  [self.middleButton setTitle:newTitle forState:UIControlStateNormal];
  self.middleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"elements"]) {
    self.presentDayTable.tableViewElements = value;
  }
  if ([key isEqualToString:@"buttonStatus"]){
    if ([value isEqualToString:@"ON"]) {
      self.middleButton.enabled = YES;
      self.arrowView.hidden = NO;
    } else {
      self.middleButton.enabled = NO;
      [self.presentDayTable removeFromSuperview];
      self.arrowView.hidden = YES;
    }
  }
  [self.presentDayTable.tableView reloadData];
}

- (void)middleButtonWasPressed {
  if (!self.presentDayTable.superview) {
    [self.presentDayTable.tableView reloadData];
    [self.view addSubview:self.presentDayTable];
  } else {
    [self.presentDayTable removeFromSuperview];
  }
}

- (void)presentViewControllerForDay:(NSString *)day {
  [self.presentDayTable removeFromSuperview];
  [self.childViewControllers[0] setValue:day forKey:@"resetTableView"];
}

- (UIImage *)imageForSelector:(SEL)selector {
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 21), NO, 0.0f);
	
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [self performSelector: selector];
#pragma clang diagnostic pop
	
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return result;
}

- (void)drawRectActive {
  //// Color Declarations
  UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
  
  //// Frames
  CGRect frame2 = CGRectMake(0, 0, 22, 21);
  
  //// Group 2
  {
  //// Polygon 2 Drawing
  UIBezierPath* polygon2Path = [UIBezierPath bezierPath];
  [polygon2Path moveToPoint: CGPointMake(CGRectGetMinX(frame2) + 11, CGRectGetMinY(frame2) + 20)];
  [polygon2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 18, CGRectGetMinY(frame2) + 6)];
  [polygon2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 11, CGRectGetMinY(frame2) + 13)];
  [polygon2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 4, CGRectGetMinY(frame2) + 6)];
  [polygon2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 11, CGRectGetMinY(frame2) + 20)];
  [polygon2Path closePath];
  [color2 setFill];
  [polygon2Path fill];
  }
  
}



@end
