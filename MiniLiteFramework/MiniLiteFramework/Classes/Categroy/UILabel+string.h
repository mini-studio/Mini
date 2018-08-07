//
// Created by Wuquancheng on 2018/7/19.
// Copyright (c) 2018 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (string)
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

+ (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(NSString *)textColor;

+ (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(NSString *)textColor boldFont:(BOOL)boldFont;
@end