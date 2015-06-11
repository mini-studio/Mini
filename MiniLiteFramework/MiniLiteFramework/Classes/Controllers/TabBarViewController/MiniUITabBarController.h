//
//  MiniUITabBarController.h
//  MiniFramework
//
//  Created by wu quancheng on 11-12-21.
//  Copyright (c) 2011年 Mini-Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniUITabBar.h"

@interface MiniTabBarItem : NSObject
{
@private
    NSString *_controllerName;
    UIImage *_image;
    UIImage *_highlightedImage;
    NSString *_title;
    UIFont *_titleFont;
    Class  _clazz;
}

@property (nonatomic,retain)NSString *controllerName;
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,retain)UIImage *highlightedImage;
@property (nonatomic,retain)NSString *title;
@property (nonatomic,retain)UIFont *titleFont;
@property (nonatomic,retain)Class clazz;
- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage title:(NSString*)title;
- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)image;
- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image title:(NSString*)title;
- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage title:(NSString*)title clazz:(Class)clazz;

@end

/*
 *===========================================================
 
 ============================================================
 */
@protocol MiniUITabBarControllerDelegate 
@required
- (BOOL)willSelectedAtIndex:(NSInteger)index;
- (void)willDeselectedAtIndex:(NSInteger)index;
- (void)didSelectedAtIndex:(NSInteger)index;
- (void)didDeselectedAtIndex:(NSInteger)index;
@end

/*
 *===========================================================
 
 ============================================================
 */
@interface MiniUITabBarController : UITabBarController <MiniUITabBarDelegate>
{
    NSInteger     currentSelectedIndex;
    MiniUITabBar  *tabBarView;
    UIEdgeInsets  tabBarViewEdgeInsets;
    
    id<MiniUITabBarControllerDelegate> controllerDelegate;
}

@property (nonatomic,retain) MiniUITabBar *tabBarView;
@property (nonatomic)NSInteger currentSelectedIndex;
@property (nonatomic) UIEdgeInsets  tabBarViewEdgeInsets;
@property (nonatomic,assign) id<MiniUITabBarControllerDelegate> controllerDelegate;

- (NSInteger)heightForTabBarView;

- (id)initWithItems:(NSArray *)array;

- (void)setItems:(NSArray *)array;

- (NSInteger)tabBarVisualHeight;
- (NSInteger)tabBarHeight;

- (void)resetItem:(MiniTabBarItem *)item atIndex:(NSUInteger)index;

- (void)setBadgeText:(NSString *)bageString atIndex:(NSInteger)index;

- (void)setBadge:(NSInteger)badge atIndex:(NSInteger)index;

- (void)setBadgeImage:(UIImage *)badgeImage atIndex:(NSInteger)index;

- (void)setIcon:(UIImage *)icon highLightIcon:(UIImage *)highLightIcon atIndex:(NSUInteger)index;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

- (UIImage *)navigationBarBackGroundForIndex:(NSInteger)index;
@end

/*
 *===========================================================
 
 ============================================================
 */
@interface MiniTabBarController : UIViewController<MiniUITabBarDelegate>
{
    NSInteger     currentSelectedIndex;
    MiniUITabBar  *tabBarView;
    UIEdgeInsets  tabBarViewEdgeInsets;
    
    id<MiniUITabBarControllerDelegate> controllerDelegate;
}

@property (nonatomic,retain) MiniUITabBar *tabBarView;
@property (nonatomic)NSInteger currentSelectedIndex;
@property (nonatomic) UIEdgeInsets  tabBarViewEdgeInsets;
@property (nonatomic,assign,readonly) UIViewController *selectedViewController;
@property (nonatomic,assign) id<MiniUITabBarControllerDelegate> controllerDelegate;

- (NSInteger)heightForTabBarView;

- (id)initWithItems:(NSArray *)array;

- (void)setItems:(NSArray *)array;

- (NSInteger)tabBarVisualHeight;
- (NSInteger)tabBarHeight;

- (void)resetItem:(MiniTabBarItem *)item atIndex:(NSUInteger)index;

- (void)setBadgeText:(NSString *)bageString atIndex:(NSInteger)index;

- (void)setBadge:(NSInteger)badge atIndex:(NSInteger)index;

- (void)setBadgeImage:(UIImage *)badgeImage atIndex:(NSInteger)index;

- (void)setIcon:(UIImage *)icon highLightIcon:(UIImage *)highLightIcon atIndex:(NSUInteger)index;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

- (UIImage *)navigationBarBackGroundForIndex:(NSInteger)index;
@end
