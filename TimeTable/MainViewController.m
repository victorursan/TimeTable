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
#import "CustomCell.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

#import "Day.h"
#import "TimeInterval.h"
#import "config.h"
#import "SubjectStore.h"


@interface MainViewController ()

@property(strong, nonatomic) NSString *currentDay;
@property(strong, nonatomic) NSArray *subjectsForCurrentDay;
@property(strong, nonatomic) NSDateFormatter *timeFormat;
@property(strong, nonatomic) SubjectStore *subjectsStore;

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
  self.subjectsStore = [[SubjectStore alloc] initWithContext:self.managedObjectContext];
  self.title = [self currentWeekDay];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subjects"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(subjectsButtonPressed)];
  [self.navigationController setValue:WEEKDAYS forKey:@"elements"];
  self.subjectsForCurrentDay = [[NSArray alloc] init];
  self.timeFormat = [[NSDateFormatter alloc] init];
  [self.timeFormat setDateFormat:@"HH:00"];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setValue:@"ON" forKey:@"buttonStatus"];
  self.title = self.currentDay;
  [self.tableView reloadData];
}

- (NSArray *)arrayForTitle {
  return [self.subjectsStore subjectsForDay:self.currentDay];
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
    [UIView transitionWithView:self.view // or self.navigationController.view
                      duration:0.7f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:nil
                    completion:nil];
  } else if ([key isEqualToString:@"reloadData"]) {
    self.title = self.currentDay;
    [self.tableView reloadData];
  }
  
}

- (void)setTitle:(NSString *)title {
  self.currentDay = title;
  self.subjectsForCurrentDay = [self arrayForTitle];
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
  return self.subjectsForCurrentDay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  
  CustomCell __weak *weakCell = cell;
  
  [cell setAppearanceWithBlock:^{
    weakCell.rightUtilityButtons = [self rightButtons];
    weakCell.delegate = self;
    weakCell.containingTableView = tableView;
  } force:NO];
  
  [cell setCellHeight:44];
  
  TimeInterval *timeInterval = self.subjectsForCurrentDay[indexPath.row];
  cell.title.text= [timeInterval.day.subjects name];
  cell.position.text = [NSString stringWithFormat:@" #%d",(int)indexPath.row+1];
  [cell.position sizeToFit];
  cell.positionDescription.text = [NSString stringWithFormat:@"%@-%@",
                                   [self.timeFormat stringFromDate:timeInterval.from],
                                   [self.timeFormat stringFromDate:timeInterval.to]];
  return cell;
}

- (NSArray *)rightButtons {
  NSMutableArray *rightUtilityButtons = [NSMutableArray new];
  [rightUtilityButtons sw_addUtilityButtonWithColor:
   [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                              title:@"Delete"];
  
  return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  switch (index) {
    case 0:
    {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    [self.tableView beginUpdates];
    [self.subjectsStore deleteTimeInterval:self.subjectsForCurrentDay[cellIndexPath.row]];
    self.subjectsForCurrentDay = [self arrayForTitle];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    break;
    }
    default:
      break;
  }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
  return YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
