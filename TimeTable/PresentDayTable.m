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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 21, self.frame.size.width-10, self.frame.size.height-25)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
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





- (void)drawRect:(CGRect)rect
{
  
  //// General Declarations
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //// Color Declarations
  UIColor* color2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
  UIColor* color3 = [UIColor colorWithRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
  
  //// Shadow Declarations
  UIColor* shadow = color3;
  CGSize shadowOffset = CGSizeMake(0.1, 3.1);
  CGFloat shadowBlurRadius = 5;
  
  //// Frames
  CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  
  
  //// Group
  {
  //// Bezier Drawing
  UIBezierPath* bezierPath = [UIBezierPath bezierPath];
  [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 170, CGRectGetMinY(frame) + 21)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 205, CGRectGetMinY(frame) + 21)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 205, CGRectGetMinY(frame) + 231)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 231)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 21)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 151, CGRectGetMinY(frame) + 21)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 160.5, CGRectGetMinY(frame) + 9)];
  [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 170, CGRectGetMinY(frame) + 21)];
  [bezierPath closePath];
  CGContextSaveGState(context);
  CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
  [color2 setFill];
  [bezierPath fill];
  CGContextRestoreGState(context);
  
  }
  
  
  
}


@end
