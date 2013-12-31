//
//  MiniUINavigationController.h
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUINavigationController : UINavigationController
{
}

@property (nonatomic,retain)UIImage *navigationBarBackGround;

- (void)resetNavigationBar;
- (void)recover;

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller;

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
@end
