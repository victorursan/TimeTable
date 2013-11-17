//
//  MainViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 11/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "MainViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Monday";
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subjects" style:UIBarButtonItemStylePlain target:self action:@selector(subjectsButtonPressed)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
  self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
  
  [self addTableView];
}

- (void)subjectsButtonPressed {
  NSLog(@"Subjects");
  self.mm_drawerController.rightDrawerViewController = [[UIViewController alloc] init];
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)setTitle:(NSString *)title {
  self.navigationController.title = title;
}

#pragma mark - Table view
- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = NO;
  [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 100;
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
