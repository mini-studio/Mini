//
//  MiniUIToolBar.m
//  LS
//
//  Created by wu quancheng on 12-7-9.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIToolBar.h"

@implementation MiniUIToolBar

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
    if ( imageView == nil )
    {
        imageView = [[UIImageView alloc] initWithImage:backgroundImage];
        imageView.tag = 1000;
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        [imageView release];

    }
    imageView.image = backgroundImage;
}

//- (void)drawRect:(CGRect)rect
//{
//    
//}
@end
