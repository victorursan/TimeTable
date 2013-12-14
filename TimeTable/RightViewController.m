//
//  RightViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "RightViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [self.mm_drawerController.centerViewController setValue:@"OFF" forKey:@"buttonStatus"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.tableView reloadData];
  [self.mm_drawerController.centerViewController setValue:@"ON" forKey:@"buttonStatus"];
}

- (NSArray *)allSubjects {
  return @[@"one",@"two",@"three",@"four",@"five",@"six",@"seven"];
}

#pragma mark - Table view

- (void)addTableView {
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 30, self.view.frame.size.width, self.view.frame.size.height-30)];
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
  NSLog(@"%@",cell.textLabel.text);
  if ([cell.textLabel.text isEqualToString:@"Add Subject"]) {
    NSLog(@"ad sub");
  }
  //  self.mm_drawerController.centerViewController.title = @"dsa";
  //  [self.mm_drawerController.centerViewController setValue:days forKey:@"elements"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
