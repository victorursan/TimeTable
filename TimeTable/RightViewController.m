//
//  RightViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "RightViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "AddSubjectViewController.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"

@interface RightViewController ()

@property(strong, nonatomic) NSArray *subjects;

@end

@implementation RightViewController

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
  self.subjects = [self allSubjects];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  self.subjects = [self allSubjects];
  NSArray *sortedArray = [self.subjects sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  self.subjects = sortedArray;
  [self.tableView reloadData];
  [self.mm_drawerController.centerViewController setValue:@"OFF" forKey:@"buttonStatus"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.tableView reloadData];
  [self.mm_drawerController.centerViewController setValue:@"ON" forKey:@"buttonStatus"];
}

- (NSArray *)allSubjects {
  NSMutableArray *toSort = [[NSMutableArray alloc] init];
  NSError *error;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
  for (Subject *subject in fetchedObjects){
    [toSort addObject:subject.name];
  }
  return toSort;
}

#pragma mark - Table view

- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                 30,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height-30)];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = YES;
  [self.view addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.subjects.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  if (indexPath.row != self.subjects.count) {
    cell.textLabel.text= self.subjects[indexPath.row];
  } else {
    cell.textLabel.text= @"Add Subject";
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if ([cell.textLabel.text isEqualToString:@"Add Subject"]) {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    AddSubjectViewController *addVC = [[AddSubjectViewController alloc] init];
    addVC.managedObjectContext = self.managedObjectContext;
    [[self.mm_drawerController.centerViewController.childViewControllers[0] navigationController] pushViewController:addVC
                                                                                                            animated:YES];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != self.subjects.count)
    return YES;
  return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    Subject *subjectToDelete;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Subject *subject in fetchedObjects) {
      if ([subject.name isEqualToString:self.subjects[indexPath.row]]) {
        subjectToDelete = subject;
      }
    }
    for (Day *day in subjectToDelete.days) {
      for (TimeInterval *timeInt in day.timeInterval){
        [day.managedObjectContext deleteObject:timeInt];
      }
      [subjectToDelete.managedObjectContext deleteObject:day];
    }
    [self.managedObjectContext deleteObject:subjectToDelete];

    if (![self.managedObjectContext save:&error]) {
      NSLog(@"Problem saving: %@", [error localizedDescription]);
    }

    [self.mm_drawerController.centerViewController.childViewControllers[0] setValue:@"YES" forKey:@"reloadData"];
    self.subjects = [self allSubjects];
    NSArray *sortedArray = [self.subjects sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.subjects = sortedArray;
    [self.tableView reloadData];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
