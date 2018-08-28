//
// Created by Wuquancheng on 2018/8/28.
// Copyright (c) 2018 Wuquancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MiniViewController;


@protocol MiniViewControllerDelegate
- (CGFloat)naviTitleViewHeight:(MiniViewController*)controller;
- (void)naviTileViewDidCreate:(MiniViewController*)controller;
@end