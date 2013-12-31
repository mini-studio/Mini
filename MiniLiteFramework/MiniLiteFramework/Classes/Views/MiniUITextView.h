//
//  MiniUITextView.h
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUITextView : UITextView
{
    NSString *placeholder;
}

@property (nonatomic,retain)NSString *placeholder;
- (void)textChanged:(NSNotification *)notification;

@end
