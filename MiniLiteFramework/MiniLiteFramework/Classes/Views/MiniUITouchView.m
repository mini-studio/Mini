//
//  MiniUITouchView.m
//  LS
//
//  Created by wu quancheng on 12-7-15.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUITouchView.h"

@implementation MiniUITouchView

- (void)dealloc
{
    if ( touchesBeganBlock )
    {
        Block_release( touchesBeganBlock );
        touchesBeganBlock = nil;
    }
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ( touchesBeganBlock )
    {
        touchesBeganBlock(self);
    }
}

- (void)setTouchesBeganBlock:( void (^)() )block
{
    if ( touchesBeganBlock )
    {
        Block_release( touchesBeganBlock );
        touchesBeganBlock = nil;
    }
    
    if ( block )
    {
        touchesBeganBlock = Block_copy( block );
    }
}

@end
