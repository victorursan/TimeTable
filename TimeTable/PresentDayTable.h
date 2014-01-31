//
//  PresentDayTable.h
//  TimeTable
//
//  Created by Victor Ursan on 1/30/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentDayTableDelegate.h"


@interface PresentDayTable : UIView <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) id<PresentDayTableDelegate>delegate;

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *tableViewElements;

- (id)initWithFrame:(CGRect)frame andDelegate:(id) delegate;

@end
