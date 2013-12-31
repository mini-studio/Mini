//
//  UITableView+EGO.h
//  YConference
//
//  Created by William on 12-9-13.
//  Copyright (c) 2012年 Mini Ltd., Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define __ARC__
typedef BOOL(^CouldLoadMoreBlock)(void);
@class HaloUIMoreDataCell;
@interface UITableView (EGO)

@property (nonatomic,getter = isLoadingMore )BOOL loadingMore;

- (void)preSetMoreDataAction:(void (^)())moreDataAction;
- (void)setMoreDataAction:(void (^)())moreDataAction;
- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData;
- (void)stopLoadingMoreAnimation;
- (void)stopLoadingMoreAnimation:(BOOL)hideMoreCell;

- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData loadSection:(BOOL)loadSection;
- (void)setCouldLoadMoreBlock:(CouldLoadMoreBlock)couldLoadMoreBlock;

- (id<UITableViewDelegate>)proxyDelegate;
- (id<UITableViewDataSource>)proxyDataSource;

#ifdef __ARC__
@property (nonatomic,strong)HaloUIMoreDataCell     *moreDataCell;
#else
@property (nonatomic,retain)HaloUIMoreDataCell     *moreDataCell;
#endif

@end
