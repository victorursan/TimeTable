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
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"


@interface MainViewController ()

@property(strong, nonatomic) NSString *currentTitle;
@property(strong, nonatomic) NSArray *subjectsForCurrentView;
@property(strong, nonatomic) NSDateFormatter *timeFormat;

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
  NSArray *days = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subjects" style:UIBarButtonItemStylePlain target:self action:@selector(subjectsButtonPressed)];
  [self.navigationController setValue:days forKey:@"elements"];
  self.subjectsForCurrentView = [[NSArray alloc] init];
  self.timeFormat = [[NSDateFormatter alloc] init];
  [self.timeFormat setDateFormat:@"HH:00"];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setValue:@"ON" forKey:@"buttonStatus"];
  self.title = self.currentTitle;
  [self.tableView reloadData];
}


- (NSArray *)arrayForTitle {

  NSMutableArray *toSort = [[NSMutableArray alloc] init];

  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  for (Subject *subject in fetchedObjects){
    for (Day *day in subject.days){
      if ([day.dayName isEqualToString:self.currentTitle]) {
        for (TimeInterval *timeInterval in day.timeInterval){
          [toSort addObject:timeInterval];
        }
      }
    }
  }
  if (toSort.count != 0) {
    return [self sortSubjects:toSort];
  } else {
    return @[];
  }
}

- (NSArray *)sortSubjects:(NSMutableArray *)toSort {
  for (int i=0; i<toSort.count-1; i++) {
    for (int j=i+1; j<toSort.count; j++) {
      NSString *from1 = [self.timeFormat stringFromDate:[toSort[i] from]];
      NSString *from2 = [self.timeFormat stringFromDate:[toSort[j] from]];
      if (from1.intValue>from2.intValue) {
        id aux = toSort[i];
        toSort[i]=toSort[j];
        toSort[j]=aux;
      }
    }
  }
  NSArray *sorted = [[NSArray alloc] initWithArray:toSort];
  return sorted;
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
  } else if ([key isEqualToString:@"reloadData"]) {
    self.title = self.currentTitle;
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
  CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  TimeInterval *timeInterval = self.subjectsForCurrentView[indexPath.row];
  cell.title.text= [timeInterval.day.subjects name];
  cell.position.text = [NSString stringWithFormat:@" #%d",indexPath.row+1];
  [cell.position sizeToFit];
  cell.positionDescription.text = [NSString stringWithFormat:@"%@-%@",[self.timeFormat stringFromDate:timeInterval.from],[self.timeFormat stringFromDate:timeInterval.to]];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    NSError *error;

    TimeInterval *timeInterval = self.subjectsForCurrentView[indexPath.row];
    Day *day = timeInterval.day;
    [day.managedObjectContext deleteObject:timeInterval];
    self.subjectsForCurrentView = [self arrayForTitle];
    [self.tableView reloadData];
    if (![self.managedObjectContext save:&error]) {
      NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    Subject *subject = day.subjects;
    if (day.timeInterval.count==0) {
      [subject.managedObjectContext deleteObject:day];
    }
    if (![self.managedObjectContext save:&error]) {
      NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
    if (subject.days.count==0) {
      [self.managedObjectContext deleteObject:subject];
    }
    if (![self.managedObjectContext save:&error]) {
      NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PresentSubjectViewController *subjectView = [[PresentSubjectViewController alloc] init];
  subjectView.managedObjectContext = self.managedObjectContext;
  [self.navigationController pushViewController:subjectView animated:YES];
  TimeInterval *timeInterval = self.subjectsForCurrentView[indexPath.row];
  [subjectView setTitle:[timeInterval.day.subjects name]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
