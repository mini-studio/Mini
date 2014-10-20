//
//  MiniUITabBarItem.m
//  Mini
//
//  Created by William on 11-4-26.
//  Copyright 2011年 Mini . All rights reserved.
//

#import "MiniUITabBarItem.h"
#import "MiniUIBadgeView.h"
#import "UIImage+Mini.h"
#define KTabTitleFontHeight 14
#define KTabBadgeTag 0xA00000A

@interface MiniUITabBarItem()
{
    UIImage *selectImage;
    UIFont *_titleFont;
}
@property (nonatomic,retain)UIFont *titleFont;
@end

@implementation MiniUITabBarItem
@synthesize badge;
@synthesize titleFont = _titleFont;
- (id)initWithImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage title:(NSString*)text
{
    if ((self = [super init]))
    {
        self.badge = 0;
        normalIcon = [normalImage retain];        
        if (highlightedImage != nil )
        {
            highLightIcon = [highlightedImage retain];
        }
        title = [text copy];
        self.adjustsImageWhenHighlighted = NO;
        self.frame = CGRectMake(0, 0, normalIcon.size.width < 40 ? 40 : normalIcon.size.width, normalIcon.size.height);
        selectImage = [[MiniUIImage imageNamed:@"tab_selected_bg"] retain];
    }
    return self;
}

- (void)setImage:(UIImage *)theIcon highLightIcon:(UIImage *)theHighLightIcon
{
    [theIcon retain];
    [theHighLightIcon retain];
    [normalIcon release];
    normalIcon = theIcon;
    [highLightIcon release];
    highLightIcon = theHighLightIcon;
    if ( highLightIcon == nil )
    {
        highLightIcon = [normalIcon retain];
    }
}

- (void)dealloc
{
    [normalIcon release];
    [highLightIcon release];
    [title release];
    [_titleFont release];
    [selectImage release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat titleFontHeight = KTabTitleFontHeight;
    if ( self.attri != nil )
    {
        NSString *v = [self.attri valueForKey:@"titleFontHeight"];
        if (  v!= nil)
        {
            titleFontHeight = [v floatValue];
        }
    }
    UIFont *font = self.titleFont ? self.titleFont : [UIFont systemFontOfSize:titleFontHeight];
    NSInteger titileTop = 0;
    if (title.length > 0)
    {
        UIColor *color = [self.attri valueForKey:self.selected?@"highLightTitleColor":@"titleColor"];
        if ( color == nil )
        {
            color = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        }
        [color set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat bottom = [[self.attri valueForKey:@"bottomSpace"] floatValue];
        titileTop = self.height - font.lineHeight-bottom;
        [title drawInRect:CGRectMake(0, titileTop, rect.size.width, font.lineHeight) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
        CGContextSetShadow(context, CGSizeMake(0, 0), 0.0);        
    }
    NSString *iconHeight = [self.attri valueForKey:@"iconHeight"];
    NSInteger h = titileTop - 4;
    if ( iconHeight != nil ) {
        h = [iconHeight integerValue];
    }
    CGFloat top = 4;
    NSString *iconTop = [self.attri valueForKey:@"iconTop"];
    if (iconTop!=nil) {
        top = [iconTop floatValue];
    }
    CGRect imageRect = [self imageRect:CGRectMake((self.width-h)/2, top, h,h )];
    if (self.selected)
    {
        if ( selectImage != nil )
        {
            UIImage *_selectImage = [selectImage imageUseMask:highLightIcon];
            [_selectImage drawInRect:imageRect];
        } 
        else
        {
            if ( highLightIcon != nil )
            {
                [highLightIcon drawInRect:imageRect];
            }
            else
            {
                [normalIcon drawInRect:imageRect];
            }
        }
    }
    else
    {
         [normalIcon drawInRect:imageRect];
    }
}

- (CGRect)imageRect:(CGRect)rect
{
    return rect;
}

- (CGPoint)badgeOrigin
{
    return CGPointMake(3*KGap, KGap);
}

- (void)setBadgeText:(NSString *)badgeText
{
    MiniUIBadgeView *badgeView = (MiniUIBadgeView*)[self viewWithTag:KTabBadgeTag];
    if (badgeText.length > 0 )
    {
        if (!badgeView)
        {
            CGPoint origin = [self badgeOrigin];
            badgeView = [[[MiniUIBadgeView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)] autorelease];
            badgeView.tag = KTabBadgeTag;
            [self addSubview:badgeView];
        }
        badgeView.badgeText = badgeText;
    }
    else
    {
        [badgeView removeFromSuperview];
    }

}

- (void)setBadgeImage:(UIImage *)image
{
    MiniUIBadgeView *badgeView = (MiniUIBadgeView*)[self viewWithTag:KTabBadgeTag];
    if ( image != nil )
    {
        if (!badgeView)
        {
            CGPoint origin = [self badgeOrigin];
            badgeView = [[[MiniUIBadgeView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)] autorelease];
            badgeView.tag = KTabBadgeTag;
            [self addSubview:badgeView];
        }
        badgeView.badgeImage = image;
    }
    else
    {
        [badgeView removeFromSuperview];
    }
}

- (void)setBadge:(NSInteger)aBadge
{
    badge = aBadge; 
    MiniUIBadgeView *badgeView = (MiniUIBadgeView*)[self viewWithTag:KTabBadgeTag];
    if (badge>0)
    {
        if (!badgeView)
        {
            CGPoint origin = [self badgeOrigin];
            badgeView = [[[MiniUIBadgeView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)] autorelease];
            badgeView.tag = KTabBadgeTag;
            [self addSubview:badgeView];
        }
        badgeView.badge = badge;
    }
    else
    {
        [badgeView removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
