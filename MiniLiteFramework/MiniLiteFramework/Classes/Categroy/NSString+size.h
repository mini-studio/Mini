//
//  NSString+size.h
//  scene
//
//  Created by Wuquancheng on 2018/3/19.
//  Copyright © 2018年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)
- (CGSize)sizeWithFont:(UIFont*)font maxSize:(CGSize)size;
+ (CGSize)sizeWithString:(NSString*)str font:(UIFont*)font maxSize:(CGSize)size;

- (BOOL)isAllNumbers;
@end
