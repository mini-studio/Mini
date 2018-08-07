//
// Created by Wuquancheng on 2018/7/20.
// Copyright (c) 2018 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Border)
- (CAShapeLayer*)addDottedBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
- (CAShapeLayer*)addDottedBorder:(UIColor *)borderColor fillColor:(UIColor*)fillColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
@end