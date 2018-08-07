//
// Created by Wuquancheng on 2018/7/24.
// Copyright (c) 2018 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (block)
+ (void)actionAfter:(double)timeInSecond action:(void(^)(void))block;
@end
