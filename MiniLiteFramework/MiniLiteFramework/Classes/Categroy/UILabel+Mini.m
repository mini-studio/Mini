//
//  UILabel+Mini.m
//  MiniShop
//
//  Created by Mini-Studio on 13-4-5.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import "UILabel+Mini.h"

@implementation UILabel (Mini)
+ (UILabel*)LabelWithFrame:(CGRect)rect bgColor:(UIColor*)backgroundColor text:(NSString*)text color:(UIColor*)textColor font:(UIFont*)textFont alignment:(NSTextAlignment)alignment shadowColor:(UIColor*)shadowColor shadowSize:(CGSize) shadowSize
{
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = backgroundColor;
    label.text  = text;
    label.textColor = textColor;
    label.font = textFont;
    label.textAlignment = alignment;
    label.shadowColor = shadowColor;
    label.shadowOffset = shadowSize;
    return label;
}
@end
