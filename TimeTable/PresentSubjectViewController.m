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
@property BOOL editMode;

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
  
  self.editMode = NO;
  
  self.days = WEEKDAYS;
  [self setSubjectData];
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
  NSMutableArray *tempArray = [@[] mutableCopy];
  for (NSString *day in self.days) {
    if ([self.dayDictionary.allKeys containsObject:day]) {
      [tempArray addObject:day];
    }
  }
  self.presentedDays = tempArray;
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
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
  [self.view addSubview:self.tableView];
}

- (void)editPressed {
  self.editMode = YES;
  [self.tableView reloadData];
  [self.tableView setEditing: YES animated: YES];
  //self.tableView.allowsSelection = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)];
}

- (void)doneButton {
  self.editMode = NO;
  [self.tableView reloadData];
  [self.tableView setEditing: NO animated: YES];
  //self.tableView.allowsSelection = NO;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dayDictionary[self.days[indexPath.section]] && indexPath.row < [self.dayDictionary[self.days[indexPath.section]] count]) {
    return UITableViewCellEditingStyleDelete;
  } else {
    return UITableViewCellEditingStyleInsert;
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.tableView beginUpdates];
    TimeInterval *temp = self.dayDictionary[self.presentedDays[indexPath.section]][indexPath.row];
    [self.subjectStore deleteTimeInterval:temp];
    [self setSubjectData];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    if ([self.tableView numberOfRowsInSection:indexPath.section]==1) {
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section]
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.tableView endUpdates];
  } else {
    [self.customTimePicker pickerWithoutHours:[self.dayStore hoursInDay:self.presentedDays[indexPath.section]]];
    self.selectedIndex = indexPath;
    [self.view addSubview:self.customTimePicker];
    [self setSubjectData];
    [self.tableView reloadData];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.editMode) {
    return YES;
  }
  return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.editMode) {
    return 7;
  }
  return [self.presentedDays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.editMode) {
    return self.days[section];
  }
  return self.presentedDays[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.editMode) {
    return [self.dayDictionary[self.days[section]] count]+1;
  }
  return [self.dayDictionary[self.presentedDays[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (self.editMode) {
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
      cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (self.dayDictionary[self.days[indexPath.section]] && indexPath.row < [self.dayDictionary[self.days[indexPath.section]] count]) {
      TimeInterval *temp = self.dayDictionary[self.days[indexPath.section]][indexPath.row];
      cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[self.timeFormat stringFromDate:temp.from],[self.timeFormat stringFromDate:temp.to]];
    } else {
      cell.textLabel.text = @"";
    }
    
    return cell;
    
  } else {
    static NSString *CellIdentifier = @"SWTableViewCell";
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
}

- (NSArray *)rightButtons {
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
  [self setSubjectData];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
  return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30;
}

- (void)addTime:(NSDate *)time {
  NSMutableArray *new = [[NSMutableArray alloc] initWithArray: [self.dayDictionary valueForKey:self.days[self.selectedIndex.section]]];
  if ([new count]<self.selectedIndex.row) {
    TimeInterval *temp = new[self.selectedIndex.row];
    [self.subjectStore deleteTimeInterval:temp];
    [self.subjectStore addTimeInterval:time forSubject:self.presentedSubject andDayName:self.days[self.selectedIndex.section]];
    [self setSubjectData];
    [self.tableView reloadData];
  } else {
    [self.subjectStore addTimeInterval:time forSubject:self.presentedSubject andDayName:self.days[self.selectedIndex.section]];
    [self setSubjectData];
    [self.tableView reloadData];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
