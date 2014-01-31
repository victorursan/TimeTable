//
//  PresentDayTable.m
//  TimeTable
//
//  Created by Victor Ursan on 1/30/14.
//  Copyright (c) 2014 Victor Ursan. All rights reserved.
//

#import "PresentDayTable.h"

@implementation PresentDayTable

- (id)initWithFrame:(CGRect)frame andDelegate:(id) delegate {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.delegate = delegate;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8; // if you like rounded corners
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.2;
    [self addSubview:self.tableView];
  }
  return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return  [self.tableViewElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  cell.textLabel.text = self.tableViewElements[indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.delegate presentViewControllerForDay:self.tableViewElements[indexPath.row]];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
