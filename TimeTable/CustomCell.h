//
//  CustomCell.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UILabel *titleDescription;
@property(strong, nonatomic) UILabel *position;
@property(strong, nonatomic) UILabel *positionDescription;

@end
