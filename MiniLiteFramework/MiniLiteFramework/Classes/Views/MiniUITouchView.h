//
//  MiniUITouchView.h
//  LS
//
//  Created by wu quancheng on 12-7-15.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUITouchView : UIView
{
    void (^touchesBeganBlock)();
}

- (void)setTouchesBeganBlock:( void (^)() )block;
@end
