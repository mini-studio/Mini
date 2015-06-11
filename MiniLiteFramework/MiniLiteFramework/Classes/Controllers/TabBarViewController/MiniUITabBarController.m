//
//  MiniUITabBarController.m
//  MiniFramework
//
//  Created by wu quancheng on 11-12-21.
//  Copyright (c) 2011年 Mini-Studio. All rights reserved.
//

#import "MiniUITabBarController.h"
//#import "MiniUITabViewController.h"
//#import "MiniUINavigationController.h"
//#import "MiniDefine.h"
#import "MiniUINavigationController.h"
@implementation MiniTabBarItem

@synthesize controllerName = _controllerName;
@synthesize image = _image;
@synthesize highlightedImage = _highlightedImage;
@synthesize title = _title;
@synthesize titleFont = _titleFont;
@synthesize clazz = _clazz;

- (void)constructWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage title:(NSString*)title
{
    self.controllerName = [controllerClass description];
    self.image = image;
    self.highlightedImage = highlightedImage;
    self.title = title;
}

- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage title:(NSString*)title
{
    if ( self = [super init] )
    {
        [self constructWithControllerClass:controllerClass image:image highlightedImage:highlightedImage title:title];
    }
    return self;
}

- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage title:(NSString*)title clazz:(Class)clazz
{
    if ( self = [super init] )
    {
        [self constructWithControllerClass:controllerClass image:image highlightedImage:highlightedImage title:title];
        self.clazz = clazz;
    }
    return self;
}

- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image highlightedImage:(UIImage*)highlightedImage
{
    if ( self = [super init] )
    {
        [self constructWithControllerClass:controllerClass image:image highlightedImage:highlightedImage title:nil];
    }
    return self;
}

- (id)initWithControllerClass:(Class)controllerClass image:(UIImage*)image title:(NSString*)title
{
    if ( self = [super init] )
    {
        [self constructWithControllerClass:controllerClass image:image highlightedImage:nil title:title];
    }
    return self;
}

- (void)dealloc
{
    [_controllerName release];
    [_image release];
    [_highlightedImage release];
    [_title release];
    [_titleFont release];
    [super dealloc];
}

@end

@interface MiniUITabBarController()
{
    UIView *contentView;
}
@end

@interface MiniUITabBarController (Private)
- (void)hideRealTabBar;
- (void)customTabBar:(NSArray*)titles;
- (void)selectedTab:(UIButton *)button;
- (void)setViewControllers:(NSArray *)viewControllers items:(NSArray*)items;
@end

@implementation MiniUITabBarController

@synthesize tabBarView;
@synthesize tabBarViewEdgeInsets;
@synthesize currentSelectedIndex;
@synthesize controllerDelegate;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	return self;
}

-(id)init 
{
    self = [super init];
    return self;
}

- (id)initWithItems:(NSArray*)array
{
    if (self = [self init] )
    {
        [self setItems:array];
    }
    return self;	
}

- (void)setItems:(NSArray*)array
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:array.count];
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:array.count];
    for ( NSInteger index = 0; index<array.count; index ++) 
    {
        MiniTabBarItem *item = [array objectAtIndex:index];
        MiniUINavigationController *nav = nil;       
        if ( item.controllerName.length > 0 )
        {
            UIViewController* controller = [[NSClassFromString(item.controllerName) alloc]init]; 
            nav = [[[self naviControllerClass] alloc] initWithRootViewController:controller];
            [controller release]; 
        }
        else
        {
            nav = [[[self naviControllerClass] alloc] init];
        }
        nav.navigationBarBackGround = [self navigationBarBackGroundForIndex:index];
        [items addObject:nav];
        [nav release];        
        Class clz = item.clazz;
        MiniUITabBarItem *uiBarItem = nil;
        if ( clz != nil ) {
            uiBarItem = [[clz alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        else {
            uiBarItem = [[MiniUITabBarItem alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        //[uiBarItem setTitlefont:item.titleFont normalStyle:item.titleNormalStyle highlightStyle:item.titleHighlightStyle];
        uiBarItem.attri = [self tableBarItemAttriAtIndex:index];
        [tabs addObject:uiBarItem];
        [uiBarItem release];
    }
    [super setViewControllers:items];
    self.tabBarView.tabItemsArray = tabs;
    self.tabBarView.selectedTabIndex = self.currentSelectedIndex;
}

- (Class)naviControllerClass
{
    return [MiniUINavigationController class];
}

- (NSDictionary *)tableBarItemAttriAtIndex:(NSInteger)index
{
    return nil;
}

- (UIView*)contentView
{
    UIView *_contentView = nil;
    for(UIView *view in self.view.subviews)
    {	
		CGRect rect = view.frame;
        if( ![view isKindOfClass:[UITabBar class]])
        {
            if ( rect.origin.x == 0 && rect.origin.y == 0 )
            {
                _contentView = view;
            }
            else
            {
                [view removeFromSuperview];
            }
        }			
    }
    return _contentView;
}

- (NSInteger)heightForTabBarView
{
    return 45;
}

- (NSInteger)tabBarVisualHeight
{
    return [self heightForTabBarView];
}

- (NSInteger)tabBarHeight
{
    return [self heightForTabBarView];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    CGRect tabBarFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-[self tabBarVisualHeight], self.view.width, [self tabBarVisualHeight]);
    self.tabBar.frame = tabBarFrame;
    self.tabBar.bounds = self.tabBar.frame;
    contentView = [self contentView];
    contentView.height =  tabBarFrame.origin.y;
    for ( UIView *view in self.tabBar.subviews )
    {
        [view removeFromSuperview];
    }
    MiniUITabBar *tb = [self tabBarView];
    tb.frame = tabBarFrame;
    tb.opaque = NO;
    tb.delegate = self;
    [self.tabBar addSubview:tb];
    [tb release];
}

- (MiniUITabBar *)tabBarView
{
    if ( tabBarView == nil )
    {
       tabBarView = [[MiniUITabBar alloc] init];
    }
   
    return tabBarView;
}

- (void)setView:(UIView *)view
{
    if (view == nil)
    {
        return;
    }
    else 
    {
        [super setView:view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for ( UIView *view in self.tabBar.subviews )
    {
        if ( ![view isKindOfClass:[MiniUITabBar class]])
        {
            view.hidden = YES;
        }
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    for ( UIView *view in self.tabBar.subviews )
//    {
//        if ( ![view isKindOfClass:[MiniUITabBar class]]) 
//        {
//            view.hidden = YES;
//        }       
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    if ( self.controllerDelegate )
    {        
        if ( [self.controllerDelegate willSelectedAtIndex:itemIndex] )
        {
            return;
        }
    }
    NSInteger last = currentSelectedIndex;
    if ( self.controllerDelegate )
    {
        [self.controllerDelegate willDeselectedAtIndex:last];
        UIViewController *controller = [self.viewControllers objectAtIndex:last];    
        if ( [controller isKindOfClass:[UINavigationController class]] )
        {
            NSArray *controllers = [(UINavigationController*)controller viewControllers];
            if ( controllers.count > 0 )
            {
                controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
            }        
        }
        if ( [controller respondsToSelector:@selector(didTabBarItemDeselected)]) 
        {
            [controller performSelector:@selector(didTabBarItemDeselected)];
        }
    }
    currentSelectedIndex = itemIndex;    
    self.selectedIndex = itemIndex;
    if ( self.controllerDelegate )
    {
        [self.controllerDelegate didDeselectedAtIndex:last];
        [self.controllerDelegate didSelectedAtIndex:currentSelectedIndex];
    }
    UIViewController *controller = [self.viewControllers objectAtIndex:itemIndex];    
    if ( [controller isKindOfClass:[UINavigationController class]] )
    {
        NSArray *controllers = [(UINavigationController*)controller viewControllers];
        if ( controllers.count > 0 )
        {
            controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
        }        
    }
    if ( [controller respondsToSelector:@selector(didTabBarItemSelected)]) 
    {
        [controller performSelector:@selector(didTabBarItemSelected)];
    }
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - hideTabBar, method from Ext
- (void)hideTabBar:(BOOL)yesOrNo animated:(BOOL)animated
{
    if ( contentView == nil )
    {
        contentView = [self contentView];
    }
    if ( yesOrNo )
    {
        CGRect frame = self.tabBar.frame;
        frame.origin.y = self.view.bottom;
        if ( animated )
        {
            [UIView animateWithDuration:.2f animations:^{
                self.tabBar.frame = frame;
                contentView.height = frame.origin.y; 
            }];
        } 
        else
        {
            self.tabBar.frame = frame;
            contentView.height = frame.origin.y;  
        }
    }
    else
    {
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-[self heightForTabBarView], self.view.width, [self heightForTabBarView]);
        if ( animated )
        {
            [UIView animateWithDuration:.2f animations:^{
                self.tabBar.frame = frame; 
                contentView.height = frame.origin.y; 
            }];
        } 
        else
        {
            self.tabBar.frame = frame; 
            contentView.height = frame.origin.y; 
        }
    }
}

- (void)setCurrentSelectedIndex:(NSInteger)index
{    
    currentSelectedIndex = index;
    self.tabBarView.selectedTabIndex = index;
}

- (void)setBadgeText:(NSString *)bageString atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeText:bageString atIndex:index];
}

- (void)setBadge:(NSInteger)badge atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeNumber:badge atIndex:index];
}

- (void)setBadgeImage:(UIImage *)badgeImage atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeImage:badgeImage atIndex:index];
}

- (void)resetItem:(MiniTabBarItem *)item atIndex:(NSUInteger)index
{
    NSArray *array = self.viewControllers;
    if ( array.count > index) 
    {   
        UIViewController* controller = [[NSClassFromString(item.controllerName) alloc]init]; 
        MiniUINavigationController *nav = [array objectAtIndex:index];
        nav.navigationBarBackGround = [self navigationBarBackGroundForIndex:index];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nav.viewControllers];
        if (viewControllers.count > 0)
        {
            [viewControllers removeObjectAtIndex:0];
        }
        [viewControllers insertObject:controller atIndex:0];
        [controller release]; 
        [nav setViewControllers:viewControllers];
        Class clz = item.clazz;
        MiniUITabBarItem *uiBarItem = nil;
        if ( clz == nil ) {
            uiBarItem = [[MiniUITabBarItem alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        else {
            uiBarItem = [[clz alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        //[uiBarItem setTitlefont:item.titleFont normalStyle:item.titleNormalStyle highlightStyle:item.titleHighlightStyle];
        uiBarItem.attri = [self tableBarItemAttriAtIndex:index];
        [self.tabBarView resetItem:uiBarItem atIndex:index];
        [uiBarItem release];
    }   
}

- (void)setIcon:(UIImage *)icon highLightIcon:(UIImage *)highLightIcon atIndex:(NSUInteger)index
{
    MiniUITabBarItem *item = [self.tabBarView itemAtIndex:index];
    [item setImage:icon highLightIcon:highLightIcon];
    [item setNeedsDisplay];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    UIViewController *controller = [self.viewControllers objectAtIndex:index];
    if ( [controller isKindOfClass:[UINavigationController class]] )
    {
        NSArray *controllers = [(UINavigationController*)controller viewControllers];
        if ( controllers.count > 0 )
        {
            controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
        }        
    }
    return controller;
}

- (UIImage *)navigationBarBackGroundForIndex:(NSInteger)index
{
    return nil;
}

@end

/*
 *===========================================================
 
 ============================================================
 */

@interface MiniTabBarController()
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,assign) UIViewController *selectedViewController;;
@end

@implementation MiniTabBarController
{
    
}

@synthesize tabBarView;
@synthesize tabBarViewEdgeInsets;
@synthesize currentSelectedIndex;
@synthesize controllerDelegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.viewControllers = [NSMutableArray array];
    return self;
}

- (id)init
{
    self = [super init];
    self.viewControllers = [NSMutableArray array];
    return self;
}

- (void)dealloc
{
    if (tabBarView != nil) {
        [tabBarView release];
        tabBarView = nil;
    }
    if (_contentView != nil) {
        [_contentView release];
        _contentView = nil;
    }
    if (_viewControllers != nil) {
        [_viewControllers release];
        _viewControllers = nil;
    }
    _selectedViewController = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentView];
    CGRect tabBarFrame = CGRectMake(0, self.contentView.height-[self tabBarVisualHeight], self.view.width, [self tabBarVisualHeight]);
    [self tabBarView];
    self.tabBarView.frame = tabBarFrame;
    self.tabBarView.delegate = self;
}

- (MiniUITabBar *)tabBarView
{
    if ( tabBarView == nil )
    {
        tabBarView = [[MiniUITabBar alloc] init];
        tabBarView.opaque = NO;
    }
    return tabBarView;
}

- (id)initWithItems:(NSArray*)array
{
    if (self = [self init] )
    {
        [self setItems:array];
    }
    return self;
}

- (NSInteger)heightForTabBarView
{
    return 48;
}

- (void)setItems:(NSArray *)array
{
    [self.viewControllers removeAllObjects];
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:array.count];
    for ( NSInteger index = 0; index<array.count; index ++)
    {
        MiniTabBarItem *item = [array objectAtIndex:index];
        MiniUINavigationController *nav = nil;
        if ( item.controllerName.length > 0 )
        {
            UIViewController* controller = [[NSClassFromString(item.controllerName) alloc]init];
            nav = [[[self naviControllerClass] alloc] initWithRootViewController:controller];
            [controller release];
        }
        else
        {
            nav = [[[self naviControllerClass] alloc] init];
        }
        nav.navigationBarBackGround = [self navigationBarBackGroundForIndex:index];
        [self.viewControllers addObject:nav];
        [nav release];
        Class clz = item.clazz;
        MiniUITabBarItem *uiBarItem = nil;
        if ( clz != nil ) {
            uiBarItem = [[clz alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        else {
            uiBarItem = [[MiniUITabBarItem alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        uiBarItem.attri = [self tableBarItemAttriAtIndex:index];
        [tabs addObject:uiBarItem];
        [uiBarItem release];
    }
    self.tabBarView.tabItemsArray = tabs;
    self.tabBarView.selectedTabIndex = self.currentSelectedIndex;
}

- (NSInteger)tabBarVisualHeight
{
    return [self heightForTabBarView];
}

- (NSInteger)tabBarHeight
{
    return [self heightForTabBarView];
}

- (Class)naviControllerClass
{
    return [MiniUINavigationController class];
}

- (void)setBadgeText:(NSString *)bageString atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeText:bageString atIndex:index];
}

- (void)setBadge:(NSInteger)badge atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeNumber:badge atIndex:index];
}

- (void)setBadgeImage:(UIImage *)badgeImage atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeImage:badgeImage atIndex:index];
}


- (NSDictionary *)tableBarItemAttriAtIndex:(NSInteger)index
{
    return nil;
}

- (void)resetItem:(MiniTabBarItem *)item atIndex:(NSUInteger)index
{
    NSArray *array = self.viewControllers;
    if ( array.count > index)
    {
        UIViewController* controller = [[NSClassFromString(item.controllerName) alloc]init];
        MiniUINavigationController *nav = [array objectAtIndex:index];
        nav.navigationBarBackGround = [self navigationBarBackGroundForIndex:index];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nav.viewControllers];
        if (viewControllers.count > 0)
        {
            [viewControllers removeObjectAtIndex:0];
        }
        [viewControllers insertObject:controller atIndex:0];
        [controller release];
        [nav setViewControllers:viewControllers];
        Class clz = item.clazz;
        MiniUITabBarItem *uiBarItem = nil;
        if ( clz == nil ) {
            uiBarItem = [[MiniUITabBarItem alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        else {
            uiBarItem = [[clz alloc]  initWithImage:item.image highlightedImage:item.highlightedImage title:item.title];
        }
        //[uiBarItem setTitlefont:item.titleFont normalStyle:item.titleNormalStyle highlightStyle:item.titleHighlightStyle];
        uiBarItem.attri = [self tableBarItemAttriAtIndex:index];
        [self.tabBarView resetItem:uiBarItem atIndex:index];
        [uiBarItem release];
    }
}

- (void)setIcon:(UIImage *)icon highLightIcon:(UIImage *)highLightIcon atIndex:(NSUInteger)index
{
    MiniUITabBarItem *item = [self.tabBarView itemAtIndex:index];
    [item setImage:icon highLightIcon:highLightIcon];
    [item setNeedsDisplay];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    UIViewController *controller = [self.viewControllers objectAtIndex:index];
    if ( [controller isKindOfClass:[UINavigationController class]] )
    {
        NSArray *controllers = [(UINavigationController*)controller viewControllers];
        if ( controllers.count > 0 )
        {
            controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
        }
    }
    return controller;
}

- (UIImage *)navigationBarBackGroundForIndex:(NSInteger)index
{
    return nil;
}

- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex
{
    
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    if (self.controllerDelegate)
    {
        if ([self.controllerDelegate willSelectedAtIndex:itemIndex])
        {
            return;
        }
    }
    NSInteger last = currentSelectedIndex;
    if (self.controllerDelegate)
    {
        [self.controllerDelegate willDeselectedAtIndex:last];
        UIViewController *controller = [self.viewControllers objectAtIndex:last];
        if ( [controller isKindOfClass:[UINavigationController class]] )
        {
            NSArray *controllers = [(UINavigationController*)controller viewControllers];
            if ( controllers.count > 0 )
            {
                controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
            }
        }
        if ( [controller respondsToSelector:@selector(didTabBarItemDeselected)])
        {
            [controller performSelector:@selector(didTabBarItemDeselected)];
        }
    }
    if ( self.controllerDelegate )
    {
        [self.controllerDelegate didDeselectedAtIndex:last];
        [self.controllerDelegate didSelectedAtIndex:currentSelectedIndex];
    }
    UIViewController *controller = [self.viewControllers objectAtIndex:itemIndex];
    if ( [controller isKindOfClass:[UINavigationController class]] )
    {
        NSArray *controllers = [(UINavigationController*)controller viewControllers];
        if ( controllers.count > 0 )
        {
            controller = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
        }
    }
    if ( [controller respondsToSelector:@selector(didTabBarItemSelected)])
    {
        [controller performSelector:@selector(didTabBarItemSelected)];
    }
    self.selectedIndex = itemIndex;

}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    currentSelectedIndex = selectedIndex;
    UIViewController *controller = [self.viewControllers objectAtIndex:selectedIndex];
    controller.view.frame = self.contentView.bounds;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UIViewController *ctl = [[(UINavigationController*)controller viewControllers] objectAtIndex:0];
        if ([ctl respondsToSelector:@selector(addTabBarView:)]) {
            [ctl performSelector:@selector(addTabBarView:) withObject:self.tabBarView];
        }
    }
    [self.contentView addSubview:controller.view];
    self.selectedViewController = controller;
}

- (BOOL)willTouchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    return YES;
}


@end


