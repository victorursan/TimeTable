//
//  CustomCell.h
//  TimeTable
//
//  Created by Victor Ursan on 12/15/13.
//  Copyright (c) 2013 Victor Ursan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CustomCell : SWTableViewCell

@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) UILabel *titleDescription;
@property(retain, nonatomic) UILabel *position;
@property(strong, nonatomic) UILabel *positionDescription;

@end
