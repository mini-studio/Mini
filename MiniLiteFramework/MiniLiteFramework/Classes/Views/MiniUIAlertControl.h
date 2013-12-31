//
//  HaloUIAlertControl.h
//  TestArc
//
//  Created by Wuquancheng on 12-12-1.
//  Copyright (c) 2012年 youlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniUIAlertControl : UIAlertView

+ (MiniUIAlertControl *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle willShow:(void (^)(MiniUIAlertControl* alertView))willShow block:(void (^)( MiniUIAlertControl* control, NSInteger buttonIndex)) block;

+ (MiniUIAlertControl *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;



- (void)show:(void (^)( MiniUIAlertControl* control, NSInteger buttonIndex)) block;

- (MiniUIAlertControl *)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle  destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)setTitleColor:(UIColor *)color messageColor:(UIColor *)messageColor cancelButtonTitleColor:(UIColor *)cancelButtonTitleColor destructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor otherButtonTitleColor:(UIColor *)otherButtonTitleColor;

@end
