//
//  UIColor+Mini.m
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "UIColor+Mini.h"

@implementation UIColor (Mini)
+(UIColor*)colorWithRGBA:(NSUInteger)color
{
	return [UIColor colorWithRed:((color>>24)&0xFF)/255.0
						   green:((color>>16)&0xFF)/255.0
							blue:((color>>8)&0xFF)/255.0
						   alpha:((color)&0xFF)/255.0];
}


+ (UIColor *)colorWithString:(NSString *)string
{
    NSInteger c = 0;
    sscanf([string UTF8String], "%x", &c);
    return [UIColor colorWithRGBA:c];
}
@end
