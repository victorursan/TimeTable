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
#import "DayStore.h"
#import "SubjectStore.h"

@interface RightViewController ()

@property(strong, nonatomic) NSArray *subjects;
@property(nonatomic, retain) SubjectStore *subjectStore;

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
  self.subjectStore = [[SubjectStore alloc] initWithContext:self.managedObjectContext];
  self.subjects = [self.subjectStore subjectsTitles];
  [self addTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  self.subjects = [self.subjectStore subjectsTitles];
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
  SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier
                              containingTableView:_tableView // Used for row height and selection
                               leftUtilityButtons:nil
                              rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;
  }
  
  if (indexPath.row != self.subjects.count) {
    cell.textLabel.text= self.subjects[indexPath.row];
  } else {
    cell.textLabel.text= @"Add Subject";
  }
  return cell;
}

- (NSArray *)rightButtons
{
  NSMutableArray *rightUtilityButtons = [NSMutableArray new];
  [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                              title:@"Delete"];
  
  return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
  switch (index) {
    case 0:
    {
    // Delete button was pressed
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    [self.subjectStore deleteSubjectWithName:self.subjects[cellIndexPath.row]];
    [self.mm_drawerController.centerViewController.childViewControllers[0] setValue:@"YES" forKey:@"reloadData"];
    self.subjects = [self.subjectStore subjectsTitles];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    break;
    }
    default:
      break;
  }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
  return NO;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
  NSLog(@"label:%@",cell.textLabel.text);
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if (indexPath.row != self.subjects.count)
    return YES;
  return NO;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if ([cell.textLabel.text isEqualToString:@"Add Subject"]) {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    AddSubjectViewController *addVC = [[AddSubjectViewController alloc] init];
    addVC.dayStore = [[DayStore alloc] initWithContext:self.managedObjectContext];
    addVC.subjectStore = self.subjectStore;
    [[self.mm_drawerController.centerViewController.childViewControllers[0] navigationController] pushViewController:addVC
                                                                                                            animated:YES];
  } else {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    PresentSubjectViewController *subjectView = [[PresentSubjectViewController alloc] init];
    subjectView.subjectStore = self.subjectStore;
    [[self.mm_drawerController.centerViewController.childViewControllers[0] navigationController] pushViewController:subjectView
                                                                                                            animated:YES];
    [subjectView setTitleWithSubject:[self.subjectStore subjectForTitle:self.subjects[indexPath.row]]];
    
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
