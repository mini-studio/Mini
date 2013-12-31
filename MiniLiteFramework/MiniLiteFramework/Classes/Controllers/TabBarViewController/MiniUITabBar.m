
#import "MiniUITabBar.h"
#import "MiniUITabBarItem.h"
#define KTabBagTag 0x110

@interface MiniUITabBar (PrivateMethods)
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
        selectedTabIndex = -1;
        UIImageView* v = [[UIImageView alloc] init];
        v.tag = KTabBagTag;
        [self addSubview:v];
        [v release];
        
		highLightImageView = [[UIImageView alloc]  initWithFrame:CGRectZero];
		highLightImageView.hidden = NO;
		[self addSubview:highLightImageView];
	}
	return self;
}
- (void)layoutSubviews
{
	[super layoutSubviews];

	NSInteger button_x = 0;
    NSInteger buttonWidth = self.width/[self visibleTabCount];
	for (NSInteger i = 0; i<self.tabItemsArray.count; i++)
	{
        MiniUITabBarItem* item = [self.tabItemsArray objectAtIndex:i];
		item.frame = CGRectMake(button_x, self.height - item.height, buttonWidth, item.height);
		//[self addSubview:item];
		button_x += buttonWidth;
	}
    [self sendSubviewToBack:[self viewWithTag:KTabBagTag]];
    [self layoutFloatingImageView:buttonWidth];
}

- (void)layoutFloatingImageView:(CGFloat)width
{
    highLightImageView.width = width;
    highLightImageView.left = [self bottomHighlightImageXAtIndex:selectedTabIndex];
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
		[self addSubview:item];
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
        [self addSubview:item];
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
    highLightImageView.left = [self bottomHighlightImageXAtIndex:selectedIndex];
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
	highLightImageView.left = [self bottomHighlightImageXAtIndex:index];
	UIButton* button = [self.tabItemsArray objectAtIndex:index];
	[self touchDownAction:button];
    selectedTabIndex = index;
}


- (CGFloat)bottomHighlightImageXAtIndex:(NSUInteger)tabIndex
{
	CGFloat tabItemWidth = self.frame.size.width / self.tabItemsArray.count;
	CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (highLightImageView.width / 2.0);
	return (tabIndex * tabItemWidth) + halfTabItemWidth;
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

- (void)setTabItemHighlightImage:(UIImage *)itemHighlighBg
{
    highLightImageView.image = itemHighlighBg;
    NSInteger height = itemHighlighBg.size.height;
    if ( height > self.height )
    {
        height = self.height;
    }
    CGRect frame = CGRectMake(0, (self.height - height)/2, itemHighlighBg.size.width, height);
    highLightImageView.frame = frame ;
}

- (MiniUITabBarItem *)itemAtIndex:(NSInteger)index
{
    return [tabItemsArray objectAtIndex:index];
}

- (void)dealloc
{
	[highLightImageView release];
	[bgImage release];
	[tabItemsArray release];
	[super dealloc];
}


@end
