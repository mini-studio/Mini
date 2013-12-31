//
//  IASKUITableViewCell.m
//  LS
//
//  Created by wu quancheng on 12-8-4.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "IASKUITableViewCell.h"
#import "UIView+Mini.h"

@implementation IASKUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ( self.detailTextLabel.textAlignment == UITextAlignmentLeft  )
    {
        self.detailTextLabel.left = self.textLabel.right + 5;
    }
}

@end
