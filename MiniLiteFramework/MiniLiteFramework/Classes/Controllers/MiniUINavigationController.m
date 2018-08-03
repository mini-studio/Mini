//
//  MiniUINavigationController.m
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUINavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface MiniUINavigationController()
{
    UINavigationBar *_minNavigationBar;
    UIView          *adjustMainView;
}
@end


@implementation MiniUINavigationController

- (id)init
{
    self = [super init];
    if (self) {
        
//        UIImage *image = [self navigationBarBackGround];
//        if ( image != nil )
//        {
//            [self.navigationBar setBackgroundImage:image];
//        }
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if ( self ) {
//        UIImage *image = [self navigationBarBackGround];
//        if ( image != nil )
//        {
//            [self.navigationBar setBackgroundImage:image];
//        }
    }
    return self;
}

- (void)dealloc
{
    [_minNavigationBar release];
    [_navigationBarBackGround release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView
{
    [super loadView];
    UIImage *image = [self navigationBarBackGround];
    if ( image != nil )
    {
        [self.navigationBar setBackgroundImage:image];
    }
}

- (void)setNavigationBarBackGround:(UIImage *)navigationBarBackGround
{
    [navigationBarBackGround retain];
    [_navigationBarBackGround release];
    _navigationBarBackGround = navigationBarBackGround;
    [self.navigationBar setBackgroundImage:_navigationBarBackGround];
}

- (void)resetNavigationBar
{
    UINavigationBar *bar = self.navigationBar;
    for ( UIView *view in self.view.subviews )
    {
        if ( view == bar )
        {
            continue;
        }
        CGRect frame = view.frame;
        if ( frame.origin.y == 0 )
        {
            adjustMainView = view;
            CGRect frame = view.frame;
            frame.origin.y = bar.height - 44;
            frame.size.height = frame.size.height + (44 - bar.height);
            view.frame = frame;
        }        
    }
}

- (void)recover
{
    UINavigationBar *bar = self.navigationBar;
    
        CGRect frame = adjustMainView.frame;
        frame.origin.y = 0;
        frame.size.height = frame.size.height + (bar.height - 44);
        adjustMainView.frame = frame;   
}

- (UINavigationBar *)navigationBar
{
    UINavigationBar *bar = [super navigationBar];
    bar.tag = UINavigationBarTag;
    return bar;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    [self resetNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}


- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.20f animations:^{
        [self recover];
    }];
    
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.20f animations:^{
    [self resetNavigationBar];
    }];
}

@end
