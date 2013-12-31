//
//  UIGroupButtonView.m
//  bake
//
//  Created by Wuquancheng on 12-10-27.
//  Copyright (c) 2012年 youlu. All rights reserved.
//

#import "MiniUISegmentView.h"
#import <objc/message.h>
#import <QuartzCore/QuartzCore.h>

@interface MiniUISegmentView()
@property (nonatomic,assign)id target;
@property (nonatomic)SEL selector;

@end

@implementation MiniUISegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.separatorColor = [UIColor grayColor];
        self.viewStyle = MiniUISegmentViewStyleSeg;
    }
    return self;
}

- (void)dealloc
{
    [_separatorColor release];
    [_backgroudView release];
    [_slidderImageView release];
    [super dealloc];
}

- (void)setBackGroundImage:(UIImage *)backGroundImage
{
    if ( _backgroudView == nil )
    {
        _backgroudView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroudView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self insertSubview:_backgroudView atIndex:0];
    }
    _backgroudView.image = backGroundImage;
}

- (void)setSlidderImage:(UIImage *)slidderImage
{
    if ( _slidderImageView == nil )
     {
         _slidderImageView = [[UIImageView alloc] initWithFrame:self.bounds];
         [self insertSubview:_slidderImageView aboveSubview:_backgroudView];
         _slidderImageView.layer.cornerRadius = self.layer.cornerRadius;
          _slidderImageView.clipsToBounds = YES;
     }
     _slidderImageView.image = slidderImage;
}

- (void)setItems: (NSArray *) array block:(id(^)(int index, NSString *attri))block
{
    _selectedSegmentIndex = -1;
    CGFloat width = ceil(self.width/(array.count/5));
    NSInteger count = 0;
    CGFloat height = self.height - self.layer.borderWidth;
    if ( _slidderImageView )
    {
        _slidderImageView.size = CGSizeMake(width, height);
    }
    for ( NSInteger index = 0; index < array.count; index++ )
    {
        NSString *title = [array objectAtIndex:index];
        index ++;
        id target = [array objectAtIndex:index];
        index ++;
        NSString *action = [array objectAtIndex:index];
        
        index ++;
        UIImage *deImage = [array objectAtIndex:index];
        index ++;
        UIImage *hiImage = [array objectAtIndex:index];
        MiniUIButton *button = [MiniUIButton buttonWithBackGroundImage:deImage highlightedBackGroundImage:hiImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) title:title];
        button.tag = 100+count;
        button.frame = CGRectMake(count * width, 0, width, height);
        
        if ( block != nil )
        {
            [button setTitleColor:block(index,@"UIControlStateNormal") forState:UIControlStateNormal];
            [button setTitleColor:block(index,@"UIControlStateHighlighted") forState:UIControlStateHighlighted];
            [button setTitleColor:block(index,@"UIControlStateSelected") forState:UIControlStateSelected];
        }
        else
        {
            [button setTitleColor:[self colorAttriValueForKey:UIControlStateNormal index:index defaultValue:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setTitleColor:[self colorAttriValueForKey:UIControlStateHighlighted index:index defaultValue:[UIColor blackColor]] forState:UIControlStateHighlighted];
            [button setTitleColor:[self colorAttriValueForKey:UIControlStateSelected index:index defaultValue:[UIColor blackColor]] forState:UIControlStateSelected];
        }
        if (action.length > 0 )
        {
            SEL sel = NSSelectorFromString(action);
            [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        }
        [button addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[button backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateSelected];
        [self addSubview:button];
        count++;
    }
    for ( NSInteger index = 1; index < count; index++ )
    {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(index*width, 1, 1, self.height-2)];
        separator.backgroundColor = self.separatorColor;
        [self addSubview:separator];
        [separator release];
    }
}

- (id)colorAttriValueForKey:(NSInteger)key index:(NSInteger)index defaultValue:(id)defv
{
    return defv;
}

- (void)setItems: (NSArray *) array
{
    [self setItems:array block:nil];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    MiniUIButton *button = (MiniUIButton*)[self viewWithTag:(100+selectedSegmentIndex)];
    
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)onButtonTap:(MiniUIButton *)button
{
    if ( self.slidderImageView != nil )
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.slidderImageView.frame = button.frame;
        }];
    }
    if ( _selectedSegmentIndex == (button.tag - 100) )
    {
        return;
    }
    if ( self.viewStyle != MiniUISegmentViewStyleGroup )
    {
        button.selected = YES;
        for ( UIView *view in self.subviews )
        {
            if ( view != button && [view isKindOfClass:[MiniUIButton class]])
            {
                [(MiniUIButton*)view setSelected:NO];
            }
        }
    }
    _selectedSegmentIndex = button.tag - 100;
    if ( self.target != nil && self.selector != nil )
    {
        NSString *sel = NSStringFromSelector(self.selector);
        if ( [sel characterAtIndex:(sel.length-1)] == ':' )
        {
            [self.target performSelector:self.selector withObject:self];
        }
        else
        {
            [self.target performSelector:self.selector];
        }
    }
}

- (UIButton *)buttonAtIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[self viewWithTag:100+index];
    return button;
}

- (void)setTarget:(id)target selector:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}


@end
