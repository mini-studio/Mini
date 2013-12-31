//
//  MiniUIEmojiView.m
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIEmojiView.h"

@implementation MiniUIEmojiView

- (void)creataEmojiView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator = NO;
    int size = 50;
    int hgap = (self.width - 6*size )/7;
    NSInteger oindex = 0;
    for (  ; oindex < 4; oindex ++ )
    {
        NSInteger start = oindex * 24;
        NSInteger end = start + 24;
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.top = 5;
        view.left = oindex * self.width;
        [scroll addSubview:view];
        int row = 0;
        int col = 0;
        for ( NSInteger index = start; index < end; index++ )
        {
            NSString *code = [NSString stringWithFormat:@"00%02d",index+1];
            NSString *imagename = [NSString stringWithFormat:@"Emoji/face_%@",code];
            UIImage *image = [MiniUIImage imageNamed:imagename];
            if ( image == nil )
            {
                break;
            }
            MiniUIButton *button = [MiniUIButton buttonWithImage:image highlightedImage:nil];
            button.userInfo = code;
            button.adjustsImageWhenHighlighted = NO;
            button.showsTouchWhenHighlighted = YES;
            if ( index % 6 == 0 && index > start )
            {
                row ++;
                col = 0;
            }
            button.frame = CGRectMake( col*size + (col + 1 )*hgap, row*size + (row+1)*hgap, size, size);
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            col++;
            [view addSubview:button];
            [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        }
        scroll.contentSize = CGSizeMake( self.width *(oindex+1) ,self.height );
    }
    scroll.pagingEnabled = YES;
    [self addSubview:scroll];
    [scroll release];
    pageControl = [[MiniPageControl alloc] initWithFrame:CGRectMake(0, 10, self.width - 20, 6)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = oindex ;
    [self addSubview:pageControl];    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        clickEmojiBlock = nil;
        [self creataEmojiView];
        self.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    }
    return self;
}

- (void)dealloc
{
    [pageControl release];
    [super dealloc];
}

- (void)setClickEmojiBlock:(void (^)(NSString *code))block
{
    Block_release(clickEmojiBlock);
    clickEmojiBlock = nil;
    if ( block )
    {
          clickEmojiBlock = Block_copy( block );
    }  
}

- (void)buttonTap:(MiniUIButton *)button
{
    if ( clickEmojiBlock )
    {
        clickEmojiBlock ( button.userInfo );
    }
}

@end
