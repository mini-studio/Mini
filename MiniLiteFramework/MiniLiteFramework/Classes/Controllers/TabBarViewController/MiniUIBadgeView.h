/*
 CustomBadge.h
 
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


#import <UIKit/UIKit.h>





@interface MiniUIBadgeView : UIView
{
    UIImage *bgImage;
    UIImage *badgeImage;
    UIImage *bgImagePressed;
    NSString *badgeText;
    UIColor *badgeColor;
    UIColor *badgeColorPressed;
    UIFont * font;
    BOOL      highlighted;
    NSInteger badge;
    CGFloat   _leftGap;
    CGFloat   _topGap;
}
@property(nonatomic,retain)UIImage *bgImage;
@property(nonatomic,retain)UIImage *bgImagePressed;
@property(nonatomic,retain)UIImage *badgeImage;
@property(nonatomic,copy) NSString *badgeText;
@property(nonatomic,retain)UIColor *badgeColor;
@property(nonatomic,retain)UIColor *badgeColorPressed;
@property(nonatomic,retain)UIFont *font;
@property(nonatomic)        BOOL    highlighted;
@property(nonatomic)       NSInteger badge;
@property(nonatomic)       CGFloat   leftGap;
@property(nonatomic)       CGFloat   topGap;

@end
