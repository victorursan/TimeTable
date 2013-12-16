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

@interface PresentSubjectViewController ()

@property(strong, nonatomic) NSString *currentTitle;
@property(strong, nonatomic) UILabel *subjectName;
@property(strong, nonatomic) Subject *presentedSubject;
@property(strong, nonatomic) NSArray *presentedDays;
@property(strong, nonatomic) NSArray *timeInterval;
@property(strong, nonatomic) NSDictionary *dayDictionary;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

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

  NSMutableArray *tempDays = [[NSMutableArray alloc] init];
  //NSMutableArray *tempTimeInt = [[NSMutableArray alloc] init];
  NSMutableDictionary *tempDayDictionary = [[NSMutableDictionary alloc] init];


  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  for (Subject *subject in fetchedObjects){
    if ([subject.name isEqualToString:self.currentTitle]) {
      self.presentedSubject = subject;
      for (Day *day in subject.days) {
        [tempDays addObject:day.dayName];
        NSMutableArray *tempTimeInt = [[NSMutableArray alloc] init];
        for (TimeInterval *timeInt in day.timeInterval){
          [tempTimeInt addObject:timeInt];
        }
        [tempDayDictionary addEntriesFromDictionary:@{day.dayName: tempTimeInt}];
      }
    }
  }
  self.presentedDays = [[NSArray alloc] initWithArray:tempDays];
  self.dayDictionary = [[NSDictionary alloc] initWithDictionary:tempDayDictionary];

  NSArray *sortedArray = [self.presentedDays sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  self.presentedDays = sortedArray;

  [self addTableView];
}

- (void)setTitle:(NSString *)title {
  [self.navigationController setValue:@"OFF" forKey:@"buttonStatus"];
  self.currentTitle = title;
  self.navigationController.title = title;
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
  return self.presentedDays.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return self.presentedDays[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.dayDictionary valueForKey:self.presentedDays[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  TimeInterval *temp = [self.dayDictionary valueForKey:self.presentedDays[indexPath.section]][indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[self.timeFormat stringFromDate:temp.from],[self.timeFormat stringFromDate:temp.to]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
