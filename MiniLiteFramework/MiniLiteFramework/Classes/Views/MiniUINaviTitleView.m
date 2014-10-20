//
//  MiniUINaviTitleView.m
//  FleetRecruit
//
//  Created by Wuquancheng on 13-7-13.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import "MiniUINaviTitleView.h"
#import "UILabel+Mini.h"

@interface MiniUINaviTitleView ()
@property (nonatomic,strong)UIImageView *backgoundView;
@property (nonatomic,strong)UILabel     *titleLabel;
@end

@implementation MiniUINaviTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgoundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgoundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backgoundView];
        self.titleLabel = [UILabel LabelWithFrame:CGRectZero bgColor:[UIColor clearColor] text:@"" color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter shadowColor:nil shadowSize:CGSizeZero];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 14;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layout];
}

- (void)layout
{
    if ( self.leftButton != nil ) {
        self.leftButton.center = CGPointMake(10 + self.leftButton.width/2, self.height/2);
    }
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
    if ( self.rightButton != nil ) {
        self.rightButton.center = CGPointMake(self.width - self.rightButton.width/2 - 10, self.height/2);
    }
    [self.titleLabel sizeToFit];
    CGFloat maxwidth = self.width- self.leftButton.width - self.rightButton.width - 40;
    if ( self.titleLabel.width > maxwidth ) {
        self.titleLabel.width = maxwidth;
    }
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
}

- (void)setLeftButton:(MiniUIButton *)leftButton
{
    [self.leftButton removeFromSuperview];
    _leftButton = leftButton;
    [self addSubview:leftButton];
    [self setNeedsDisplay];
}

- (void)setRightButton:(MiniUIButton *)rightButton
{
    [self.rightButton removeFromSuperview];
    _rightButton = rightButton;
    [self addSubview:self.rightButton];
    [self setNeedsDisplay];
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self layout];
}

- (void)setBackGround:(UIImage *)image
{
    self.backgoundView.image = image;
}

@end
