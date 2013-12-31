/*
 **********************************************************************************************************************
 *  需要自定义对话框背景，请以类别方式重写- (UIImage *)backGroundImage; 
 *  使用样例：
 
 *  1、带输入框
 *   [MiniUIAlertControl showInputAlertWithTitle:NSLocalizedStringFromTable(@"contacts_group_manage_create", @"Contacts", nil) message:nil cancelButtonTitle:NSLocalizedString(@"global_cancel", nil) okButtonTitle:NSLocalizedStringFromTable(@"contacts_group_manage_create", @"Contacts", nil) showTextFiledBlock:^(MiniUIAlertControl *alertView, UITextField *showTextFiled)           {
 *          [alertView setMaxLength:KGroupNameMaxLength forTextField:showTextFiled];//设置最大长度
 *          showTextFiled.text = @"XXXXXXXXXXXX"; //设置默认
 
 *          } block:^(MiniUIAlertControl *alertView, NSInteger buttonIndex) {
 if ( buttonIndex != alertView.cancelButtonIndex )
 *              {
 *              }
 *   }];
 
 *   2. 普通用法
 *   [MiniUIAlertControl showAlertWithTitle:nil message:title block:^(MiniUIAlertControl * alertView, NSInteger index) {
 *   if (index != alertView.cancelButtonIndex)
 *   {
 *      [self removeContactAction];
 *   }
 *   }cancelButtonTitle:NSLocalizedString (@"global_cancel", nil) otherButtonTitles:NSLocalizedString (@"global_done", nil),nil];
 *   }];
 
 ***********************************************************************************************************************/

//
//  MiniUIAlertControl.h
//  Youlu
//
//  Created by wu quancheng on 12-3-14.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//
#define MAX_ALLOWED_VERSION 50000

#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION

typedef enum {
    UIAlertViewStyleDefault = 0,
    UIAlertViewStyleSecureTextInput,
    UIAlertViewStylePlainTextInput,
    UIAlertViewStyleLoginAndPasswordInput
} UIAlertViewStyle;

#endif


@interface MiniUIAlertView : UIAlertView
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
@property (nonatomic,assign) UIAlertViewStyle alertViewStyle;

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;
#endif
@property (nonatomic,retain) UIImage *backgroundImage;

- (void)show:(void (^)(MiniUIAlertView *alertView , NSInteger buttonIndex))block;

- (void)enableButtonWithTitle:(NSString *)title enable:(BOOL)enabel;

- (void)enableButtonWithIndex:(NSInteger)index enable:(BOOL)enabel;

- (void)setMaxLength:(NSInteger)length forTextField:(UITextField *)field;

+ (void)showAlertTipWithTitle:(NSString*) title message:(NSString*) message block:(void (^)(MiniUIAlertView *alertView ,NSInteger buttonIndex))block;

+ (void)showAlertWithTitle:(NSString*) title message:(NSString*) message block:(void (^)(MiniUIAlertView *alertView ,NSInteger buttonIndex))block cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:otherControlUserInfo, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithMessage:(NSString*)message;

+ (void)showAlertWithMessage:(NSString*)message title:(NSString *)title;

+ (BOOL)showModalAlertTipWithTitle:(NSString*)title message:(NSString *)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle;
@end


@interface MiniUIAlertView(input)
+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString*) message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle showTextFiledBlock:(void (^)(MiniUIAlertView *alertView ,UITextField * showTextFiled))showTextFiledBlock block:(void (^)(MiniUIAlertView *alertView ,NSInteger buttonIndex))block;

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString*) message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle style:(UIAlertViewStyle)style showTextFiledBlock:(void (^)(MiniUIAlertView *alertView ,UITextField * showTextFiled))showTextFiledBlock block:(void (^)(MiniUIAlertView *alertView ,NSInteger buttonIndex))block;
@end
