//
//  MiniViewController.h
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniUINaviTitleView.h"
#import "MiniViewControllerDelegate.h"


@class MBProgressHUD;
@class MiniUITabBar;


@interface MiniViewController : UIViewController
{
      MBProgressHUD       *_hud;
}
@property (nonatomic,getter = isVisible) BOOL visible;
@property (nonatomic,retain)MiniUINaviTitleView *naviTitleView;
@property (nonatomic,retain)MiniUITabBar *miniTabBar;
@property (nonatomic,retain)UIView  *contentView;
@property (nonatomic, assign, readonly)UIView * statusBarView;
@property (nonatomic, retain) NSObject<MiniViewControllerDelegate> *controllerDelegate;


- (void)setNaviTitleViewShow:(BOOL)shown;

- (void)setNaviTitle:(NSString*)title;

- (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay;

- (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay block:(void (^)(void))block;

- (void)showMessageInfo:(NSString *)info;

- (void)showMessageInfo:(NSString *)info inView:(UIView *)inView delay:(NSInteger)delay;

- (void)showWaiting:(NSString *)message;

- (void)showWaiting;

- (void)showWaiting:(NSString *)message inView:(UIView *)inView;

- (void)showWaiting:(NSString *)message userInteractionEnabled:(BOOL)userInteractionEnabled;

- (void)showWaiting:(NSString *)message inView:(UIView *)inView userInteractionEnabled:(BOOL)userInteractionEnabled;

- (void)dismissWating;

- (void)dismissWating:(BOOL)animated;


- (void)setNaviBackButton;

- (void)setNaviBackButtonWithImageName:(NSString *)imageName;

- (void)setNaviBackButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setNaviLeftButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setNaviRightButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setNaviLeftButton:(MiniUIButton*)button;
- (void)setNaviRightButton:(MiniUIButton*)button;

- (void)back;
- (void)back:(BOOL)animation;

- (UITableViewCell *)loadCellFromNib:(NSString *)nib clazz:(Class)clazz;

+ (void)showImageInWindow:(UIImage *)image oriFrame:(CGRect)frame;

- (void)toast:(NSString*)message;

- (BOOL)isNavigationControllerTopViewController;


- (void)registerPopGestureRecognizer ;
- (void)enablePopGestureRecognizer;
- (void)disablePopGestureRecognizer;

@end

@interface MiniViewController (http)
- (void)requestStart:(NSDictionary *)properties;
- (void)requestEnd:(NSDictionary *)properties;
@end

@interface MiniViewController (child)
- (void)selectedAsChild;
- (void)deselectedAsChild;
@end

@interface MiniViewController(tabBar)
- (void)addTabBarView:(MiniUITabBar*)tabBar;
- (void)didTabBarItemSelected;
- (void)didTabBarItemDeselected;
@end
