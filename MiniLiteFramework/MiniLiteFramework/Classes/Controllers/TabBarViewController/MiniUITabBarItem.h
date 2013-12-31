//
//  MiniUITabBarItem.h
//  Youlu
//
//  Created by William on 11-4-26.
//  Copyright 2011年 Youlu . All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MiniUITabBarItem : UIButton
{
    NSInteger   badge;
    UIImage *normalIcon;
    UIImage *highLightIcon;
    NSString * title;
    BOOL isSelect;
}
@property (nonatomic)NSInteger badge;
@property (nonatomic,retain)NSDictionary *attri;
- (id)initWithImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage title:(NSString*)text;
- (void)setImage:(UIImage *)icon highLightIcon:(UIImage *)highLightIcon;
- (void)setBadgeText:(NSString *)badgeText;
- (void)setBadgeImage:(UIImage *)image;
- (CGPoint)badgeOrigin;

@end
