//
// Created by Wuquancheng on 2018/8/3.
// Copyright (c) 2018 Wuquancheng. All rights reserved.
//

#import "MiniTabUINavigationController.h"


@interface MiniTabUINavigationController()
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
@end

@implementation MiniTabUINavigationController
{
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [NSMutableArray array];
        [self setNavigationBarHidden:YES animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDefaultNaviBackground];
}

- (void)setDefaultNaviBackground
{
    //UIImage *image = [MiniUIImage imageNamed:( MAIN_VERSION >= 7?@"navi_background":@"navi_background")];
    //[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end