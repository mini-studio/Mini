//
//  UINavigationBar+Mini.m
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#define UINavigationBarHeight 44

#import "UINavigationBar+Mini.h"
#define KBGIMAGEVIEWTAG 0xA000001
#define KTITLEVIEWTAG 0xA000002

#import "UIColor+Mini.h"

@implementation UINavigationBar(Mini)

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:backgroundImage forBarMetrics:0];
        return;
    }
    if ( self.subviews.count == 0 )
    {
        self.tintColor = [UIColor colorWithString:@"0072acFF"];
    }
    else
    {
        for ( UIView *view in self.subviews )
        {
            if ( view.frame.size.height == self.frame.size.height)
            {
                UIImageView *imageView = (UIImageView *)[view viewWithTag:KBGIMAGEVIEWTAG];
                if ( imageView == nil )
                {
                    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
                    imageView.tag = KBGIMAGEVIEWTAG;
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    [view addSubview:imageView];
                    [imageView release];
                }    
                imageView.image = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:0];            
            }
        }
    }   
}

- (void)setCenter:(CGPoint)center
{
    if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [super setCenter:center];
        return;
    }
    if ( self.tag == UINavigationBarTag )
    {
        self.height = UINavigationBarHeight;
        if ( center.y > 0 )
        {
            if ( (center.y == 20 - (44-self.height)/2) && ( [UIApplication sharedApplication].statusBarFrame.size.height == 40 ))
            {
                center.y = 20;
            }
            else
            {
                center.y = [UIApplication sharedApplication].statusBarFrame.size.height + self.height/2;
            }
        }
        else if ( center.y < 0 )
        {
            center.y = 0;
        }
    }
    [super setCenter:center];
}


@end
