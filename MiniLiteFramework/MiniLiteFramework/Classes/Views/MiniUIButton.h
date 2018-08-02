//
//  MiniUIButton.h
//  LS
//
//  Created by wu quancheng on 12-6-11.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    UIControlEventTouchInsideRepeat = 1 <<  9 ,
    UIControlEventTouchUpInsideRepeat = 1 << 25
};

@interface MiniUIButton : UIButton
{
    id _userInfo;
	NSTimeInterval _longPressTimeInterval;
}
@property (nonatomic,retain) id userInfo;
@property (nonatomic, assign) NSTimeInterval longPressTimeInterval;

+ (id)buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage title:(NSString *)title;

+ (id)buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage resizableImageWithCapInsets:(UIEdgeInsets)insets title:(NSString *)title;

+ (id)naviBackButtonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage title:(NSString *)title;

+ (id)buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

- (void)setTouchUpHandler:(void (^)(MiniUIButton *button))handler;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- (UIColor *)backgroundColorForState:(UIControlState)state;

- (void)setFontSize:(CGFloat)fontSize;

- (void)setBottomLine:(UIColor*)color;

@end
