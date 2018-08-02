//
//  MiniUIUmageView.h
//  LS
//
//  Created by wu quancheng on 12-7-12.
//  Copyright (c) 2012年 Mini. All rights reserved.
//



@interface MiniUIImageView : UIImageView
{
    void (^toucheAction)();
}

- (void)setToucheAction:( void (^)() )block;
@end
