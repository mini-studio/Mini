//
//  MiniSysUtil.h
//  LS
//
//  Created by wu quancheng on 12-8-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "MiniSingletonFactory.h"

@interface MiniSysUtil : NSObject<MFMailComposeViewControllerDelegate>
{

}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniSysUtil)

+ (void)call:(NSString *)callnumber;

+ (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay;

- (void)sendEmail:(NSString *)body subject:(NSString *)subject ToRecipients:(NSArray*)ToRecipients CcRecipients:(NSArray*)CcRecipients viewController:(UIViewController*)controller block:(void (^)(MFMailComposeViewController *controller, MFMailComposeResult result))block;

- (void)sendSMS:(NSArray*)receivers title:(NSString *)title body:(NSString*)body viewController:(UIViewController*)viewController block:(void (^)(MFMessageComposeViewController *controller,MessageComposeResult result))block;

- (BOOL)isExpiredWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (void)copyToBoard:(NSString *)content;

@end
