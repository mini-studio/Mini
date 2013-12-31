//
//  MiniSysUtil.m
//  LS
//
//  Created by wu quancheng on 12-8-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniSysUtil.h"
#import "SVProgressHUD.h"

@interface MiniSysUtil()<MFMessageComposeViewControllerDelegate>
{
    void (^EMailSendBlock)(MFMailComposeViewController *controller, MFMailComposeResult result);
    void (^MessageComposeBlock)(MFMessageComposeViewController *controller, MessageComposeResult result);
}
@end

@implementation MiniSysUtil

SYNTHESIZE_MINI_SINGLETON_FOR_CLASS ( MiniSysUtil )


+ (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.customView = [[UIView alloc] initWithFrame:CGRectZero];
    hud.customView.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = info;
    if ( delay )
    {
        [hud hide:YES afterDelay:delay];
    }    
}


+ (void)call:(NSString *)callnumber
{
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    if ([device isEqualToString:@"iPho"]){
        if ([callnumber length] != 0) {
            NSString *btn_url   = [NSString stringWithFormat:@"telprompt://%@",callnumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:btn_url]];            
        }
    }else{
        [self showMessageInfo:@"该设备不支持打电话功能" delay:2];
    }
}

- (void)sendEmail:(NSString *)body subject:(NSString *)subject ToRecipients:(NSArray*)ToRecipients CcRecipients:(NSArray*)CcRecipients viewController:(UIViewController*)controller  block:(void (^)(MFMailComposeViewController *controller, MFMailComposeResult result))block
{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    if(mailCompose)
    {
        if ( EMailSendBlock )
        {
            Block_release(EMailSendBlock);
            EMailSendBlock = nil;
        }
        if ( block)
        {
            EMailSendBlock = Block_copy( block );
        }
        NSString *emailBody = body;
        
        mailCompose.mailComposeDelegate = self;
        [mailCompose setToRecipients:ToRecipients];
        [mailCompose setCcRecipients:CcRecipients];        
        [mailCompose setMessageBody:emailBody isHTML:YES];
        [mailCompose setSubject:subject];
         //设置邮件附件{mimeType:文件格式|fileName:文件名}
        //        [mailCompose addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"1.png"];
        //设置邮件视图在当前视图上显示方式        
        [controller presentModalViewController:mailCompose animated:YES];
    }    
    [mailCompose release];
    

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    if ( EMailSendBlock )
    {
        EMailSendBlock ( controller, result );
        Block_release( EMailSendBlock );
        EMailSendBlock = nil;
    }
    else
    {
        [controller dismissModalViewControllerAnimated:YES];
        switch (result)
        {   
            case MFMailComposeResultCancelled:
            {        
                [MiniSysUtil showMessageInfo:@"已经取消邮件发送" delay:2];          
            }
            break;
            case MFMailComposeResultSent:
            {
                break;
            }
            default:
            { 
                [MiniSysUtil showMessageInfo:@"E-mail Not Sent" delay:2];
            }
            break;
        }
    }
}

- (void)sendSMS:(NSArray*)receivers title:(NSString *)title  body:(NSString*)body viewController:(UIViewController*)viewController block:(void (^)(MFMessageComposeViewController *controller,MessageComposeResult result))block
{

    if ( [MFMessageComposeViewController canSendText] )
    {
        if ( MessageComposeBlock )
        {
            Block_release(MessageComposeBlock);
            MessageComposeBlock = nil;
        }
        if ( block )
        {
            MessageComposeBlock = Block_copy( block );
        }
        MFMessageComposeViewController *picker = [[[MFMessageComposeViewController alloc] init] autorelease];
        picker.title = title;
        picker.recipients = receivers;
        picker.body = body;
        [viewController presentModalViewController:picker animated:YES];
        picker.messageComposeDelegate = self;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if ( MessageComposeBlock )
    {
        MessageComposeBlock( controller,result );
    }
    else
    {
        [controller dismissModalViewControllerAnimated:YES];
        switch ( result )
        {
            case MessageComposeResultCancelled:
                [MiniSysUtil showMessageInfo:@"短信已取消" delay:2];
                break;
            case  MessageComposeResultSent:
                [MiniSysUtil showMessageInfo:@"短信已发出" delay:2];
                break;
            case MessageComposeResultFailed:
                [MiniSysUtil showMessageInfo:@"短信发送失败" delay:2];
                break;
                
            default:
                break;
        }
    }
}

- (BOOL)isExperiedWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];        
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *experiedDate = [gregorian dateFromComponents:components];
    NSDate *now = [NSDate date];
    if ([now timeIntervalSinceDate:experiedDate] > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)copyToBoard:(NSString *)content
{
    if (content.length > 0)
    {
        UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
        [gpBoard setValue:content forPasteboardType:@"public.utf8-plain-text"];
    }
}


@end
