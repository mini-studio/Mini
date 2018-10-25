
#import "MiniUITabBar.h"
#import "MiniUITabBarItem.h"
#import "UIDevice+Ext.h"
#import "MiniDefine.h"

#define KTabBagTag 0x110

@interface MiniUITabBar (PrivateMethods)
@property (nonatomic, strong) UIView *contentView;
- (void)addShadowToBottomView;
- (void)createTabItems;
- (NSInteger)visibleTabCount;
@end

@implementation MiniUITabBar
@synthesize bgImage;
@synthesize tabItemsArray;
@synthesize delegate;
@synthesize selectedTabIndex;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _enableAutoRotate = YES;
        selectedTabIndex = -1;
        UIImageView* v = [[UIImageView alloc] init];
        v.tag = KTabBagTag;
        [self addSubview:v];
        [v release];
        highLightImageView = [[UIImageView alloc]  initWithFrame:CGRectZero];
        highLightImageView.hidden = NO;
        [self addSubview:highLightImageView];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)dealloc
{
    [highLightImageView release];
    [bgImage release];
    [tabItemsArray release];
    [_contentView release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (IS_IPHONE_X) {
        self.contentView.frame = CGRectMake(0, 0, self.width, self.height-IPHONE_X_TABBAR_BOTTOM_EXT_HEIGHT);
    }
    else {
        self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    NSInteger button_x = 0;
    if (self.height < self.width) {
        NSInteger buttonWidth = self.width / [self visibleTabCount];
        for (NSInteger i = 0; i < self.tabItemsArray.count; i++) {
            MiniUITabBarItem *item = [self.tabItemsArray objectAtIndex:i];
            CGFloat itemHeight = MIN(item.height, self.contentView.height);
            item.frame = CGRectMake(button_x, self.contentView.height - itemHeight , buttonWidth, itemHeight);
            //[self addSubview:item];
            button_x += buttonWidth;
            [item setNeedsDisplay];
        }
        CGRect frame = CGRectMake(0, 0, buttonWidth, self.height);
        highLightImageView.frame = frame ;
        [self sendSubviewToBack:[self viewWithTag:KTabBagTag]];
        [self layoutFloatingImageView:buttonWidth];
        if (_shadowView != nil) { //在顶部
            _shadowView.hidden = NO;
            _shadowView.frame = CGRectMake(0, -_shadowView.height, self.width, _shadowView.height);
        }
        if (_shadowViewLandscape != nil) {
            _shadowViewLandscape.hidden = YES;
        }
    }
    else {
        NSInteger buttonWidth = self.contentView.width;
        CGFloat gap = [UIDevice isPad]?50:20;
        CGFloat left = 0;
        CGFloat itemHeight = ((MiniUITabBarItem*)[self.tabItemsArray objectAtIndex:0]).height;
        CGFloat top = (self.height - self.tabItemsArray.count * (itemHeight + gap) + gap)/2;
        for (NSInteger i = 0; i < self.tabItemsArray.count; i++) {
            MiniUITabBarItem *item = [self.tabItemsArray objectAtIndex:i];
            item.frame = CGRectMake(left, top, buttonWidth, item.height);
            top = (item.bottom + gap);
            [item setNeedsDisplay];
        }
        CGRect frame = CGRectMake(0, 0, buttonWidth, itemHeight);
        highLightImageView.frame = frame ;
        [self sendSubviewToBack:[self viewWithTag:KTabBagTag]];
        [self layoutFloatingImageView:buttonWidth];
        if (_shadowViewLandscape != nil) { //在右侧
            _shadowViewLandscape.hidden = NO;
            _shadowViewLandscape.frame = CGRectMake(self.width, 0 , _shadowViewLandscape.width, self.height);
        }
        if (_shadowView != nil) {
            _shadowView.hidden = YES;
        }
    }

}

- (void)layoutFloatingImageView:(CGFloat)width
{
    highLightImageView.width = width;
    if (self.width > self.height) {
        highLightImageView.left = [self bottomHighlightImageXAtIndex:selectedTabIndex];
    }
    else {
        MiniUITabBarItem *item = [self.tabItemsArray objectAtIndex:selectedTabIndex];
        highLightImageView.top = item.top;
    }

}

- (void)setTabItemsArray:(NSMutableArray *)array
{
    if (tabItemsArray != array)
    {
        [tabItemsArray release];
        tabItemsArray = nil;
        tabItemsArray = array;
        [tabItemsArray retain];

        [self createTabItems];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.bgImage drawInRect:rect];
}

- (void)addShadowToBottomView
{
    UIImage* image = [MiniUIImage imageNamed:@"shadow_bottom"];
    if (image)
    {
        UIImageView* shadowView = [[UIImageView alloc] initWithImage:image];
        CGRect rect = CGRectMake(0, 0 - image.size.height, self.width, image.size.height);
        shadowView.frame = rect;
        [self addSubview:shadowView];
        [shadowView release];
    }
}

- (void)createTabItems
{
    NSInteger itemCount = self.tabItemsArray.count;
    NSInteger width = self.width/itemCount;
    NSInteger height = self.height;
    for (MiniUITabBarItem* item in self.tabItemsArray)
    {
        item.frame = CGRectMake(0.0, 0.0, width, height);

        [item addTarget:self action:@selector(touchDownAction:)forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(touchUpInsideAction:)forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:item];
    }
}

- (void)resetItem:(MiniUITabBarItem *)item atIndex:(NSUInteger)index
{
    if (self.tabItemsArray.count > index)
    {
        MiniUITabBarItem *old = [self.tabItemsArray objectAtIndex:index];
        [old removeFromSuperview];
        [self.tabItemsArray removeObjectAtIndex:index];
        [self.tabItemsArray insertObject:item atIndex:index];

        NSInteger itemCount = self.tabItemsArray.count;
        NSInteger width = self.width/itemCount;
        NSInteger height = self.height;

        item.frame = CGRectMake(0.0, 0.0, width, height);
        [item addTarget:self action:@selector(touchDownAction:)forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(touchUpInsideAction:)forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:item];
        [self layoutSubviews];
    }
}

- (NSInteger)visibleTabCount
{
    return self.tabItemsArray.count ;
}

- (void)dimAllButtonsExcept:(UIButton*)selectedButton
{
    MiniUITabBarItem* item = (MiniUITabBarItem*)selectedButton;
    item.selected = YES;
    item.highlighted = item.selected ? NO : YES;

    NSUInteger selectedIndex = [self.tabItemsArray indexOfObjectIdenticalTo:item];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if(self.height < self.width) {
        highLightImageView.left = [self bottomHighlightImageXAtIndex:selectedIndex];
    }
    else {
        highLightImageView.top = [self bottomHighlightImageYAtIndex:selectedIndex];
    }
    [UIView commitAnimations];
    if(selectedTabIndex >= 0)
    {
        MiniUITabBarItem* lastItem = [self.tabItemsArray objectAtIndex:selectedTabIndex];
        lastItem.selected = NO;
        lastItem.highlighted = item.selected ? NO : YES;
        [lastItem setNeedsDisplay];
    }

    selectedTabIndex = selectedIndex;

    [item setNeedsDisplay];
}

- (void)touchDownAction:(UIButton*)button
{
    NSInteger selectedIndex = [self.tabItemsArray indexOfObject:button];
    BOOL ret = YES;
    if ( [delegate respondsToSelector:@selector(willTouchDownAtItemAtIndex:)] )
    {
        ret = [delegate willTouchDownAtItemAtIndex:selectedIndex];
    }
    if ( ret )
    {
        if (selectedIndex != self.selectedTabIndex)
        {
            [self dimAllButtonsExcept:button];
        }
    }
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
    {
        [delegate touchDownAtItemAtIndex:selectedIndex];
    }
}

- (void)touchUpInsideAction:(UIButton*)button
{
    //[self dimAllButtonsExcept:button];

    if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [delegate touchUpInsideItemAtIndex:[self.tabItemsArray indexOfObject:button]];
}

//- (void)otherTouchesAction:(UIButton*)button
//{
//	[self dimAllButtonsExcept:button];
//}

- (void)setSelectedTabIndex:(NSInteger)index
{
    if ( index < 0 || index >= self.tabItemsArray.count )
    {
        return;
    }
    UIButton* button = [self.tabItemsArray objectAtIndex:index];
    if (self.width > self.height) {
        highLightImageView.left = [self bottomHighlightImageXAtIndex:index];
    }
    else {
        highLightImageView.origin = button.origin;
    }
    [self touchDownAction:button];
    selectedTabIndex = index;
}


- (CGFloat)bottomHighlightImageXAtIndex:(NSUInteger)tabIndex
{
    if (self.height < self.width) {
        CGFloat tabItemWidth = self.frame.size.width / self.tabItemsArray.count;
        CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (highLightImageView.width / 2.0);
        return (tabIndex * tabItemWidth) + halfTabItemWidth;
    }
    else {
        return 0;
    }
}

- (CGFloat)bottomHighlightImageYAtIndex:(NSUInteger)tabIndex
{
    if (self.height > self.width) {
        UIButton *button = [[self tabItemsArray] objectAtIndex:tabIndex];
        return button.top;
    }
    else {
        return 0;
    }
}


- (void)setBadgeNumber:(NSInteger)number atIndex:(NSInteger)index
{
    MiniUITabBarItem* item = (MiniUITabBarItem*)[self.tabItemsArray objectAtIndex:index];
    item.badge = number;
}

- (void)setBadgeText:(NSString*)badgeText atIndex:(NSInteger)index
{
    MiniUITabBarItem* item = (MiniUITabBarItem*)[self.tabItemsArray objectAtIndex:index];
    [item setBadgeText:badgeText];
}

- (void)setBadgeImage:(UIImage *)image atIndex:(NSInteger)index
{
    MiniUITabBarItem* item = (MiniUITabBarItem*)[self.tabItemsArray objectAtIndex:index];
    [item setBadgeImage:image];
}

- (NSInteger)getBadgeNumberByIndex:(NSInteger)index
{
    NSInteger result = 0;
    if (index >= 0 && index < self.tabItemsArray.count)
    {
        MiniUITabBarItem* item = [self.tabItemsArray objectAtIndex:index];
        result = item.badge;
    }
    return result;
}
- (void)setTabBackImage:(UIImage *)tabBg
{
    UIImageView *tab = (UIImageView *)[self viewWithTag:KTabBagTag];
    UIImage *tabBackImg = tabBg;
    if ( tabBackImg.size.width < 20 )
    {
        tabBackImg = [tabBackImg stretchableImageWithLeftCapWidth:ceil(tabBackImg.size.width/2) topCapHeight:ceil(tabBackImg.size.height/2)];
    }
    tab.image = tabBackImg;
    tab.width = self.width;
    tab.height = tabBackImg.size.height;
    tab.top = self.height - tabBackImg.size.height;

}

- (UIView *)backgroundView
{
    return [self viewWithTag:KTabBagTag];
}

- (void)setTabItemHighlightImage:(UIImage *)itemHighlightBg
{
    highLightImageView.image = itemHighlightBg;
}

- (MiniUITabBarItem *)itemAtIndex:(NSInteger)index
{
    return [tabItemsArray objectAtIndex:index];
}

- (void)setShadowView:(UIView *)shadowView
{
    if (_shadowView != nil) {
        [_shadowView removeFromSuperview];
    }
    _shadowView = shadowView;
    _shadowView.hidden = YES;
    if (_shadowView != nil) {
        _shadowView.frame = CGRectMake(0, -_shadowView.height, self.width, _shadowView.height);
        [self addSubview:_shadowView];
    }
}

- (void)setShadowViewLandscape:(UIView *)shadowViewLandscape {
    if (_shadowViewLandscape != nil) {
        [_shadowViewLandscape removeFromSuperview];
    }
    _shadowViewLandscape = shadowViewLandscape;
    if (_shadowViewLandscape != nil) {
        [self addSubview:_shadowViewLandscape];
        _shadowViewLandscape.hidden = YES;
    }
}


@end
