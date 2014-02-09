//
//  PresentSubjectViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "PresentSubjectViewController.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"
#import "config.h"

@interface PresentSubjectViewController ()

@property(strong, nonatomic) NSString *currentTitle;
@property(strong, nonatomic) UILabel *subjectName;
@property(strong, nonatomic) Subject *presentedSubject;
@property(strong, nonatomic) NSArray *presentedDays;
@property(strong, nonatomic) NSArray *days;
@property(strong, nonatomic) NSDictionary *dayDictionary;
@property(strong, nonatomic) NSDateFormatter *timeFormat;
@property(strong, nonatomic) CustomTimePicker *customTimePicker;
@property(strong, nonatomic) NSIndexPath *selectedIndex;

@end

@implementation PresentSubjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setSubjectData];
  self.days = WEEKDAYS;
  
  self.customTimePicker = [[CustomTimePicker alloc] initWithFrame:self.view.frame andDelegate:self];
  
  UILabel *subjectLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 105, 75, 25)];
  subjectLable.text = @"Subject :";
  [subjectLable sizeToFit];
  [self.view addSubview:subjectLable];
  
  self.timeFormat = [[NSDateFormatter alloc] init];
  [self.timeFormat setDateFormat:@"HH:00"];
  
  self.subjectName = [[UILabel alloc] initWithFrame:CGRectMake(100, 105, 100, 25)];
  self.subjectName.text = self.currentTitle;
  [self.subjectName sizeToFit];
  [self.view addSubview:self.subjectName];
  [self addTableView];
}

- (void)setTitleWithSubject:(Subject *)subject {
  [self.navigationController setValue:@"OFF" forKey:@"buttonStatus"];
  self.currentTitle = subject.name;
  self.navigationController.title = subject.name;
  self.presentedSubject = subject;
  
}

- (void)setSubjectData {
  self.dayDictionary = [self.subjectStore dictionaryforSubject:self.presentedSubject];
  self.presentedDays = self.dayDictionary.allKeys ;
}


#pragma mark - Table view

- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-150)];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = NO;
  self.tableView.scrollEnabled = YES;
  self.tableView.editing = NO;
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.presentedDays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return self.presentedDays[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dayDictionary[self.presentedDays[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier
                              containingTableView:_tableView // Used for row height and selection
                               leftUtilityButtons:nil
                              rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;
  }
  
  [cell setCellHeight:30];
  TimeInterval *temp = self.dayDictionary[self.presentedDays[indexPath.section]][indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[self.timeFormat stringFromDate:temp.from],[self.timeFormat stringFromDate:temp.to]];
  return cell;
}

- (NSArray *)rightButtons
{
  NSMutableArray *rightUtilityButtons = [NSMutableArray new];
  [rightUtilityButtons sw_addUtilityButtonWithColor:
   [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                              title:@"Edit"];
  [rightUtilityButtons sw_addUtilityButtonWithColor:
   [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                              title:@"Delete"];
  
  return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
  switch (index) {
    case 0:
    {
    [self.customTimePicker pickerWithoutHours:[self.dayStore hoursInDay:self.presentedDays[cellIndexPath.section]]];
    self.selectedIndex = cellIndexPath;
    [self.view addSubview:self.customTimePicker];
    
    [cell hideUtilityButtonsAnimated:YES];
    break;
    }
    case 1:
    {
    [self.tableView beginUpdates];
    TimeInterval *temp = self.dayDictionary[self.presentedDays[cellIndexPath.section]][cellIndexPath.row];
    [self.subjectStore deleteTimeInterval:temp];
    [self setSubjectData];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    if ([self.tableView numberOfRowsInSection:cellIndexPath.section]==1) {
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex: cellIndexPath.section]
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30;
}

- (void)addTime:(NSDate *)time {
  NSMutableArray *new = [[NSMutableArray alloc] initWithArray: [self.dayDictionary valueForKey:self.presentedDays[self.selectedIndex.section]]];
  TimeInterval *temp = new[self.selectedIndex.row];
  Day *selectedDay = temp.day;
  [self.subjectStore deleteTimeInterval:temp];
  [self.subjectStore addTimeInterval:time forSubject:self.presentedSubject andDay:selectedDay];
  [self setSubjectData];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
