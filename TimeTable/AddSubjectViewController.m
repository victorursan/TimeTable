//
//  AddSubjectViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/14/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "AddSubjectViewController.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"
#import "config.h"
#import "SubjectStore.h"
#import "DayStore.h"

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
  
  self.done = [[UIButton alloc] initWithFrame:CGRectMake(270, 350, 50, 30)];
  [self.done setTitle:@"Done" forState:UIControlStateNormal];
  [self.done setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.done addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.done.hidden = YES;
  [self.view addSubview:self.done];
  
  self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 350, 50, 30)];
  [self.cancel setTitle:@"Cancel" forState:UIControlStateNormal];
  [self.cancel setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.cancel sizeToFit];
  [self.cancel addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.cancel.hidden = YES;
  [self.view addSubview:self.cancel];
  
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.hide = [[UIView alloc] initWithFrame:self.view.bounds];
  self.hide.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(addSubject)];
  
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
  // NSLog(@"editing: %@", self.subjectField.text);
}

- (void)addSubject {
  if ([self.subjectField.text isEqualToString:@""]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Subject field is empty"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  } else if([self isTableViewEmpty]){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Table view is empty"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
  } else {

    DayStore *dayStore = [[DayStore alloc] initWithContext: self.managedObjectContext];
    NSSet *daysSet = [dayStore daysWithTimeIntervalsFromDictionary: self.sectionDictionary];
    
    SubjectStore  *subjectStore = [[SubjectStore alloc] initWithContext:self.managedObjectContext];
    [subjectStore addSubjectWithName:self.subjectField.text onDays:daysSet];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

- (BOOL)isTableViewEmpty {
  BOOL permission=YES;
  for (int i =0; i < WEEKDAYSNUM; i++)
    if ([self.sectionDictionary[self.daysArray[i]] count] != 0) permission = NO;
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  if (indexPath.row != [[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count]) {
    
    NSDate *from =[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]][indexPath.row];
    NSDate *to = [from dateByAddingTimeInterval:60*60];
    
    NSString *string = [NSString stringWithFormat:@"%@-%@",[self.timeFormat stringFromDate:from],[self.timeFormat stringFromDate:to]];
    cell.textLabel.text = string;
  } else {
    cell.textLabel.text = @"+";
  }
  return cell;
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//  if([[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count] != indexPath.row){
//    return YES;
//  } else {
//    return NO;
//  }
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (editingStyle == UITableViewCellEditingStyleDelete) {
//    [self.sectionDictionary removeo]
//  }
//}

#pragma mark - DatePicker

- (void)addDatePicker {
  self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 350, 320, 250)];
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
