//
//  CustomNavigationController.m
//  TimeTable
//
//  Created by Victor Ursan on 11/10/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@property(strong, nonatomic) UIButton *middleButton;
@property(strong, nonatomic) UIView *presentTableView;

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
  self.middleButton = [[UIButton alloc] init];
  [self.middleButton addTarget:self action:@selector(middleButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview: self.middleButton];
  [self addTableView];
}

- (void)addTableView {
  self.presentTableView = [[UIView alloc] initWithFrame:CGRectMake(self.navigationBar.frame.size.width/2-100, 64, 200, 200)];
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.presentTableView.frame.size.width, self.presentTableView.frame.size.height)];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.presentTableView.layer.masksToBounds = NO;
  self.presentTableView.layer.cornerRadius = 8; // if you like rounded corners
  self.presentTableView.layer.shadowOffset = CGSizeMake(0, 5);
  self.presentTableView.layer.shadowRadius = 5;
  self.presentTableView.layer.shadowOpacity = 0.2;
  [self.presentTableView addSubview:self.tableView];

}

- (void)setTitle:(NSString *)title {
  [self.middleButton setTitle:title forState:UIControlStateNormal];
  [self.middleButton sizeToFit];
  self.middleButton.frame = CGRectMake (self.navigationBar.frame.size.width/2-self.middleButton.frame.size.width/2,
                                        self.navigationBar.frame.size.height/2-self.middleButton.frame.size.height/2+20,
                                        self.middleButton.frame.size.width,
                                        self.middleButton.frame.size.height);
}

- (void)middleButtonWasPressed {
  if (!self.presentTableView.superview) {
    [self.view addSubview:self.presentTableView];
  } else {
    [self.presentTableView removeFromSuperview];
  }
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  cell.textLabel.text= @"hello";
  return cell;
}


@end
