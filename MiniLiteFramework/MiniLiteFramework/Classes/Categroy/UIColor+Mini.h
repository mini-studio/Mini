//
//  UIColor+Mini.h
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Mini)
+(UIColor*)colorWithRGB:(NSUInteger)color;
+(UIColor*)colorWithRGBA:(NSUInteger)color;
+(UIColor*)colorWithString:(NSString *)string;
+(UIColor*)colorWithIntRed:(int)red green:(int)green blue:(int)blue;
+(UIColor*)colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(float)alpha;
@end
