//
// SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

//#define __ARC__

#import <UIKit/UIKit.h>

@interface SVPullToRefresh : UIView

#ifdef __ARC__
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSDate *lastUpdatedDate;

#else
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) NSDate *lastUpdatedDate;
#endif
- (void)triggerRefresh;
- (void)stopAnimating;

@end


// extends UIScrollView

@interface UIScrollView (SVPullToRefresh)

- (void)setPullToRefreshAction:(void (^)(void))actionHandler;

- (void)triggerRefresh;

- (void)refreshDone;

- (BOOL)isRefreshing;

#ifdef __ARC__
@property (nonatomic, strong) SVPullToRefresh *pullToRefreshView;
#else
@property (nonatomic, retain) SVPullToRefresh *pullToRefreshView;
#endif

@end
