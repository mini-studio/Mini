//
//  EGOUITableView.h
//  RefreshTable
//
//  Created by Wuquancheng on 12-9-7.
//  Copyright (c) 2012年 youlu. All rights reserved.
//

//#define __ARC__

#import <UIKit/UIKit.h>
#import "UITableView+EGO.h"
#import "SVPullToRefresh.h"

#define KKeepLoadMoreCellWhenNoata NO

@interface HaloUIMoreDataCell : UITableViewCell
#ifdef __ARC__
@property (nonatomic,strong)UILabel     *statusLabel;
@property (nonatomic,strong)UIActivityIndicatorView     *activityIndicatorView;
#else
@property (nonatomic,retain)UILabel     *statusLabel;
@property (nonatomic,retain)UIActivityIndicatorView     *activityIndicatorView;
#endif
@property (nonatomic)BOOL autoLoadingMore; //default is YES

//overwritting method "setHasMoreData:(BOOL)hasMoreData" for custom child class, you can setup ui in this method
@property (nonatomic)BOOL hasMoreData;

//overwritting method "startLoading" for custom child class, this method been invoked when start to load more data
- (void)startLoading;
//overwritting method "stopLoding" for custom child class, this method been invoked when stop to load more data
- (void)stopLoding;

- (void)setBottomLineCorlor:(UIColor *)color;
@end

@interface EGOUITableView : UITableView

@property (nonatomic,getter = isLoadingMore ) BOOL loadingMore;
@property (nonatomic,copy)CouldLoadMoreBlock couldLoadMoreBlock;
@property (nonatomic,copy)void(^moreDataAction)();

- (void)preSetMoreDataAction:(void (^)())moreDataAction;
- (void)setMoreDataAction:(void (^)())moreDataAction;
- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData;
- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData loadSection:(BOOL)loadSection;
- (void)stopLoadingMoreAnimation;
- (void)stopLoadingMoreAnimation:(BOOL)hidMoreCell;

- (id<UITableViewDelegate>)proxyDelegate;
- (id<UITableViewDataSource>)proxyDataSource;

#ifdef __ARC__
@property (nonatomic,strong)HaloUIMoreDataCell     *moreDataCell;
#else
@property (nonatomic,retain)HaloUIMoreDataCell     *moreDataCell;
#endif

@end
