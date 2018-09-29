//
// SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"

#import "EGOUITableView.h"

enum {
    SVPullToRefreshStateHidden = 1,
	SVPullToRefreshStateVisible,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading
};

typedef NSUInteger SVPullToRefreshState;


@interface SVPullToRefresh ()

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

@property (nonatomic, copy) void (^actionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset;

#ifdef __ARC__
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIView *arrayImageContainer;
@property (nonatomic, strong, readonly) UIImage *arrowImage;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
#else
@property (nonatomic, retain) UIImageView *arrow;
@property (nonatomic, retain, readonly) UIImage *arrowImage;
@property (nonatomic, retain) UIView *arrayImageContainer;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain, readonly) UILabel *dateLabel;
@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;
#endif


#ifdef __ARC__
@property (nonatomic, weak) UIScrollView *scrollView;
#else
@property (nonatomic, assign) UIScrollView *scrollView;
#endif


@end



@implementation SVPullToRefresh

// public properties
@synthesize actionHandler, textColor, lastUpdatedDate;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize arrayImageContainer, arrow, arrowImage, titleLabel, dateLabel, dateFormatter, originalScrollViewContentInset;

- (void)dealloc {
//    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
//    [self.scrollView removeObserver:self forKeyPath:@"frame"];
#ifndef __ARC__
    if (actionHandler)
    {
        Block_release(actionHandler);
        actionHandler = nil;
    }
    [arrow release];
    [arrowImage release];
    [titleLabel release];
    [dateFormatter release];
    [arrayImageContainer release];
    [super dealloc];
#endif
}

- (void)removeFromSuperview
{
    if ( self.superview == self.scrollView )
    {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"frame"];
    }
    [super removeFromSuperview];
}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    [_scrollView addSubview:self];
    self.textColor = [UIColor darkGrayColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 20)];
    titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = textColor;
    [self addSubview:titleLabel];
    

    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    self.originalScrollViewContentInset = scrollView.contentInset;
	
    self.state = SVPullToRefreshStateHidden;
    self.frame = CGRectMake(0, -60, scrollView.bounds.size.width, 60);
    self.arrayImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
    [self addSubview:self.arrayImageContainer];
    [self.arrayImageContainer addSubview:self.arrow];
    
    return self;
}

- (void)layoutSubviews {
    CGFloat remainingWidth = self.superview.bounds.size.width-200;
    float position = 0.50;
    
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.x = ceil(remainingWidth*position+44);
    titleLabel.frame = titleFrame;
    
    CGRect dateFrame = dateLabel.frame;
    dateFrame.origin.x = titleFrame.origin.x;
    dateLabel.frame = dateFrame;
    
    CGRect arrowFrame = arrayImageContainer.frame;
    arrowFrame.origin.x = ceil(remainingWidth*position);
    arrayImageContainer.frame = arrowFrame;
}

#pragma mark - Getters

- (UIImageView *)arrow {
    if(!arrow) {
        arrow = [[UIImageView alloc] initWithImage:self.arrowImage];
        arrow.backgroundColor = [UIColor clearColor];
    }
    return arrow;
}

- (UIImage *)arrowImage {
    UIImage *image = [UIImage imageNamed:@"SVPullToRefresh.bundle/arrow"];
    image = [image scaleToSize:CGSizeMake(30, 30)];
    return image;
}

- (UILabel *)dateLabel {
    if(!dateLabel) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 180, 20)];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = textColor;
        [self addSubview:dateLabel];
        
        CGRect titleFrame = titleLabel.frame;
        titleFrame.origin.y = 12;
        titleLabel.frame = titleFrame;
    }
    return dateLabel;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

#pragma mark - Setters


- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    titleLabel.textColor = newTextColor;
	dateLabel.textColor = newTextColor;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
        if ( self.state == SVPullToRefreshStateLoading || self.state == SVPullToRefreshStateHidden)
        {
            self.scrollView.contentOffset = CGPointMake(0, -contentInset.top);
            
        }
    } completion:^(BOOL finished) {
        if(self.state == SVPullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                arrow.alpha = 0;
            } completion:NULL];
    }];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"] && self.state != SVPullToRefreshStateLoading)
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;
    LOG_DEBUG(@"scrollOffsetThreshold :%f", scrollOffsetThreshold);
    if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
    {
        if ( [_scrollView isKindOfClass:[EGOUITableView class]])
        {
            if ( [(EGOUITableView*)_scrollView isLoadingMore] )
            {
                return;
            }
        }
        self.state = SVPullToRefreshStateLoading;
    }
    else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != SVPullToRefreshStateLoading)
    {
        LOG_DEBUG(@"-self.originalScrollViewContentInset.top(%f) > contentOffset.y(%f) > scrollOffsetThreshold:(%f)",
                  -self.originalScrollViewContentInset.top,
                  contentOffset.y, scrollOffsetThreshold );
        self.state = SVPullToRefreshStateVisible;
    }
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateVisible)
    {
        self.state = SVPullToRefreshStateTriggered;
        LOG_DEBUG(@"contentOffset.y < scrollOffsetThreshold");
    }
    else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != SVPullToRefreshStateHidden)
    {
        LOG_DEBUG(@"contentOffset.y >= -self.originalScrollViewContentInset.top");
        self.state = SVPullToRefreshStateHidden;
    }

    //if (self.scrollView.isDragging && self.state != SVPullToRefreshStateTriggered) {
        self.arrow.transform = CGAffineTransformMakeRotation(-contentOffset.y*0.3);
    //}
}

- (void)triggerRefresh {
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateHidden;
}

- (void)setState:(SVPullToRefreshState)newState {
    state = newState;
    
    switch (newState) {
        case SVPullToRefreshStateHidden:
            titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
            [self.arrow.layer removeAllAnimations];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case SVPullToRefreshStateVisible:
            titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
            arrow.alpha = 1;
            [self.arrow.layer removeAllAnimations];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            //[self rotateArrow:0 hide:NO];
            break;
            
        case SVPullToRefreshStateTriggered: {
            titleLabel.text = NSLocalizedString(@"Release to refresh...",);
            break;
        }
            
        case SVPullToRefreshStateLoading: {
            titleLabel.text = NSLocalizedString(@"Loading...",);
            [self.arrow.layer removeAllAnimations];
            CABasicAnimation *rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT;
            [self.arrow.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

            [self setScrollViewContentInset:UIEdgeInsetsMake(self.frame.origin.y * -1 + self.originalScrollViewContentInset.top, 0, 0, 0)];
            if (actionHandler)
                actionHandler();
            break;
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
//    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView;

- (void)refreshDone
{
    [self.pullToRefreshView stopAnimating];
    [self.pullToRefreshView setLastUpdatedDate:[NSDate date]];
}

- (BOOL)isRefreshing
{
    return (self.pullToRefreshView.state == SVPullToRefreshStateLoading);
}

- (void)triggerRefresh
{
    [self.pullToRefreshView triggerRefresh];
}

- (void)setPullToRefreshAction:(void (^)(void))actionHandler {
    SVPullToRefresh *pullToRefreshView = [[SVPullToRefresh alloc] initWithScrollView:self];
    pullToRefreshView.actionHandler = actionHandler;
    self.pullToRefreshView = pullToRefreshView;
#ifndef __ARC__
    [pullToRefreshView release];
#endif
}

- (void)setPullToRefreshView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (SVPullToRefresh *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

@end
