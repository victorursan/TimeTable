//
//  AddSubjectViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/14/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "AddSubjectViewController.h"

@interface AddSubjectViewController ()

@property(strong, nonatomic) UITextField *subjectField;
@property(strong, nonatomic) NSMutableDictionary *sectionDictionary;
@property(strong, nonatomic) NSArray *daysArray;


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

  self.view.backgroundColor = [UIColor whiteColor];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];

  UILabel *subjectLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 105, 50, 25)];
  subjectLable.text = @"Subject :";
  [subjectLable sizeToFit];
  [self.view addSubview:subjectLable];

  self.subjectField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 150, 25)];
  self.subjectField.borderStyle = UITextBorderStyleLine;
  self.subjectField.returnKeyType = UIReturnKeyDone;
  [self.subjectField addTarget:self action:@selector(subjectEditingEnded) forControlEvents:UIControlEventAllEditingEvents];
  [self.view addSubview:self.subjectField];

  [self addTableView];
  [self addPickerView];
}

- (void)subjectEditingEnded {
  NSLog(@"editing: %@", self.subjectField.text);
}

- (void)addSubject {
  NSLog(@"Save");
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
  if (indexPath.row != [[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count] ) {
    NSString *string = [[NSString alloc] initWithFormat:@"%@",[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]][indexPath.row]];
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
  if ([[self.sectionDictionary valueForKey:self.daysArray[indexPath.section]] count] == indexPath.row) {
    NSMutableArray *new = [[NSMutableArray alloc] initWithArray: [self.sectionDictionary valueForKey:self.daysArray[indexPath.section]]];
    [new addObject:@1];

    UIView *hide = [[UIView alloc] initWithFrame:self.view.bounds];
    hide.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:hide];

    [self.view bringSubviewToFront:self.pickerView];

    self.pickerView.hidden = NO;
    [self.sectionDictionary setValue:new forKey:self.daysArray[indexPath.section]];
    [self.tableView reloadData];
  }
}

#pragma mark - Picker View 

- (void)addPickerView {
  self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 350, 320, 250)];
  self.pickerView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
  self.pickerView.delegate = self;
  self.pickerView.dataSource = self;
  self.pickerView.hidden = YES;

  [self.view addSubview:self.pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
  return 4;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
  switch (component) {
    case 0: return 1;
    case 1: return 4;
    case 2: return 1;
    case 3: return 4;
    default: return -1;
  }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [NSString stringWithFormat:@"Choice-%d",row];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
