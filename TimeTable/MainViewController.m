//
//  MainViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 11/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "MainViewController.h"
#import "CustomNavigationController.h"
#import "PresentSubjectViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AddSubjectViewController.h"


@interface MainViewController ()

@property(strong, nonatomic) NSString *currentTitle;
@property(strong, nonatomic) NSArray *subjectsForCurrentView;

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
  self.title = [self currentWeekDay];
  NSArray *days = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subjects" style:UIBarButtonItemStylePlain target:self action:@selector(subjectsButtonPressed)];
  [self.navigationController setValue:days forKey:@"elements"];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setValue:@"ON" forKey:@"buttonStatus"];
  self.title = self.currentTitle;
  [self.tableView reloadData];
}

- (NSArray *)arrayForTitle{
  NSString *test = [NSString stringWithFormat:@"%@ Subject",self.currentTitle];
  return @[test,test,test,test,test,test];
}

- (NSString *)currentWeekDay {
  NSDate *today = [NSDate date];
  NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
  [weekdayFormatter setDateFormat: @"EEEE"];
  NSString *weekday = [weekdayFormatter stringFromDate: today];
  return weekday;
}

- (void)subjectsButtonPressed {
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"resetTableView"]) {
    self.title = value;
    [self.tableView reloadData];
  }
}

- (void)setTitle:(NSString *)title {
  self.currentTitle = title;
  self.subjectsForCurrentView = [self arrayForTitle];
  self.navigationController.title = title;
}

#pragma mark - Table view
- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = YES;
  [self.view addSubview:self.tableView];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.subjectsForCurrentView.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  cell.textLabel.text= self.subjectsForCurrentView[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PresentSubjectViewController *subjectView = [[PresentSubjectViewController alloc] init];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self.navigationController pushViewController:subjectView animated:YES];
  [subjectView setTitle:cell.textLabel.text];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
