//
//  MiniUINaviTitleView.h
//  FleetRecruit
//
//  Created by Wuquancheng on 13-7-13.
//  Copyright (c) 2013年 mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUINaviTitleView : UIView
@property (nonatomic,strong) MiniUIButton *leftButton;
@property (nonatomic,strong) MiniUIButton *rightButton;
@property (nonatomic,strong) NSString     *title;
@property (nonatomic,strong) UIImage      *backGround;
@end
