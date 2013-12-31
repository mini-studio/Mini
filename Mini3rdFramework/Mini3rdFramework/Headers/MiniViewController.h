//
//  MiniViewController.h
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface MiniViewController : UIViewController
{
      MBProgressHUD       *_hud;
}
@property (nonatomic,getter = isVisible) BOOL visible;



- (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay;

- (void)showMessageInfo:(NSString *)info inView:(UIView *)inView delay:(NSInteger)delay;

- (void)showWating:(NSString *)message;

- (void)showWating:(NSString *)message inView:(UIView *)inView;

- (void)dismissWating;

- (void)dismissWating:(BOOL)animated;


- (void)setNaviBackButton;

- (void)setNaviBackButtonWithImageName:(NSString *)imageName;

- (void)setNaviBackButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setNaviLeftButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setNaviRightButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)back;
- (void)back:(BOOL)animation;

- (UITableViewCell *)loadCellFromNib:(NSString *)nib clazz:(Class)clazz;

+ (void)showImageInWindow:(UIImage *)image oriFrame:(CGRect)frame;

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller;

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
@end

@interface MiniViewController (http)
- (void)requestStart:(NSDictionary *)properties;
- (void)requestEnd:(NSDictionary *)properties;
@end
