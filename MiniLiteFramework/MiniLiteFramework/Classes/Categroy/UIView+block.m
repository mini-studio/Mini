//
// Created by Wuquancheng on 2018/7/24.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "UIView+block.h"


@implementation UIView (block)
+ (void)actionAfter:(double)timeInSecond action:(void(^)(void))block
{
    if (block != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (timeInSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^() {
            block();
        });
    }
}
@end
