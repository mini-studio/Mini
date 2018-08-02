//
//  MiniUITextView.m
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUITextView.h"

@interface MiniUITextView()
{
@private
    UILabel *placeHolderLabel;
    UIColor *placeholderColor;
}

@property (nonatomic,retain)UIColor *placeholderColor;
@property (nonatomic) CGPoint offset;
@property (nonatomic) BOOL keyBorderShowing;
@property (nonatomic) CGRect keyboardFrame;

@end

@implementation MiniUITextView
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize offset = _offset;

@synthesize keyBorderShowing = _keyBorderShowing;
@synthesize keyboardFrame = _keyboardFrame;
@synthesize scrollView = _scrollView;

- (void)initial
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillHide:)name:UIKeyboardWillHideNotification object:nil];
    self.placeholderColor = [UIColor grayColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self initial];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [placeHolderLabel release];
    [placeholderColor release];
    [placeholder release];
    _scrollView = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)scrollToVisible
{
    if (_scrollView != nil) {
        UIWindow *window = ([UIApplication sharedApplication].delegate).window;
        CGRect frame = [self.superview convertRect:self.frame toView:window];
        frame.origin.y += 10;
        CGFloat maxY = CGRectGetMaxY(frame);
        if( maxY > self.keyboardFrame.origin.y ) //below keyborder
        {
            CGPoint __offset = self.scrollView.contentOffset;
            __offset.y += (maxY - self.keyboardFrame.origin.y);
            [UIView animateWithDuration:0.30F animations:^{
                self.scrollView.contentOffset = __offset;
            }completion:^(BOOL finished) {
            }];
        }
        else if ( frame.origin.y < 20 )
        {
            CGPoint __offset = self.scrollView.contentOffset;
            __offset.y += 30;
            [UIView animateWithDuration:0.30F animations:^{
                self.scrollView.contentOffset = __offset;
            }completion:^(BOOL finished) {
            }];
        }
    }
}

- (void)handleKeyBorderWillShow:(NSNotification *)noti
{
    if (self.scrollView != nil) {
        CGRect keyboardFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.keyboardFrame = keyboardFrame;
        if ( [self isFirstResponder] )
        {
            if (!self.keyBorderShowing) {
                if (self.scrollView != nil && [self.scrollView respondsToSelector:@selector(setContentOffset:)]) {
                    self.offset = self.scrollView.contentOffset;
                }
            }
            [self scrollToVisible];
        }        
        self.keyBorderShowing = YES;
    }
}

- (void)handleKeyBorderWillHide:(NSNotification *)noti
{
    if (self.scrollView != nil) {
        self.keyBorderShowing = NO;
        if ( self.offset.y != MAXFLOAT )
        {
            [UIView animateWithDuration:0.25f animations:^{
                if (self.scrollView != nil && [self.scrollView respondsToSelector:@selector(setContentOffset:)]) {
                    self.scrollView.contentOffset = self.offset;
                }
            }];
        }
        [self resetOffsetTrace];
    }
}

- (void)resetOffsetTrace
{
    self.offset = CGPointMake(0,MAXFLOAT);
}

@end
