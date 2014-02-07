//
//  AddSubjectViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/14/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "AddSubjectViewController.h"
#import "config.h"
#import "SWTableViewCell.h"

@interface AddSubjectViewController ()

@property(strong, nonatomic) UITextField *subjectField;
@property(strong, nonatomic) NSMutableDictionary *sectionDictionary;
@property(strong, nonatomic) NSArray *daysArray;
@property(strong, nonatomic) UIView *hide;
@property(strong, nonatomic) UIButton *done;
@property(strong, nonatomic) UIButton *cancel;
@property(strong, nonatomic) NSIndexPath *temp;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

@end

@implementation AddSubjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setValue:@"OFF" forKey:@"buttonStatus"];
  self.navigationController.title = @"Add Subject";
  
  self.sectionDictionary = [[NSMutableDictionary alloc] initWithDictionary: @{MONDAY:@[],
                                                                              TUESDAY: @[],
                                                                              WEDNESDAY: @[],
                                                                              THURSDAY: @[],
                                                                              FRIDAY: @[],
                                                                              SATURDAY: @[],
                                                                              SUNDAY: @[]}];
  self.daysArray = WEEKDAYS;
  
  self.done = [[UIButton alloc] initWithFrame:CGRectMake(270, self.view.frame.size.height-215, 50, 30)];
  [self.done setTitle:@"Done" forState:UIControlStateNormal];
  [self.done setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.done addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.done.hidden = YES;
  [self.view addSubview:self.done];
  
  self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-215, 50, 30)];
  [self.cancel setTitle:@"Cancel" forState:UIControlStateNormal];
  [self.cancel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.cancel sizeToFit];
  [self.cancel addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.cancel.hidden = YES;
  [self.view addSubview:self.cancel];
  
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.hide = [[UIView alloc] initWithFrame:self.view.bounds];
  self.hide.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addSubject)];
  
  UILabel *subjectLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 105, 50, 25)];
  subjectLable.text = @"Subject :";
  [subjectLable sizeToFit];
  [self.view addSubview:subjectLable];
  
  self.timeFormat = [[NSDateFormatter alloc] init];
  [self.timeFormat setDateFormat:@"HH:00"];
  
  self.subjectField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 150, 25)];
  self.subjectField.borderStyle = UITextBorderStyleLine;
  self.subjectField.returnKeyType = UIReturnKeyDone;
  [self.subjectField addTarget:self action:@selector(subjectEditingEnded) forControlEvents:UIControlEventAllEditingEvents];
  [self.view addSubview:self.subjectField];
  
  [self addTableView];
  [self addDatePicker];
}

- (void)subjectEditingEnded {
}

- (void)addSubject {
  if ([self.subjectField.text isEqualToString:@""])
    [self allertWithMessage:@"Subject field is empty"];
  else if([self isTableViewEmpty])
    [self allertWithMessage:@"Table view is empty"];
  else {
    
    NSSet *daysSet = [self.dayStore daysWithTimeIntervalsFromDictionary: self.sectionDictionary];
    [self.subjectStore addSubjectWithName:self.subjectField.text onDays:daysSet];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

- (void)allertWithMessage:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (BOOL)isTableViewEmpty {
  BOOL permission = YES;
  for (NSString *day in self.daysArray)
    if ([self.sectionDictionary[day] count] != 0) permission = NO;
  return permission;
}

#pragma mark - Table view

- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-150)];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = YES;
  self.tableView.scrollEnabled = YES;
  self.tableView.editing = NO;
  [self.view addSubview:self.tableView];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return WEEKDAYSNUM;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return self.daysArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.sectionDictionary valueForKey:self.daysArray[section]] count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  SWTableViewCell *cell =(SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier
                              containingTableView:_tableView // Used for row height and selection
                               leftUtilityButtons:nil
                              rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;
    [cell setCellHeight:30];
  }
  
  if (indexPath.row != [[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count]) {
    NSDate *from =[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]][indexPath.row];
    NSDate *to = [from dateByAddingTimeInterval:60*60];
    NSString *string = [NSString stringWithFormat:@"%@-%@",
                        [self.timeFormat stringFromDate:from],
                        [self.timeFormat stringFromDate:to]];
    cell.textLabel.text = string;
  } else {
    cell.textLabel.text = @"+";
  }
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
  switch (index) {
    case 0:
    {
    NSLog(@"More button was pressed");
    UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello"
                                                        message:@"More more more"
                                                       delegate:nil
                                              cancelButtonTitle:@"cancel"
                                              otherButtonTitles: nil];
    [alertTest show];
    
    [cell hideUtilityButtonsAnimated:YES];
    break;
    }
    case 1:
    {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *change = [self.sectionDictionary objectForKey:self.daysArray[indexPath.section]];
    [change removeObjectAtIndex:indexPath.row];
    [self.sectionDictionary setValue:change forKey:self.daysArray[indexPath.section]];

    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
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

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
  if ([cell.textLabel.text isEqualToString:@"+"])
    return NO;
  return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.subjectField resignFirstResponder];
  if ([[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count] == indexPath.row) {
    [self.view addSubview:self.hide];
    [self.view bringSubviewToFront:self.datePicker];
    [self.view bringSubviewToFront:self.done];
    [self.view bringSubviewToFront:self.cancel];
    self.datePicker.hidden = NO;
    self.done.hidden = NO;
    self.cancel.hidden = NO;
    self.temp = indexPath;
  }
}

#pragma mark - DatePicker

- (void)addDatePicker {
  self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-215, 320, 250)];
  self.datePicker.hidden = YES;
  self.datePicker.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
  self.datePicker.datePickerMode = UIDatePickerModeTime;
  self.datePicker.minuteInterval = 30;
  [self.view addSubview:self.datePicker];
}

- (void)doneButtonPressed {
  [self.hide removeFromSuperview];
  NSString *string = [self.timeFormat stringFromDate:self.datePicker.date];
  NSDate *date = [self.timeFormat dateFromString:string];
  NSMutableArray *new = [[NSMutableArray alloc] initWithArray: [self.sectionDictionary valueForKey:self.daysArray[self.temp.section]]];
  [new addObject:date];
  [self.sectionDictionary setValue:new forKey:self.daysArray[self.temp.section]];
  self.datePicker.hidden = YES;
  self.done.hidden = YES;
  self.cancel.hidden = YES;
  [self.tableView reloadData];
}

- (void)cancelButtonPressed {
  [self.hide removeFromSuperview];
  self.datePicker.hidden = YES;
  self.done.hidden = YES;
  self.cancel.hidden = YES;
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
