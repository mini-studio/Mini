//
//  UILabel+Mini.h
//  MiniShop
//
//  Created by Mini-Studio on 13-4-5.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Mini)
+ (UILabel*)LabelWithFrame:(CGRect)rect bgColor:(UIColor*)backgroundColor text:(NSString*)text color:(UIColor*)textColor font:(UIFont*)textFont alignment:(NSTextAlignment)alignment shadowColor:(UIColor*)shadowColor shadowSize:(CGSize) shadowSize;
@end
