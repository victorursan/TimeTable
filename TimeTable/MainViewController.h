//
//  MainViewController.h
//  TimeTable
//
//  Created by Victor Ursan on 11/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;

@end
