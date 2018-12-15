//
//  MiniUITextField.m
//  YContact
//
//  Created by wu quancheng on 11-10-1.
//  Copyright 2011年 Mini. All rights reserved.
//

#import "MiniUITextField.h"

@interface MiniUITextField ()
{
    MiniUITextFieldDelegate *textFieldDelegate;
    id                      miniUITextFieldDelegate;
}

@property (nonatomic) CGPoint offset;
@property (nonatomic) BOOL keyBorderShowing;
@property (nonatomic) CGRect keyboardFrame;
@end

@implementation MiniUITextField
@synthesize userInfo;
@synthesize miniUITextFieldDelegate;
@synthesize scrolled = _scrolled;

@synthesize offset = _offset;
@synthesize scrollView = _scrollView;

@synthesize keyBorderShowing = _keyBorderShowing;
@synthesize keyboardFrame = _keyboardFrame;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView
{
    self = [self initWithFrame:frame];
    if ( self )
    {
        self.scrollView = scrollView;
        
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect
{
    if ( self = [super initWithFrame:rect] )
    {
        [self initial];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initial];
    }
    return self;
}

- (void)initial
{
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.multipleTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillShow:) name:MiniUIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillShow:) name:MiniUIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillHide:) name:MiniUIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillHide:) name:MiniUIKeyboardDidHideNotification object:nil];
    
    self.delegate = textFieldDelegate = [[MiniUITextFieldDelegate alloc] init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initial];
    }    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textFieldDelegate release];
    miniUITextFieldDelegate = nil;
    self.userInfo = nil;
    _scrollView = nil;
    [super dealloc];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}


- (void)scrollToVisible
{
    UIView *rootView = self.rootView;
    CGRect frame = [self.superview convertRect:self.frame toView:rootView];
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

- (void)handleKeyBorderWillShow:(NSNotification *)noti
{
    CGRect keyboardFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = keyboardFrame;
    if ( [self isFirstResponder] )
    {
        if (!self.keyBorderShowing) {
            if (self.scrollView != nil) {
                if (self.scrollView != nil && [self.scrollView respondsToSelector:@selector(setContentOffset:)]) {
                    self.offset = self.scrollView.contentOffset;
                }
            }
        }
        [self scrollToVisible];
    }    
    self.keyBorderShowing = YES;
}

- (void)handleKeyBorderWillHide:(NSNotification *)noti
{
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

- (BOOL)becomeFirstResponder
{
    if ( self.keyBorderShowing )
    {
        [self scrollToVisible];
    }
    else
    {
        self.offset = self.scrollView.contentOffset;
    }
    return [super becomeFirstResponder];
}


- (void)resetOffsetTrace
{
    self.offset = CGPointMake(0,MAXFLOAT);
}

@end



@implementation MiniUITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( [textField isKindOfClass:[MiniUITextField class]] )
    {
        MiniUITextField *tf = (MiniUITextField*)textField;
        
        if ((!tf.scrolled) && (tf.keyBoardVisible))
        {
            [tf scrollToVisible];
        }
        
        if ( tf.miniUITextFieldDelegate != nil )
        {
            if ( [tf.miniUITextFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) 
            {
                [tf.miniUITextFieldDelegate performSelector:@selector(textFieldDidBeginEditing:) withObject:textField];
            }
        }
    }    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ( [textField isKindOfClass:[MiniUITextField class]] )
    {
        MiniUITextField *tf = (MiniUITextField*)textField;
        if ( tf.miniUITextFieldDelegate != nil )
        {
            if ( [tf.miniUITextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) 
            {
                [tf.miniUITextFieldDelegate performSelector:@selector(textFieldDidEndEditing:) withObject:textField];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [textField isKindOfClass:[MiniUITextField class]] )
    {
        MiniUITextField *tf = (MiniUITextField*)textField;
        if ( tf.miniUITextFieldDelegate != nil )
        {
            if ( [tf.miniUITextFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) 
            {
                BOOL ret = [tf.miniUITextFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
                return ret;
            }
        }
    }

    if ( [string isEqualToString:@"\n"] )
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
