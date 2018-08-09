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


/*
 *===========================================================
 
 ============================================================
 */

@interface MiniUITabBarController()
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,assign) UIViewController *selectedViewController;;
@end

@implementation MiniUITabBarController
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
    self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentView];
    CGRect tabBarFrame = CGRectMake(0, self.contentView.height-[self tabBarVisualHeight], self.view.width, [self tabBarVisualHeight]);
    [self tabBarView];
    self.tabBarView.frame = tabBarFrame;
    self.tabBarView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.contentView.frame = self.self.view.bounds;
    if (self.view.width > self.view.height && self.tabBarView.enableAutoRotate) {
        self.tabBarView.frame = CGRectMake(0, 0, [self landscapeTabBarVisualWidth], self.contentView.height);
    }
    else {
        self.tabBarView.frame = CGRectMake(0, self.contentView.height-[self portraitTabBarVisualHeight], self.view.width, [self portraitTabBarVisualHeight]);
    }

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

- (NSInteger)portraitTabBarVisualHeight
{
    return [self heightForTabBarView];
}

- (NSInteger)landscapeTabBarVisualWidth {
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

- (void)setBadgeText:(NSString *)badgeString atIndex:(NSInteger)index
{
    [self.tabBarView setBadgeText:badgeString atIndex:index];
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
    self.selectedIndex = itemIndex;
    if ( [controller respondsToSelector:@selector(didTabBarItemSelected)])
    {
        [controller performSelector:@selector(didTabBarItemSelected)];
    }

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
    UIView *controlView = controller.view;
    [self.contentView addSubview:controlView];
    self.selectedViewController = controller;
}

- (BOOL)willTouchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    return YES;
}


- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


@end


