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
  
  [self setSubjectData];
  self.days = WEEKDAYS;
  
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
  self.presentedDays = self.dayDictionary.allKeys ;
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
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.presentedDays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return self.presentedDays[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.dayDictionary[self.presentedDays[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  TimeInterval *temp = self.dayDictionary[self.presentedDays[indexPath.section]][indexPath.row];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.tableView beginUpdates];
    TimeInterval *temp = self.dayDictionary[self.presentedDays[indexPath.section]][indexPath.row];
    [self.subjectStore deleteTimeInterval:temp];
    [self setSubjectData];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationRight];
    if ([self.tableView numberOfRowsInSection:indexPath.section]==1) {
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex: indexPath.section]
                    withRowAnimation:UITableViewRowAnimationRight];
    }
    [self.tableView endUpdates];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    
  }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView setEditing:editing animated:animated];
  if ([self isEditing]) {
    NSLog(@"yes");
  } else {
    NSLog(@"no");
  }
}

@end
