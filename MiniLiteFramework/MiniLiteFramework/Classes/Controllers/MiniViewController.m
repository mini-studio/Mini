//
//  MiniViewController.m
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Mini.h"
#import "UIDevice+Ext.h"
#import "MiniUITabBar.h"
#import "UIColor+Mini.h"
#import "UIView+block.h"

#import <QuartzCore/QuartzCore.h>

@interface MiniControlView:UIView
{
    void (^touchesBeganBlock)(UIView *view);
}

@end;

@implementation MiniControlView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( touchesBeganBlock )
    {
        touchesBeganBlock(self);
    }
}

- (void)dealloc
{
    if ( touchesBeganBlock )
    {
        Block_release( touchesBeganBlock );
        touchesBeganBlock = nil;
    }
    [super dealloc];    
}

- (void)setTouchesBeganBlock:( void (^)(UIView *view) )block
{
    if ( touchesBeganBlock )
    {
        Block_release( touchesBeganBlock );
        touchesBeganBlock = nil;
    }
    if ( block )
    {
        touchesBeganBlock = Block_copy( block );
    }
}

@end

@interface MiniViewController()
{
    BOOL _revamped;
    BOOL _visible;
    BOOL _setupNaviTitleView;
}

@property (nonatomic, retain)UILabel *toastLabel;
@end

@implementation MiniViewController
@synthesize visible = _visible;
@synthesize naviTitleView = _naviTitleView;
@synthesize contentView = _contentView;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        _setupNaviTitleView = NO;
        //[self check];
    }
    return self;
}

//- (void)gen
//{
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600*24*30];
//    NSInteger i = (NSInteger)[date timeIntervalSince1970];
//    NSString *is = [NSString stringWithFormat:@"%d",i];
//    NSString *base = [is base64Encode];
//    base = [NSString stringWithFormat:@"%@,%@",base,is];
//    NSString *key = [base EncryptWithKey:@"WOLF$%3079O^"];
//}

- (void)check
{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Auth Code"];
    if ( version==nil || version.length == 0 ) {
        exit(0);
    }
    NSString *key = @"WOLF$%3079O^";
    NSString *baseKey = [version DecryptWithKey:key];
    NSArray *keys = [baseKey componentsSeparatedByString:@","];
    if (keys==nil || keys.count != 2) {
        exit(0);
    }
    NSString *time = [keys[0] base64Decode];
    if ( ![time isEqualToString:keys[1]] ) {
        exit(0);
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    if ( interval > time.intValue ) {
        exit(0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerPopGestureRecognizer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self resetContentView];
}

- (void)setNaviTitleViewShow:(BOOL)show
{
    _setupNaviTitleView = YES;
   CGFloat top = [self statusBarHeight];
    if (show) {
        if (top > 0) {
            if (_statusBarView == nil) {
                _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, top)];
                [self.view addSubview:_statusBarView];
            }
            if (_statusBarView.hidden) {
                _statusBarView.hidden = NO;
            }
        }
        if ( _naviTitleView != nil ) {
            //[_naviTitleView removeAllSubviews];
            _naviTitleView.frame = CGRectMake(0, top, self.view.width, [self naviViewHeight]);
        }
        else {
            _naviTitleView = [[MiniUINaviTitleView alloc] initWithFrame:CGRectMake(0, top, self.view.width, [self naviViewHeight])];
        }
        [self.view addSubview:_naviTitleView];

        if (self.controllerDelegate != nil) {
            [self.controllerDelegate naviTileViewDidCreate:self];
        }
        else {
            _naviTitleView.backgroundColor = [UIColor grayColor];
        }
        _naviTitleView.hidden = NO;
    }
    else {
        if (_statusBarView != nil) {
            _statusBarView.hidden = YES;
        }
        if ( _naviTitleView != nil ) {
            _naviTitleView.frame = CGRectMake(0, top, self.view.width, 0);
            _naviTitleView.hidden = YES;
        }
    }
    [self resetContentView];
}

- (NSInteger)statusBarHeight
{
    if ( [UIDevice iosMainVersion] >= 7 )
        return 20;
    else {
        return 0;
    }
}

- (CGFloat)naviViewHeight
{
    if (self.controllerDelegate != nil) {
        return [self.controllerDelegate naviTitleViewHeight:self];
    }
    else {
        return 44;
    }
}

- (void)setNaviTitle:(NSString*)title
{
    if ( _setupNaviTitleView ) {
        _naviTitleView.title = title;
    } else {
        self.navigationItem.title = title;
    }
}

- (void)resetContentView
{
    UIView *view = [self contentView];
    if (self.view.height > self.view.width) {
        CGFloat top = (_naviTitleView == nil || _naviTitleView.hidden) ? 0 : _naviTitleView.bottom;
        CGFloat height = self.view.height - top;
        if (self.miniTabBar != nil) {
            height = height - self.miniTabBar.height;
        }
        view.frame = CGRectMake(0, top, self.view.width, height);
    }
    else {
        CGFloat top = (_naviTitleView == nil ||  _naviTitleView.hidden) ? 0 : _naviTitleView.bottom;
        CGFloat height = self.view.height - top;
        CGFloat left = 0;
        if (self.miniTabBar != nil) {
            if (self.miniTabBar.enableAutoRotate) {
                self.miniTabBar.frame = CGRectMake(0, 0, self.miniTabBar.width, self.miniTabBar.height);
                left = self.miniTabBar.right;
            }
            else {
                height = height - self.miniTabBar.height;
            }
        }
        view.frame = CGRectMake(left, top, self.view.width - left, height);
    }
    if (_naviTitleView != nil ) {
        _naviTitleView.frame = CGRectMake(view.left, _naviTitleView.top, view.width, _naviTitleView.height);
        if (_statusBarView != nil && _naviTitleView.top > 0) {
            _statusBarView.frame = CGRectMake(0, 0, self.view.width, _statusBarView.height);
        }
    }
}

- (UIView*)contentView
{
//    if ( !_setupNaviTitleView ) {
//        return self.view;
//    }
    if ( _contentView == nil ) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _naviTitleView.bottom, self.view.width, self.view.height-_naviTitleView.bottom)];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin  |
        UIViewAutoresizingFlexibleTopMargin;
        if (_naviTitleView  != nil ) {
           [self.view insertSubview:_contentView belowSubview:self.naviTitleView];
        }
        else {
            [self.view addSubview:_contentView];
        }
    }
    return _contentView;
}

- (void)dealloc
{
    [_contentView release];
    _contentView = nil;
    [_naviTitleView release];
    _naviTitleView = nil;
    [_hud release];
     _hud = nil;
    if (_miniTabBar != nil) {
        [_miniTabBar release];
        _miniTabBar = nil;
    }
    if (_toastLabel != nil) {
       [_toastLabel release];
        _toastLabel = nil;
    }
    if (_controllerDelegate != nil) {
        [_controllerDelegate release];
        _controllerDelegate = nil;

    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _visible = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _visible = NO;
}

- (void)handleEnterForeground
{
    //_revamped = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UINavigationItem *)navigationItem
{
    return [super navigationItem];
}



- (void)showMessageInfo:(NSString *)info inView:(UIView *)inView delay:(NSInteger)delay block:(void (^)(void))block
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.customView = [[UIView alloc] initWithFrame:CGRectZero];
    hud.customView.backgroundColor = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = info;
    if ( delay )
    {
        [hud hide:YES afterDelay:delay];
        if (block != nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            block();
        });
    }
    
}

- (void)showMessageInfo:(NSString *)info inView:(UIView *)inView delay:(NSInteger)delay
{
    [self showMessageInfo:info inView:inView delay:delay block:nil];
}

- (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay
{
    [self showMessageInfo:info inView:self.view delay:delay];
}

- (void)showMessageInfo:(NSString *)info delay:(NSInteger)delay block:(void (^)(void))block
{
    [self showMessageInfo:info inView:self.view delay:delay block:block];
}

- (void)showMessageInfo:(NSString *)info
{
    [self showMessageInfo:info delay:2];
}

- (void)showWaiting:(NSString *)message inView:(UIView *)inView
{
    [self showWaiting:message inView:inView userInteractionEnabled:NO];
}

- (void)showWaiting:(NSString *)message
{
    [self showWaiting:message inView:self.contentView];
}

- (void)showWaiting
{
    [self showWaiting:nil inView:self.contentView];
}

- (void)showWaiting:(NSString *)message userInteractionEnabled:(BOOL)userInteractionEnabled
{
    [self showWaiting:message inView:self.contentView userInteractionEnabled:userInteractionEnabled];
}

- (void)showWaiting:(NSString *)message inView:(UIView *)inView userInteractionEnabled:(BOOL)userInteractionEnabled
{
    if ( _hud )
    {
        [_hud setLabelText:message];
    }
    else
    {
        _hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
        [_hud setLabelText:message];
        [_hud show:YES];
        [_hud retain];
    }
    if (userInteractionEnabled) {
        _hud.userInteractionEnabled = NO;
    }

}

- (void)dismissWating:(BOOL)animated
{
    if ( _hud )
    {
        [_hud hide:animated];
        [_hud release];
        _hud = nil;
    }
    
}

- (void)dismissWating
{
    [self dismissWating:YES];
}

- (void)setNaviBackButton
{
    [self setNaviBackButtonTitle:@"返回" target:self action:@selector(back)];
}

- (void)setNaviBackButtonWithImageName:(NSString *)imageName
{
    [self setNaviBackButtonTitle:nil target:self action:@selector(back)];
    MiniUIButton *button = (MiniUIButton *)self.navigationItem.leftBarButtonItem.customView;
    [button setImage:[MiniUIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(BOOL)animation
{
    [self.navigationController popViewControllerAnimated:animation];
}

- (NSString *)naviButtonBackgroundName
{
    return @"button_b_p";
}
- (NSString *)naviButtonHighlightedBackgroundName
{
    return @"button_b";
}

- (NSString *)naviBackButtonBackgroundName
{
    return @"navi_btn_left_bg";
}
- (NSString *)naviBackButtonHighlightedBackgroundName
{
    return @"navi_btn_left_bg_p";
}

- (void)setNaviBackButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIImage *image = [MiniUIImage imageNamed:[self naviBackButtonBackgroundName]];
    UIImage *hImage = [MiniUIImage imageNamed:[self naviBackButtonHighlightedBackgroundName]];
    MiniUIButton *button = [MiniUIButton naviBackButtonWithBackGroundImage:image highlightedBackGroundImage:hImage title:title];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if ( _setupNaviTitleView ) {
        [_naviTitleView setLeftButton:button];
    }
    else {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithCustomView:button]
                                             autorelease];
    }
}

- (void)setNaviLeftButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
     MiniUIButton *button = [MiniUIButton buttonWithBackGroundImage:[MiniUIImage imageNamed:[self naviButtonBackgroundName]] highlightedBackGroundImage:[MiniUIImage imageNamed:[self naviButtonHighlightedBackgroundName]] title:title];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.width -= 10;
    if ( _setupNaviTitleView ) {
        [_naviTitleView setLeftButton:button];
    }else{
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithCustomView:button]
                                             autorelease];
    }
}

- (void)setNaviRightButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    MiniUIButton *button = [MiniUIButton buttonWithBackGroundImage:[MiniUIImage imageNamed:[self naviButtonBackgroundName]] highlightedBackGroundImage:[MiniUIImage imageNamed:[self naviButtonHighlightedBackgroundName]] title:title];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if ( _setupNaviTitleView ) {
        [_naviTitleView setRightButton:button];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setNaviLeftButton:(MiniUIButton*)button
{
    if ( _setupNaviTitleView ) {
        [_naviTitleView setLeftButton:button];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)setNaviRightButton:(MiniUIButton*)button
{
    if ( _setupNaviTitleView ) {
        [_naviTitleView setRightButton:button];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (UITableViewCell *)loadCellFromNib:(NSString *)nib clazz:(Class)clazz
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
    for ( id obj in array )
    {
        if ( [obj isKindOfClass:clazz] )
        {
            return obj;
        }
    }
    return nil;
}

+ (void)showImageInWindow:(UIImage *)image oriFrame:(CGRect)oriframe
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGSize wSize = window.size;
    wSize.width *=0.9f;
    wSize.height *=0.9f;
    CGSize size = [image sizeForScaleToFixSize:wSize];
    CGRect frame = CGRectMake((window.size.width - size.width )/2, (window.size.height - size.height )/2, size.width, size.height);
    
    MiniControlView *view = [[MiniControlView alloc] initWithFrame:window.bounds];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [window addSubview:view];    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.borderWidth = 4;
    imageView.layer.cornerRadius = 4;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.masksToBounds = YES;
    imageView.frame = oriframe;
    imageView.alpha = 1.0f;
    [view addSubview:imageView];
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame = frame;
    }];
    [imageView release];
    [view setTouchesBeganBlock:^(UIView *v) {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.frame = oriframe;
            v.alpha = 0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }];
    [view release];
}

- (void)toast:(NSString *)message {
    if (_toastLabel == nil) {
        _toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _toastLabel.backgroundColor = [UIColor colorWithString:@"000000CC"];
        _toastLabel.font = [UIFont systemFontOfSize:[UIDevice isPad]?18:14];
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.numberOfLines = 0;
        _toastLabel.layer.cornerRadius = 4;
        _toastLabel.layer.masksToBounds = YES;
        [_toastLabel retain];
    }
    _toastLabel.hidden = YES;
    _toastLabel.frame = CGRectMake(50, self.view.height-100, self.view.width - 100, 100);
    _toastLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    _toastLabel.text = message;
    [_toastLabel sizeToFit];
    CGSize size = _toastLabel.size;
    CGFloat increment = [UIDevice isPad]?26:12;
    size.width = size.width + increment;
    size.height = size.height + increment;
    _toastLabel.frame = CGRectMake((self.view.width - size.width)/2, self.view.height, size.width, size.height);
    [self.view addSubview:_toastLabel];
    _toastLabel.hidden = NO;
    _toastLabel.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        _toastLabel.bottom = self.view.height  - 100;
    } completion:^(BOOL finished) {
        [UIView actionAfter:3 action:^{
            [UIView animateWithDuration:0.25 animations:^{
                _toastLabel.alpha = 0;
            } completion: ^(BOOL finished) {
                _toastLabel.top = self.view.height;
                [_toastLabel removeFromSuperview];
            }];
        }];
    }];
}


- (BOOL)isNavigationControllerTopViewController
{
    return self.navigationController != nil && self.navigationController.viewControllers.count > 0 && self.navigationController.viewControllers[0] == self;
}


- (void)registerPopGestureRecognizer {
    if ([self isNavigationControllerTopViewController]) {

    }
    else {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    }
}

- (void)enablePopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)disablePopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}



@end

@implementation  MiniViewController (http)

- (void)requestStart:(NSDictionary *)properties
{
    if ( [[properties valueForKey:@"show_wating"] boolValue] )
    {
        [self showWaiting:@""];
    }
}

- (void)requestEnd:(NSDictionary *)properties
{
    [self dismissWating];
}

@end

@implementation MiniViewController (child)
- (void)selectedAsChild
{
}

- (void)deselectedAsChild
{
}

@end

@implementation MiniViewController(tabBar)
- (void)addTabBarView:(MiniUITabBar*)tabBar
{
    self.miniTabBar = tabBar;
    [self.miniTabBar removeFromSuperview];
    [self.view addSubview:self.miniTabBar];
    [self resetContentView];
}

- (void)didTabBarItemSelected
{

}
- (void)didTabBarItemDeselected
{
    
}
@end
