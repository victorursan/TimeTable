//
//  AddSubjectViewController.m
//  TimeTable
//
//  Created by Victor Ursan on 12/14/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "AddSubjectViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface AddSubjectViewController ()

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
  self.navigationController.title = @"Add Subject";
  self.view.backgroundColor = [UIColor greenColor];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [self.mm_drawerController.centerViewController setValue:@"OFF" forKey:@"buttonStatus"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.mm_drawerController.centerViewController setValue:@"ON" forKey:@"buttonStatus"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
