//
// Created by Wuquancheng on 2018/7/20.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "UIView+Border.h"


@implementation UIView (Border)
- (CAShapeLayer*)addDottedBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    return [self addDottedBorder:borderColor fillColor:[UIColor clearColor] borderWidth:borderWidth cornerRadius:cornerRadius];
}

- (CAShapeLayer*)addDottedBorder:(UIColor *)borderColor fillColor:(UIColor*)fillColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = borderColor.CGColor;
    //填充的颜色
    border.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    //设置路径
    border.path = path.CGPath;

    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = borderWidth;

    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@8, @4];

    self.layer.cornerRadius = cornerRadius;

    [self.layer addSublayer:border];
    return border;
}

@end