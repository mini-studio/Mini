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
@property (nonatomic,strong)UIImageView *backgroundView;
@property (nonatomic,strong)UILabel     *titleLabel;
@end

@implementation MiniUINaviTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backgroundView];
        self.titleLabel = [UILabel LabelWithFrame:CGRectZero bgColor:[UIColor clearColor] text:@"" color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:18] alignment:NSTextAlignmentCenter shadowColor:nil shadowSize:CGSizeZero];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumFontSize = 14;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    if (_leftButton != nil) {
        [_leftButton release];
        _leftButton = nil;
    }
    if (_rightButton != nil) {
        [_rightButton release];
        _rightButton = nil;
    }
    if (_title != nil) {
       [_title release];
        _title = nil;
    }
    if (_backGround != nil) {
        [_backGround release];
        _backGround = nil;
    }
    if (_titleLabel != nil) {
        [_titleLabel release];
        _titleLabel = nil;
    }
    if (_shadowView != nil) {
        [_shadowView release];
        _shadowView = nil;
    }
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
    CGFloat maxWidth = self.width- self.leftButton.width - self.rightButton.width - 40;
    if ( self.titleLabel.width > maxWidth ) {
        self.titleLabel.width = maxWidth;
    }
    self.titleLabel.center = CGPointMake(self.width/2, self.height/2);
}

- (void)setLeftButton:(MiniUIButton *)leftButton
{
    [leftButton retain];
    [_leftButton removeFromSuperview];
    [_leftButton release];
    _leftButton = leftButton;
    if (_leftButton != nil) {
        [self addSubview:_leftButton];
    }
    [self setNeedsDisplay];
}

- (void)setRightButton:(MiniUIButton *)rightButton
{
    [rightButton retain];
    [_rightButton removeFromSuperview];
    [_rightButton release];
    _rightButton = rightButton;
    [self addSubview:self.rightButton];
    [self setNeedsDisplay];
}

-(void)setTitle:(NSString *)title
{
    [title retain];
    [_title release];
    _title = title;
    self.titleLabel.text = title;
    [self layout];
}

- (void)setBackGround:(UIImage *)image
{
    [image retain];
    [_backGround release];
    _backGround = image;
    self.backgroundView.image = _backGround;
}

- (void)setShadowView:(UIView *)shadowView
{
    [shadowView retain];
    if (_shadowView != nil) {
        [_shadowView removeFromSuperview];
        [_shadowView release];
    }
    _shadowView = shadowView;
    shadowView.frame = CGRectMake(0, self.height, self.width, shadowView.height);
    [self addSubview:shadowView];
}

@end
