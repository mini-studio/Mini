//
//  MiniUIButton.m
//  LS
//
//  Created by wu quancheng on 12-6-11.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniUIButton.h"

NSString *MINI_ButtonHanldeKey = @"MINI_ButtonHanldeKey";
typedef void(^MINIButtonTouchupHanlder)(MiniUIButton *button);

@interface MiniUIButton ()
{
    BOOL _longPressEvent;
    NSTimer		*_initiateTimer;
    MINIButtonTouchupHanlder _handler;
}

@end

@implementation MiniUIButton
@synthesize userInfo = _userInfo;
@synthesize longPressTimeInterval = _longPressTimeInterval;

- (void)dealloc
{
    Block_release(_handler);
    _handler = nil;
    [_userInfo release];
    [super dealloc];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _longPressEvent = NO;
	_initiateTimer = [NSTimer scheduledTimerWithTimeInterval:self.longPressTimeInterval
													 target:self
												   selector:@selector(onceTimerFireMethod:)
												   userInfo:nil
													repeats:NO];
	BOOL ret = [super beginTrackingWithTouch:touch withEvent:event];
	return ret;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(!CGRectContainsPoint(touch.view.bounds, [touch locationInView:touch.view]))
	{
		[_initiateTimer invalidate]; _initiateTimer = nil;
        _longPressEvent = NO;
	}
	BOOL ret = [super continueTrackingWithTouch:touch withEvent:event];
	return ret;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[_initiateTimer invalidate]; _initiateTimer = nil;
	[super endTrackingWithTouch:touch withEvent:event];
    if ( _longPressEvent )
    {
        [super sendActionsForControlEvents:UIControlEventTouchUpInsideRepeat];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[_initiateTimer invalidate]; _initiateTimer = nil;
    _longPressEvent = NO;
	[super cancelTrackingWithEvent:event];
}

- (void)onceTimerFireMethod:(NSTimer*)theTimer
{
	_initiateTimer = nil;
    _longPressEvent = YES;
	[super sendActionsForControlEvents:UIControlEventTouchInsideRepeat];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    CGRect r = self.bounds;
    if (!CGRectContainsPoint(r, p) && p.y < -KGap*2)//out
    {
        [self sendActionsForControlEvents:UIControlEventTouchCancel];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2,  image.size.width/2)];
    [super setBackgroundImage:image forState:state];
}

+ (id)buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage title:(NSString *)title
{
    return [self buttonWithBackGroundImage:backGroundImage highlightedBackGroundImage:highlightedBackGroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(backGroundImage.size.height/2, backGroundImage.size.width/2, backGroundImage.size.height/2,  backGroundImage.size.width/2) title:title];
}

+ (id)buttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage resizableImageWithCapInsets:(UIEdgeInsets)insets title:(NSString *)title
{
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    if ( backGroundImage )
    {
        if ( !UIEdgeInsetsEqualToEdgeInsets (insets, UIEdgeInsetsMake(0,0,0,0)) )
        {
            backGroundImage = [backGroundImage resizableImageWithCapInsets:insets];
        }
        [button setBackgroundImage:backGroundImage forState:UIControlStateNormal];
    }
    if ( highlightedBackGroundImage )
    {
        if ( !UIEdgeInsetsEqualToEdgeInsets (insets, UIEdgeInsetsMake(0,0,0,0)) )
        {
            highlightedBackGroundImage = [highlightedBackGroundImage resizableImageWithCapInsets:insets];
        }
        [button setBackgroundImage:highlightedBackGroundImage forState:UIControlStateHighlighted];
    }
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button sizeToFit];
    button.width += 20;
    return button;

}

+ (id)naviBackbuttonWithBackGroundImage:(UIImage *)backGroundImage highlightedBackGroundImage:(UIImage *)highlightedBackGroundImage title:(NSString *)title
{
    MiniUIButton *button = [self buttonWithBackGroundImage:backGroundImage highlightedBackGroundImage:highlightedBackGroundImage title:title];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    return button;
}

+ (id)buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage resizableImageWithCapInsets:(UIEdgeInsets)insets
{
    UIButton *button = [[self class] buttonWithType:UIButtonTypeCustom];
    if ( !UIEdgeInsetsEqualToEdgeInsets (insets, UIEdgeInsetsMake(0,0,0,0)) )
    {
        image = [image resizableImageWithCapInsets:insets];
        highlightedImage =  [highlightedImage resizableImageWithCapInsets:insets];
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    return button;
}

+ (id)buttonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    return [self buttonWithImage:image highlightedImage:highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/2, image.size.width/2, image.size.height/2,  image.size.width/2)];
}

- (void)handleButtonTouchup
{
    if ( _handler ){
        _handler(self);
    }
}

- (void)setTouchupHandler:(void (^)(MiniUIButton *button))handler
{
    if ( _handler != nil ) {
        Block_release(_handler);
        _handler = nil;
    }
    _handler = Block_copy(handler);
    [self addTarget:self action:@selector(handleButtonTouchup) forControlEvents:UIControlEventTouchUpInside];
}

@end
