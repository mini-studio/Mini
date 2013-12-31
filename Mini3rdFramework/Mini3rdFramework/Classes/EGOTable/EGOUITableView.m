//
//  EGOUITableView.m
//  RefreshTable
//
//  Created by Wuquancheng on 12-9-7.
//  Copyright (c) 2012年 youlu. All rights reserved.
//

#import "EGOUITableView.h"
#import "SVPullToRefresh.h"

@interface HaloUIMoreDataCell()
@property (nonatomic)BOOL loading;
@end

@implementation HaloUIMoreDataCell
{
    @package
    UIView                  *_bottomLineView;
    UILabel                 *_statusLabel;
    BOOL                     _hasMoreData;
    UIActivityIndicatorView *_activityIndicatorView;
}

@synthesize hasMoreData = _hasMoreData;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        [self initSubViews];
        _hasMoreData = YES;
        _autoLoadingMore = YES;
    }
    return self;
}

- (void)initSubViews
{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityIndicatorView.hidden = YES;
    [self.contentView addSubview:_activityIndicatorView];
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _statusLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    _statusLabel.numberOfLines = 1;
    _statusLabel.hidden = YES;
    [self addSubview:_statusLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


#ifndef __ARC__
- (void)dealloc
{
    [_statusLabel release];
    [_bottomLineView release];
    [_activityIndicatorView release];
    [super dealloc];
}
#endif

- (void)removeFromSuperview
{
    [_bottomLineView removeFromSuperview];
    [super removeFromSuperview];
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    if ( _loading )
    {
        [self startLoading];
    }
    else
    {
        [self stopLoding];
    }
}

- (void)startLoading
{
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];
}

- (void)stopLoding
{
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
}

- (void)setBottomLineCorlor:(UIColor *)color
{
    if ( _bottomLineView == nil )
    {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    }
    _bottomLineView.backgroundColor = color;
}

- (UIView *)bottomLineView
{
    return _bottomLineView;
}

- (void)setHasMoreData:(BOOL)hasMoreData
{
    _hasMoreData = hasMoreData;
    if ( _hasMoreData )
    {
        if ( !_statusLabel.hidden )
        {
            _statusLabel.hidden = YES;
        }
    }
    else
    {
        [self stopLoding];
        if ( _statusLabel.hidden == YES )
        {
            _statusLabel.text = NSLocalizedString(@"ego_footer_no_more_data", nil);
            [_statusLabel sizeToFit];
            _statusLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            _statusLabel.hidden = NO;
        }
    }
}

@end


@interface EGOUITableView()<UITableViewDataSource,UITableViewDelegate>
{
@private
    NSInteger                _lastSectionRows;
    
    BOOL                     _loadingMore;
    HaloUIMoreDataCell         *_moreDataCell;
    BOOL                       _keepCellWhenNoData;
    
}

#ifdef __ARC__
@property (nonatomic,weak) id<UITableViewDelegate> innerTableViewDelegate;
@property (nonatomic,weak) id<UITableViewDataSource> innerTableViewDataSource;
#else
@property (nonatomic,assign) id<UITableViewDelegate> innerTableViewDelegate;
@property (nonatomic,assign) id<UITableViewDataSource> innerTableViewDataSource;
#endif
@end

@implementation EGOUITableView

@synthesize loadingMore = _loadingMore;
@synthesize moreDataCell = _moreDataCell;
- (id)init
{
    if ( self = [super init] )
    {
        [self didInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self didInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self didInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self didInit];
    }
    return self;
}

- (void)didInit
{
    self.delegate = self;
    self.dataSource = self;
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"contentSize" ];
#ifndef __ARC__
    if ( _moreDataAction != nil )
    {
        Block_release(_moreDataAction);
        _moreDataAction = nil;
    }
    [_moreDataCell release];
    [super dealloc];
#endif
}


- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if ( delegate == self )
    {
        [super setDelegate:delegate];
    }
    else
    {
        self.innerTableViewDelegate = delegate;
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if ( dataSource == self )
    {
        [super setDataSource:dataSource];
    }
    else
    {
        self.innerTableViewDataSource = dataSource;
    }
}

- (id<UITableViewDelegate>)proxyDelegate
{
    return self.innerTableViewDelegate;
}

- (id<UITableViewDataSource>)proxyDataSource
{
    return self.innerTableViewDataSource;
}

#pragma mark - method for more data
- (BOOL)hasMore
{
    return self.moreDataAction != nil;
}

- (void)setLoadingMore:(BOOL)loadingMore
{
    _loadingMore = loadingMore;
    if ( _loadingMore )
    {
        [(HaloUIMoreDataCell *)_moreDataCell setLoading:YES];
    }
    else
    {
        [(HaloUIMoreDataCell *)_moreDataCell setLoading:NO];
    }
}

- (void)preSetMoreDataAction:(void (^)())moreDataAction
{
#ifdef __ARC__
    self.moreDataAction = moreDataAction;
#else
    if ( self.moreDataAction != nil )
    {
        Block_release( self.moreDataAction );
        self.moreDataAction = nil;
    }
    if ( moreDataAction )
    {
        self.moreDataAction = Block_copy( moreDataAction );
    }
#endif
    _keepCellWhenNoData = NO;
}

- (void)setMoreDataAction:(void (^)())moreDataAction
{
    [self setMoreDataAction:moreDataAction keepCellWhenNoData:KKeepLoadMoreCellWhenNoata loadSection:YES];
}

- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData
{
    [self setMoreDataAction:moreDataAction keepCellWhenNoData:keepCellWhenNoData loadSection:YES];
}

- (void)setMoreDataAction:(void (^)())moreDataAction keepCellWhenNoData:(BOOL)keepCellWhenNoData loadSection:(BOOL)loadSection
{
    BOOL showingMoreData = [self showingMoreDataSection];
    
#ifdef __ARC__
    _moreDataAction = moreDataAction;
#else
    if ( _moreDataAction != nil )
    {
        Block_release( _moreDataAction );
        _moreDataAction = nil;
    }
    if ( moreDataAction )
    {
        _moreDataAction = Block_copy( moreDataAction );
    }
#endif
    _keepCellWhenNoData = keepCellWhenNoData;
    if ( _keepCellWhenNoData )
    {
        self.moreDataCell.hasMoreData = (_moreDataAction != nil);
    }
    
    BOOL needShowMoreData = [self needShowLoadMoreSection];
    
    if (showingMoreData == needShowMoreData)
    {
        return ;
    }
    if (loadSection)
    {
        [self reloadMoreDataSection];
    }
}

- (HaloUIMoreDataCell *)moreDataCell
{
    if ( _moreDataCell == nil )
    {
        _moreDataCell = [[HaloUIMoreDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"__More_Data_Cell"];
        [_moreDataCell setBottomLineCorlor:self.backgroundColor];
    }
    return _moreDataCell;
}

- (void)setMoreDataCell:(HaloUIMoreDataCell *)moreDataCell
{
#ifndef __ARC__
    [moreDataCell retain];
    [_moreDataCell release];
#endif
    _moreDataCell = moreDataCell;
}

- (void)manualLoadMore
{
    [self doLoadMore:NO];
}

- (void)doLoadMore:(BOOL)autoload
{
    //用于添加外部控制是否可以loadMore
    BOOL couldLoadMore = YES;
    if (self.couldLoadMoreBlock)
    {
        couldLoadMore = self.couldLoadMoreBlock();
    }
    
    if ( [self hasMore] && couldLoadMore)
    {
        if ( !self.loadingMore )
        {
            if ( !autoload || [_moreDataCell autoLoadingMore] )
            {
                if ( self.isRefreshing )
                {
                    return;
                }
                self.loadingMore = YES;
                self.moreDataAction();
            }
        }
        else
        {
            // [_moreDataCell startLoading];
        }
    }
}

#pragma mark - help method
- (void)relayoutBottomLine
{
    UIView *bottomLineView = ((HaloUIMoreDataCell *)_moreDataCell).bottomLineView;
    if (_moreDataCell.hidden)
    {
        [bottomLineView removeFromSuperview];
        return ;
    }
    
    if ([bottomLineView superview] != self)
    {
        [self addSubview:bottomLineView];
    }
    CGFloat top = self.contentSize.height-1;
    UIView *footerView = self.tableFooterView;
    if (footerView)
    {
        top -= footerView.frame.size.height;
    }
    bottomLineView.frame = CGRectMake(0,top , self.frame.size.width, 2);
}

- (NSInteger)realSectionCnt
{
    NSInteger realSectionCnt = 1;
    if ([self.innerTableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        realSectionCnt = [self.innerTableViewDataSource numberOfSectionsInTableView:self];
    }
    return realSectionCnt;
}

- (BOOL)needShowLoadMoreSection
{
    return _keepCellWhenNoData || (self.moreDataAction != nil);
}

- (BOOL)showingMoreDataSection
{
    return [self numberOfRowsInSection:[self realSectionCnt]] == 1;
}

- (BOOL)isLoadMoreSection:(NSInteger)section
{
    return [self realSectionCnt] == section;
}

- (void)reloadMoreDataSection
{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange([self realSectionCnt], 1)];
    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


- (void)stopLoadingMoreAnimation
{
    [self.moreDataCell stopLoding];
    self.loadingMore = NO;
}

- (void)stopLoadingMoreAnimation:(BOOL)hidMoreCell
{
    [self stopLoadingMoreAnimation];
    if (hidMoreCell)
    {
        [self hideMoreCellIfNeed];
    }
}

- (void)hideMoreCellIfNeed
{
    if ([self isMoreCellVisable] && (self.contentSize.height > (self.height+self.moreDataCell.height)))
    {
        __block typeof(self) itSelf = self;
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            itSelf.contentOffset = CGPointMake(0, itSelf.contentSize.height - itSelf.height - itSelf.moreDataCell.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - method for observer

- (BOOL)isMoreCellVisable
{
    UIView *footerView = self.tableFooterView;

    if(!footerView)
    {
        return _moreDataCell &&  (self.contentSize.height - self.contentOffset.y - CGRectGetHeight(self.frame)) <= CGRectGetHeight(_moreDataCell.frame) ;
    }
    else
    {
        return _moreDataCell &&  (self.contentSize.height - self.contentOffset.y -  CGRectGetHeight(self.frame)) <= CGRectGetHeight(_moreDataCell.frame) + CGRectGetHeight(footerView.frame);
    }
}

- (BOOL)shouldTriggerLoadMore
{
    if (!self.isDragging)
    {
        return NO;
    }
    
    if (self.moreDataAction == nil)
    {
        return NO;
    }
    
    return [self isMoreCellVisable];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"contentOffset"] && object == self )
    {
        [self relayoutBottomLine];
        CGPoint newFffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldOffset = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
        
        if ( newFffset.y -  oldOffset.y > 5 && [self shouldTriggerLoadMore])
        {
            [self doLoadMore:YES];
        }
    }
    else if ([keyPath isEqualToString:@"contentSize"] && object == self)
    {
        [self relayoutBottomLine];
    }
}



#pragma mark - method for reload table data
- (void)reloadData
{
    [self setLoadingMore:NO];
    [super reloadData];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self setLoadingMore:NO];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self setLoadingMore:NO];
    [super insertSections:sections withRowAnimation:animation];
}

#pragma mark - method for data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
        return [self needShowLoadMoreSection] ? 1 : 0;
    }
    
    return  [self.innerTableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger  sections = 1;
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] )
    {
        sections = [self.innerTableViewDataSource numberOfSectionsInTableView:tableView] ;
    }
    return sections + 1;
}

- (void)layoutSubviews
{
//    CGPoint offset = CGPointMake(self.contentOffset.x, self.contentInset.top+self.contentOffset.y);
//    [self setContentOffset:offset animated:NO];
    [super layoutSubviews];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return [self moreDataCell];
    }
    else
    {
        return [self.innerTableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
        return nil;
    }
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
    {
        return [self.innerTableViewDataSource tableView:tableView titleForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
        return nil;
    }
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)])
    {
        return [self.innerTableViewDataSource tableView:tableView titleForFooterInSection:section];
    }
    else
    {
        return nil;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self isLoadMoreSection:indexPath.section])
    {
        return NO;
    }
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
    {
        return [self.innerTableViewDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    else
    {
        return YES;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return NO;
    }
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
    {
        return [self.innerTableViewDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    else
    {
        return YES;
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
    {
        return [self.innerTableViewDataSource sectionIndexTitlesForTableView:tableView];
    }
    else
    {
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
    {
        return [self.innerTableViewDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    else
    {
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self isLoadMoreSection:indexPath.section] )
    {
        return;
    }
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
    {
        [self.innerTableViewDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if ( [self.innerTableViewDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
    {
        [self.innerTableViewDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}


#pragma mark - method for table view delegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        if ( CGRectGetMaxY( cell.frame ) <= self.frame.size.height )
        {
            ;
        }
        else
        {
            [self doLoadMore:YES];
        }
    }
    else
    {
        if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        {
            [self.innerTableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        CGFloat height = [self moreDataCell].frame.size.height;
        if ( height != 0  )
        {
            return height;
        }
        else
        {
            return 44;
        }
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        return [self.innerTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
        return 0.25;
    }
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
    {
        return [self.innerTableViewDelegate tableView:tableView heightForHeaderInSection:section];
    }
    else
    {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
        return 0.25;
    }
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
    {
        return [self.innerTableViewDelegate tableView:tableView heightForFooterInSection:section];
    }
    else
    {
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self isLoadMoreSection:section])
    {
#ifdef __ARC__
        return [[UIView alloc] init];
#else
        return [[[UIView alloc] init] autorelease];
#endif
    }
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
    {
        return [self.innerTableViewDelegate tableView:tableView viewForHeaderInSection:section];
    }
    else
    {
        return nil;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( [self isLoadMoreSection:section])
    {
#ifdef __ARC__
        return [[UIView alloc] init];
#else
        return [[[UIView alloc] init] autorelease];
#endif
    }
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
    {
        return [self.innerTableViewDelegate tableView:tableView viewForFooterInSection:section];
    }
    else
    {
        return nil;
    }
    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return UITableViewCellAccessoryNone;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)])
    {
        return [self.innerTableViewDelegate tableView:tableView accessoryTypeForRowWithIndexPath:indexPath];
    }
    else
    {
        return UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        ;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
    {
        [self.innerTableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return nil;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
    {
        return [self.innerTableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    else
    {
        return indexPath;
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [self isLoadMoreSection:indexPath.section])
    {
        return nil;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
    {
        return [self.innerTableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    else
    {
        return indexPath;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [self.innerTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return ;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
    {
        [self.innerTableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return UITableViewCellEditingStyleNone;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
    {
        return [self.innerTableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return nil;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    else
    {
        return nil;
    }
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return NO;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    else
    {
        return YES;
    }
    
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return;
    }
    else if ([self isLoadMoreSection:indexPath.section])
    {
        [self.innerTableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
    else
    {
        
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)] )
    {
        [self.innerTableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
    else
    {
        
    }
    
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self isLoadMoreSection:proposedDestinationIndexPath.section])
    {
        return nil;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    else
    {
        return proposedDestinationIndexPath;
    }
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return 0;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    else
    {
        return 0;
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return NO;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    else
    {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return NO;
    }
    else if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)] )
    {
        return [self.innerTableViewDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    else
    {
        return NO;
    }
    
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self isLoadMoreSection:indexPath.section])
    {
        return;
    }
    else  if ( [self.innerTableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)] )
    {
        [self.innerTableViewDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    else
    {
        
    }
}

#pragma mark - delegate method for scroll view deleagte
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.innerTableViewDelegate scrollViewDidScroll:scrollView];
    }
}
// any offset changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)])
    {
        [self.innerTableViewDelegate scrollViewDidZoom:scrollView];
    }
}
// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.innerTableViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}
// called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.innerTableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
    {
        [self.innerTableViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.innerTableViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.innerTableViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)])
    {
        return [self.innerTableViewDelegate viewForZoomingInScrollView:scrollView];
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
    {
        [self.innerTableViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
    {
        [self.innerTableViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
    {
        return [self.innerTableViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    else
    {
        return YES;
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ( [self.innerTableViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)])
    {
        [self.innerTableViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
