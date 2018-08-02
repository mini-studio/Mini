//
//  MiniUIUmageView.m
//  LS
//
//  Created by wu quancheng on 12-7-12.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIImageView.h"

@implementation MiniUIImageView

- (void)dealloc
{
    if ( toucheAction )
    {
        Block_release( toucheAction );
        toucheAction = nil;
    }
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    if ( toucheAction )
    {
        toucheAction(self);
    }
    else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)setToucheAction:( void (^)() )block
{
    if ( toucheAction )
    {
        Block_release( toucheAction );
        toucheAction = nil;
    }
    
    if ( block )
    {
        self.userInteractionEnabled = YES;
        toucheAction = Block_copy( block );
    }
}
@end
