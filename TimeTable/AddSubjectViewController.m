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

@interface AddSubjectViewController ()

@property(strong, nonatomic) UITextField *subjectField;
@property(strong, nonatomic) NSMutableDictionary *sectionDictionary;
@property(strong, nonatomic) NSArray *daysArray;
@property(strong, nonatomic) UIView *hide;
@property(strong, nonatomic) UIButton *done;
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

  self.sectionDictionary = [[NSMutableDictionary alloc] initWithDictionary: @{@"Monday":@[],
                                                                              @"Tuesday": @[],
                                                                              @"Wednesday": @[],
                                                                              @"Thursday": @[],
                                                                              @"Friday": @[],
                                                                              @"Saturday": @[],
                                                                              @"Sunday": @[]}];
  self.daysArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];

  self.done = [[UIButton alloc] initWithFrame:CGRectMake(270, 350, 50, 30)];
  [self.done setTitle:@"Done" forState:UIControlStateNormal];
  [self.done setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
  [self.done addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.done.hidden = YES;
  [self.view addSubview:self.done];

  self.view.backgroundColor = [UIColor whiteColor];
  self.hide = [[UIView alloc] initWithFrame:self.view.bounds];
  self.hide.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
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
 // NSLog(@"editing: %@", self.subjectField.text);
}

- (void)addSubject {

  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
  newSubject.name = self.subjectField.text;

  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Problem saving: %@", [error localizedDescription]);
  }

  for (int i=0 ; i<7; i++) {
    if ([self.sectionDictionary[self.daysArray[i]] count]!=0) {
      Day *newDay = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
      newDay.dayName = self.daysArray[i];

      if (![self.managedObjectContext save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
      }

      for (int j=0; j<[self.sectionDictionary[self.daysArray[i]] count]; j++) {
        NSDate *from = [self.sectionDictionary valueForKey:self.daysArray[i]][j];
        NSDate *to = [from dateByAddingTimeInterval:60*60];
        TimeInterval *newTimeInterval = [NSEntityDescription insertNewObjectForEntityForName:@"TimeInterval"
                                                                      inManagedObjectContext:self.managedObjectContext];
        newTimeInterval.from =from;
        newTimeInterval.to = to;
        if (![self.managedObjectContext save:&error]) {
          NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
        [newDay addTimeIntervalObject:newTimeInterval];
        if (![self.managedObjectContext save:&error]) {
          NSLog(@"Problem saving: %@", [error localizedDescription]);
        }
      }
      [newSubject addDaysObject:newDay];
      if (![self.managedObjectContext save:&error]) {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
      }
    }
  }
  [self.navigationController popToRootViewControllerAnimated:YES];
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
  return 7;
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
    self.datePicker.hidden = NO;
    self.done.hidden = NO;
    self.temp = indexPath;
  }
}

#pragma mark - DatePicker

- (void)addDatePicker {
  self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 350, 320, 250)];
  self.datePicker.hidden = YES;
  self.datePicker.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
  self.datePicker.datePickerMode = UIDatePickerModeTime;
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
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
