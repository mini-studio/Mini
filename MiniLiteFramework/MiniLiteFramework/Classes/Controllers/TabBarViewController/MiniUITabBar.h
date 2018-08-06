
#import "MiniUITabBarItem.h"

@class MiniUITabBar;

@protocol MiniUITabBarDelegate<NSObject>
@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
- (BOOL)willTouchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end


@interface MiniUITabBar : UIView
{
	id<MiniUITabBarDelegate>			delegate;
	UIImageView*						highLightImageView;
	UIImage*							bgImage;
	NSMutableArray*						tabItemsArray;
	NSInteger                           selectedTabIndex;
}

@property (nonatomic, retain)UIImage*						bgImage;
@property (nonatomic, retain)NSMutableArray*				tabItemsArray;
@property (nonatomic, assign)id<MiniUITabBarDelegate>	delegate;
@property (nonatomic)        NSInteger                     selectedTabIndex;
@property (nonatomic, assign) UIView *shadowView;
@property (nonatomic, assign) UIView *shadowViewLandscape;
@property (nonatomic, assign) BOOL enableAutoRotate;

- (id)initWithFrame:(CGRect)frame;
- (CGFloat)bottomHighlightImageXAtIndex:(NSUInteger)tabIndex;
- (void)setBadgeNumber:(NSInteger)number atIndex:(NSInteger)index;
- (void)setBadgeText:(NSString*)badgeText atIndex:(NSInteger)index;
- (void)setBadgeImage:(UIImage *)image atIndex:(NSInteger)index;
- (NSInteger)getBadgeNumberByIndex:(NSInteger)index;
- (void)resetItem:(MiniUITabBarItem *)item atIndex:(NSUInteger)index;
- (void)setTabBackImage:(UIImage *)tabBg;
- (void)setTabItemHighlightImage:(UIImage *)itemHighlightBg;
- (MiniUITabBarItem *)itemAtIndex:(NSInteger)index;
- (UIView *)backgroundView;

@end
