/*
 CustomBadge.m
 
 ** *Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString the create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 ** *License & Copyright ***
 Created by Sascha Marc Paulus www.spaulus.com on 08/2010. Version 1.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class. 
 If you modify it: Please send me your modified version of the class.
 A commercial distribution of this class is not allowed.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 */


#import "MiniUIBadgeView.h"
@implementation MiniUIBadgeView
@synthesize bgImage;
@synthesize bgImagePressed;
@synthesize badgeText;
@synthesize badgeColor;
@synthesize badgeColorPressed;
@synthesize font;
@synthesize highlighted;
@synthesize badge;
@synthesize badgeImage;
@synthesize leftGap = _leftGap;
@synthesize topGap = _topGap;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.badgeColor = [UIColor whiteColor];
        self.badgeColorPressed = [UIColor grayColor];       
        self.backgroundColor = [UIColor clearColor];
        UIImage *badgeBgImage = [MiniUIImage imageNamed:@"badge_bg"];
        badgeBgImage = [badgeBgImage stretchableImageWithLeftCapWidth:badgeBgImage.size.width/2 topCapHeight:badgeBgImage.size.height];
        self.bgImage = badgeBgImage;
        self.font = [UIFont systemFontOfSize:14];
        self.userInteractionEnabled = NO;
    }
    return  self;
}

-(void)drawRect:(CGRect)rect
{
    if ( self.badgeImage )
    {
        [self.badgeImage drawInRect:rect];
    }
    else
    {
        if ([self.badgeText length]>0) 
        {
            CGSize textSize = [self.badgeText sizeWithFont:font];
            if (self.highlighted)
            {
                [self.bgImagePressed drawInRect:rect];
                [self.badgeColorPressed set];
            }
            else
            {
                [self.bgImage drawInRect:rect];
                [self.badgeColor set];
            }
            
            [[UIColor whiteColor] set];
            [self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2) + self.leftGap, floorf(rect.size.height/2-textSize.height/2)-1 + self.topGap) withFont:font];
        }
    }
}

- (void)setBadgeImage:(UIImage *)theBadgeImage
{
    [theBadgeImage retain];
    [badgeImage release];
    badgeImage = theBadgeImage;
    self.width = badgeImage.size.width;
    self.height = badgeImage.size.height;
    [self setNeedsDisplay];
}

-(void)setBadgeText:(NSString *)text
{
    [badgeText release];
    badgeText = nil;
    badgeText = text;
    [badgeText retain];
//    if ( [text isNumeric])
//    {
//        self.font = [UIFont systemFontOfSize:KSmallFontHeight]; 
//    }
//    else
//    {
//        self.font = [UIFont systemFontOfSize:KSmallFontHeight];
//    }
//
    CGSize size = [text sizeWithFont:self.font];
    self.width = size.width + KGap;
    if (self.width > self.bgImage.size.width)
    {
        self.width += 4; 
    }
    self.height = self.bgImage.size.height;
    if (self.height > self.width)
    {
        self.width = self.height;
    }
    [self setNeedsDisplay];
}

- (void)setBadge:(NSInteger)b
{
    badge = b;
    NSString *text = @"";
    if (badge > 99)
    {
        text = [NSString stringWithFormat:@"%d+", 99];
    }
    else if(badge > 0)
    {
        text = [NSString stringWithFormat:@"%d", badge];
    }
    self.badgeText = text;
}

-(void)dealloc
{
    [badgeImage release];
    [badgeText release];
    [bgImage release];
    [badgeColor release];
    [bgImagePressed release];
    [badgeColorPressed release];
    [font release];

    [super dealloc];
}
@end
