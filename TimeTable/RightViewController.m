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
#import "PresentSubjectViewController.h"
#import "Subject.h"
#import "Day.h"
#import "TimeInterval.h"
#import "DayStore.h"

@interface RightViewController ()

@property(strong, nonatomic) NSArray *subjects;
@property (nonatomic, retain) SubjectStore *subjectsStore;

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
  self.subjectsStore = [[SubjectStore alloc] initWithContext:self.managedObjectContext];
  self.subjects = [self.subjectsStore subjectsTitles];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  self.subjects = [self.subjectsStore subjectsTitles];
  [self.tableView reloadData];
  [self.mm_drawerController.centerViewController setValue:@"OFF" forKey:@"buttonStatus"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.tableView reloadData];
  [self.mm_drawerController.centerViewController setValue:@"ON" forKey:@"buttonStatus"];
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
    addVC.dayStore = [[DayStore alloc] initWithContext:self.managedObjectContext];
    addVC.subjectStore = self.subjectsStore;
    [[self.mm_drawerController.centerViewController.childViewControllers[0] navigationController] pushViewController:addVC
                                                                                                            animated:YES];
  } else {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    PresentSubjectViewController *subjectView = [[PresentSubjectViewController alloc] init];
    subjectView.managedObjectContext = self.managedObjectContext;
    [[self.mm_drawerController.centerViewController.childViewControllers[0] navigationController] pushViewController:subjectView animated:YES];
    [subjectView setTitle:self.subjects[indexPath.row]];
    
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != self.subjects.count)
    return YES;
  return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.subjectsStore deleteSubjectWithName:self.subjects[indexPath.row]];
    [self.mm_drawerController.centerViewController.childViewControllers[0] setValue:@"YES" forKey:@"reloadData"];
    self.subjects = [self.subjectsStore subjectsTitles];
    [self.tableView reloadData];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
