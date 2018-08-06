//
//  MiniUIView.m
//  LS
//
//  Created by wu quancheng on 12-7-15.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIView.h"

@interface MiniUIView()
@property (nonatomic, strong) UIView *leftBorderView;
@property (nonatomic, strong) UIView *rightBorderView;
@property (nonatomic, strong) UIView *topBorderView;
@property (nonatomic, strong) UIView *bottomBorderView;
@end

@implementation MiniUIView
{
    void (^toucheAction)(MiniUIView* view);
    void (^toucheUpInsideAction)(MiniUIView* view);
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)dealloc
{
    if ( toucheAction )
    {
        Block_release( toucheAction );
        toucheAction = nil;
    }
    if ( toucheUpInsideAction )
    {
        Block_release( toucheUpInsideAction );
        toucheUpInsideAction = nil;
    }
    if (_leftBorderView != nil) {
        [_leftBorderView release];
        _leftBorderView = nil;
    }
    if (_rightBorderView != nil) {
        [_rightBorderView release];
        _rightBorderView = nil;
    }
    if (_topBorderView != nil) {
        [_topBorderView release];
        _topBorderView = nil;
    }
    if (_bottomBorderView != nil) {
        [_bottomBorderView release];
        _bottomBorderView = nil;
    }
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    if (_userInfo != nil) {
        [_userInfo release];
        _userInfo = nil;
    }
    if (_borderLayer != nil) {
         [_borderLayer release];
        _borderLayer = nil;
    }
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ( toucheAction )
    {
        toucheAction(self);
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if ( toucheUpInsideAction ) {
        toucheUpInsideAction(self);
    }
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)setToucheAction:( void (^)(MiniUIView* view) )block
{
    if ( toucheAction )
    {
        Block_release( toucheAction );
        toucheAction = nil;
    }
    
    if ( block )
    {
        toucheAction = Block_copy( block );
    }
}

- (void)setToucheUpInsideAction:( void (^)(MiniUIView* view) )block
{
    if ( toucheUpInsideAction )
    {
        Block_release( toucheUpInsideAction );
        toucheUpInsideAction = nil;
    }

    if ( block )
    {
        toucheUpInsideAction = Block_copy( block );
    }
}

- (void)setBorder:(MiniUIViewBorder)border {

    self.leftBorderView.hidden = YES;
    self.rightBorderView.hidden = YES;
    self.topBorderView.hidden = YES;
    self.bottomBorderView.hidden = YES;
    if ( border == MiniUIViewBorderNone) {

    }
    else {
        if ((border & MiniUIViewBorderLeft) == MiniUIViewBorderLeft) {
            if (self.leftBorderView == nil) {
                self.leftBorderView = [[UIView alloc] initWithFrame:CGRectZero];
                [self addSubview:self.leftBorderView];
            }
            self.leftBorderView.hidden = NO;
        }
        if ((border & MiniUIViewBorderRight) == MiniUIViewBorderRight) {
            if (self.rightBorderView == nil) {
                self.rightBorderView = [[UIView alloc] initWithFrame:CGRectZero];
                [self addSubview:self.rightBorderView];
            }
            self.rightBorderView.hidden = NO;
        }
        if ((border & MiniUIViewBorderTop) == MiniUIViewBorderTop) {
            if (self.topBorderView == nil) {
                self.topBorderView = [[UIView alloc] initWithFrame:CGRectZero];
                [self addSubview:self.topBorderView];
            }
            self.topBorderView.hidden = NO;
        }
        if ((border & MiniUIViewBorderBottom) == MiniUIViewBorderBottom) {
            if (self.bottomBorderView == nil) {
                self.bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
                [self addSubview:self.bottomBorderView];
            }
            self.bottomBorderView.hidden = NO;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_leftBorderView != nil && !_leftBorderView.hidden) {
        _leftBorderView.backgroundColor = _borderColor;
        _leftBorderView.frame = CGRectMake(0, 0, 1, self.height);
    }
    if (_rightBorderView != nil && !_rightBorderView.hidden) {
        _rightBorderView.backgroundColor = _borderColor;
        _rightBorderView.frame = CGRectMake(self.width-1, 0, 1, self.height);
    }
    if (_topBorderView != nil && !_topBorderView.hidden) {
        _topBorderView.backgroundColor = _borderColor;
        _topBorderView.frame = CGRectMake(0, 0, self.width, 1);
    }
    if (_bottomBorderView != nil && !_bottomBorderView.hidden) {
        _bottomBorderView.backgroundColor = _borderColor;
        _bottomBorderView.frame = CGRectMake(0, self.height-1, self.width, 1);
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (!CGRectEqualToRect(_borderLayer.frame, self.bounds)) {
        _borderLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius];
        //设置路径
        _borderLayer.path = path.CGPath;
    }
    [super layoutSublayersOfLayer:layer];
}

@end
