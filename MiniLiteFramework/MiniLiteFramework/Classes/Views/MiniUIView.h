//
//  MiniUIView.h
//  LS
//
//  Created by wu quancheng on 12-7-15.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MiniUIViewBorder) {
    MiniUIViewBorderNone   = 0,
    MiniUIViewBorderLeft   = 1 << 0,
    MiniUIViewBorderRight  = 1 << 1,
    MiniUIViewBorderTop    = 1 << 2,
    MiniUIViewBorderBottom = 1 << 3,
};

@interface MiniUIView : UIView
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) MiniUIViewBorder border;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
- (void)setToucheAction:( void (^)(MiniUIView* view) )block;
- (void)setToucheUpInsideAction:( void (^)(MiniUIView* view) )block;
@end
