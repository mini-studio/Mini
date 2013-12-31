//
//  MiniUIEmojiView.h
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniPageControl.h"
@interface MiniUIEmojiView : UIView<UIScrollViewDelegate>
{
    MiniPageControl *pageControl;
    void (^clickEmojiBlock)(NSString *code);
}

- (void)setClickEmojiBlock:(void (^)(NSString *code))block;

@end
