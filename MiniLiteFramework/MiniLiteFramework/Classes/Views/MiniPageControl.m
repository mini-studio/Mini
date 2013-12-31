//
//  YLPageControl.m
//  Youlu
//
//  Created by lipeiqiang on 11-3-14.
//  Copyright 2011 Youlu . All rights reserved.
//

#import "MiniPageControl.h"
#import "UIColor+Mini.h"

@implementation MiniPageControl
@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize pageColor = _pageColor;
@synthesize currentPageColor = _currentPageColor;

-(id)initWithFrame:(CGRect)frame
{
    frame.size.height = KPageControlHeight;
	if (self = [super initWithFrame:frame])
	{
        self.backgroundColor = [UIColor clearColor];
        self.hidesForSinglePage = YES;
        self.currentPageColor = [UIColor colorWithRGBA:0x707070ff];
        self.pageColor = [UIColor colorWithRGBA:0xccccccff];
	}
	return self;
}

- (void)dealloc
{
    [_currentPageColor release];
    [_pageColor release];
    [super dealloc];
}

- (void) drawRect:(CGRect) rect 
{
    UIImage *grey, *image, *red;
	
    if ( self.hidesForSinglePage && self.numberOfPages == 1 ) return;
    red = [[MiniUIImage imageNamed: @"Mini/page_dot_mask"] imageWithColor:self.currentPageColor];
    grey = [[MiniUIImage imageNamed: @"Mini/page_dot_mask"] imageWithColor:self.pageColor];
	
	CGRect dotRect ;
    dotRect.size = red.size;
    NSInteger allWidth = self.numberOfPages  *red.size.width + ( self.numberOfPages - 1 )  *KGap;
    dotRect.origin.x = floorf( ( rect.size.width - allWidth ) / 2.0 );
    dotRect.origin.y = floorf( ( rect.size.height - red.size.height ) / 2.0 );
	
    for (int i = 0; i < self.numberOfPages; ++i ) 
    {
        image = i == self.currentPage ? red : grey;
        [image drawInRect: dotRect];
        dotRect.origin.x += red.size.width + KGap;
    }
}

- (void) setCurrentPage:(NSInteger) page
{
	_currentPage = page;
    [self setNeedsDisplay];
}


- (void) setNumberOfPages:(NSInteger) pages
{
	_numberOfPages = pages;
    [self setNeedsDisplay];
}
@end
