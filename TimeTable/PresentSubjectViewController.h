//
//  PresentSubjectViewController.h
//  TimeTable
//
//  Created by Victor Ursan on 12/9/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectStore.h"
#import "SWTableViewCell.h"
#import "CustomTimePicker.h"

@interface PresentSubjectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, CustomTimePickerDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) SubjectStore *subjectStore;

- (void)setTitleWithSubject:(Subject *)subject;

@end
