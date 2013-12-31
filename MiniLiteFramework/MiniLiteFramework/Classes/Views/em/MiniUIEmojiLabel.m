//
//  MiniUIEmojiLabel.m
//  LS
//
//  Created by wu quancheng on 12-7-9.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIEmojiLabel.h"
#import "MiniEmojiCodeUtil.h"

@implementation MiniUIEmojiLabel
- (void)drawTextInRect:(CGRect)rect
{
    NSString *text = self.text;
    NSRange range = {0,1};
    UIFont *font = self.font;
    int x = rect.origin.x, y = rect.origin.y;
    if ( self.highlighted )
    {
        [self.highlightedTextColor set];
    }
    else
    {
        [self.textColor set];
    }
    for ( NSInteger index = 0; index < text.length; index ++ )
    {
        range.location = index;
        NSString *ch = [text substringWithRange:range];
        CGSize size = [ch sizeWithFont:font];
        UIImage *image = nil;
        if ([ch isEqualToString:@"["]) 
        {
            //[#0045]
            NSString *emoji = [text substringWithRange:NSMakeRange(range.location, 7)];
            image = [MiniEmojiCodeUtil emojiWithCode:emoji];
            if ( image != nil )
            {
                size.width = font.lineHeight;
                index += 6;
            }
        }
        
        int _x = x + size.width;
        if ( _x > CGRectGetMaxX(rect))
        {
            x = rect.origin.x;
            y += font.lineHeight;
        }
        if ( image )
        {
            [image drawInRect:CGRectMake(x, y, size.width, size.height)];
        }
        else
        {
            [ch drawInRect:CGRectMake(x, y, size.width, size.height) withFont:font];
        }
        x += size.width;
    }
}

- (void)sizeToFit
{
    NSString *text = self.text;
    NSRange range = {0,1};
    UIFont *font = self.font;
    int x = 0, y = 0;
    int maxw = 0;
    for ( NSInteger index = 0; index < text.length; index ++ )
    {
        range.location = index;
        NSString *ch = [text substringWithRange:range];
        CGSize size = [ch sizeWithFont:font];
        if ([ch isEqualToString:@"["]) 
        {
            //[#0045]
            NSString *emoji = [text substringWithRange:NSMakeRange(range.location, 7)];
            if ( [MiniEmojiCodeUtil isEmojiCode:emoji] )
            {
                size.width = font.lineHeight;
                index += 6;
            }
        }
        
        int _x = x + size.width;
        if ( _x > self.frame.size.width)
        {
            x = 0;
            y += font.lineHeight;
        }
        x += size.width;
        if ( x > maxw )
        {
            maxw = x;
        }
    }
    CGRect frame = self.frame;
    frame.size.width = maxw;
    frame.size.height = y + font.lineHeight ;    
    self.frame = frame;
    
}
@end
