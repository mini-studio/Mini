//
//  NSString+size.m
//  scene
//
//  Created by Wuquancheng on 2018/3/19.
//  Copyright © 2018年 mini. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)
- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)size {
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [self  boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str font:(UIFont*)font  maxSize:(CGSize)size{
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}

- (BOOL)isAllNumbers {
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    if(str.length > 0) {
        return NO;
    }
    return YES;
}
@end
