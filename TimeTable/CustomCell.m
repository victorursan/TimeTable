//
//  CustomCell.m
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.position = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 30, 22)];
    self.position.textColor = [UIColor darkGrayColor];
    //self.position.backgroundColor = [UIColor redColor];
    [self addSubview:self.position];

    self.positionDescription = [[UILabel alloc] initWithFrame:CGRectMake(5, 22, 60, 20)];
    self.positionDescription.font = [UIFont fontWithName:@"Arial" size:11];
    self.positionDescription.textColor = [UIColor lightGrayColor];
    //self.positionDescription.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.positionDescription];

    self.title = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 260, 25)];
    //self.title.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.title];

    self.titleDescription = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 280, 20)];
    //self.titleDescription.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.titleDescription];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
