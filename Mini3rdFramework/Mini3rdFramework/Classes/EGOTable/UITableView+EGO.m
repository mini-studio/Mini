//
//  UITableView+EGO.m
//  YConference
//
//  Created by William on 12-9-13.
//  Copyright (c) 2012年 Youlu Ltd., Co. All rights reserved.
//

#import "UITableView+EGO.h"
#define EGO_ERROR     LOG_DEBUG(@"Please Use EGOTableView");\
NSAssert(NO, @"Please Use EGOTableView");
@implementation UITableView (EGO)

- (void)setLoadingMore:(BOOL)loadingMore
{
    EGO_ERROR;
}

- (BOOL)isLoadingMore
{
    EGO_ERROR;
    return NO;
}

- (void)setMoreDataAction:(void (^)())moreDataAction
{
    EGO_ERROR;
}

- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData
{
    EGO_ERROR;
}

- (void)preSetMoreDataAction:(void (^)())moreDataAction
{
    EGO_ERROR;
}

- (id<UITableViewDelegate>)proxyDelegate
{
    EGO_ERROR;
    return nil;
}

- (id<UITableViewDataSource>)proxyDataSource
{
    EGO_ERROR;
    return nil;
}

- (void)setMoreDataCell:(HaloUIMoreDataCell *)moreDataCell
{
    EGO_ERROR;
}

- (HaloUIMoreDataCell *)moreDataCell
{
    EGO_ERROR;
    return nil;
}

- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData loadSection:(BOOL)loadSection
{
    
}

- (void)setCouldLoadMoreBlock:(CouldLoadMoreBlock)couldLoadMoreBlock
{
    
}

- (void)stopLoadingMoreAnimation
{
    
}

- (void)stopLoadingMoreAnimation:(BOOL)hideMoreCell
{

}
@end
