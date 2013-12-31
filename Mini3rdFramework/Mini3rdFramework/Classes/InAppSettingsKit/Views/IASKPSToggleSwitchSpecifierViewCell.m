//
//  IASKPSToggleSwitchSpecifierViewCell.m
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import "IASKPSToggleSwitchSpecifierViewCell.h"
#import "IASKSwitch.h"

@implementation IASKPSToggleSwitchSpecifierViewCell

@synthesize  toggle=_toggle;
            
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        // Initialization code
        _toggle = [[IASKSwitch alloc] initWithFrame:CGRectZero];
        [self.contentView insertSubview:_toggle aboveSubview:self.textLabel];
        
        
//        self.backgroundColor = YLCOLOR(0x395865ff);
//        self.textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _toggle.frame = CGRectMake(self.contentView.width - _toggle.width - KGap, (self.contentView.height - _toggle.height)/2,_toggle.width ,_toggle.height);
    self.textLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.top, _toggle.left - self.textLabel.left - KGap/2, self.textLabel.height);
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.left, self.detailTextLabel.top, _toggle.left - self.detailTextLabel.left - KGap/2, self.detailTextLabel.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [_toggle release];
    [super dealloc];
}


@end
