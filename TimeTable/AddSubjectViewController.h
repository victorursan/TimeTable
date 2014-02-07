//
//  AddSubjectViewController.h
//  TimeTable
//
//  Created by Victor Ursan on 12/14/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectStore.h"
#import "DayStore.h"
#import "SWTableViewCell.h"

@interface AddSubjectViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (nonatomic, retain) SubjectStore *subjectStore;
@property (nonatomic, retain) DayStore *dayStore;

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIDatePicker *datePicker;

@end
