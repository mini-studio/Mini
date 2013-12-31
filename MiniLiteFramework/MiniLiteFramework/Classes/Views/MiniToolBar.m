//
//  LSToolBar.m
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniToolBar.h"

@implementation MiniToolBar



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
    }
    return self;
}


- (void)initial
{
    UIImage *image = [MiniUIImage imageNamed:@"toolbar_bg"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[MiniUIImage imageNamed:@"toolbar_bg"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    [imageView release];
}

- (void)setItems:(NSArray *)buttons
{
    if ( buttons.count == 0 )
    {
        return;
    }
    [self removeAllSubviews];
    [self initial];
    UIImage *image = [MiniUIImage imageNamed:@"tool_bar_split"];
    NSInteger width = self.width/buttons.count;
    for ( NSInteger index = 0; index < buttons.count; index++ )
    {
        MiniUIButton *button = [buttons objectAtIndex:index];
        CGFloat top = ceilf((self.height - button.height)/2);
        button.frame = CGRectMake(index *width + (width - button.width)/2, top , button.width, button.height);
       
        [self addSubview:button];
        if ( index > 0 )
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(index *width - imageView.width/2, 0, imageView.width, self.height);
            [self addSubview:imageView];
            [imageView release];
        }
    }
}

@end
