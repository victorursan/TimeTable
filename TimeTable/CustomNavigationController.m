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

  self.middleButton = [[UIButton alloc] init];
  [self.middleButton addTarget:self action:@selector(middleButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.middleButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
  [self.view addSubview: self.middleButton];
  
  self.presentDayTable = [[PresentDayTable alloc] initWithFrame:CGRectMake(self.navigationBar.frame.size.width/2-100, 64, 200, 220) andDelegate:self];
}


- (void)setTitle:(NSString *)title {
  NSString *newTitle;
  if (self.middleButton.enabled) {
    newTitle = [NSString stringWithFormat:@"%@  V",title];
  } else {
    newTitle = title;
  }
  [self.middleButton setTitle:newTitle forState:UIControlStateNormal];
  [self.middleButton sizeToFit];
  self.middleButton.frame = CGRectMake (self.navigationBar.frame.size.width/2-self.middleButton.frame.size.width/2,
                                        self.navigationBar.frame.size.height/2-self.middleButton.frame.size.height/2+20,
                                        self.middleButton.frame.size.width,
                                        self.middleButton.frame.size.height);
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"elements"]) {
    self.presentDayTable.tableViewElements = value;
  }
  if ([key isEqualToString:@"buttonStatus"]){
    if ([value isEqualToString:@"ON"]) {
      self.middleButton.enabled = YES;
    } else {
      self.middleButton.enabled = NO;
      [self.presentDayTable removeFromSuperview];
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

@end
