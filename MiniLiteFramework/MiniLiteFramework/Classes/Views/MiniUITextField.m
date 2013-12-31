//
//  MiniUITextField.m
//  YContact
//
//  Created by wu quancheng on 11-10-1.
//  Copyright 2011年 Youlu. All rights reserved.
//

#import "MiniUITextField.h"

@interface MiniUITextField ()
{
    MiniUITextFieldDelegate *textFieldDelegate;
    id                      miniUITextFieldDelegate;
}

@property (nonatomic) CGPoint offset;
@property (nonatomic) BOOL keyBorderShowing;
@property (nonatomic) CGRect keyborderFrame;
@end

@implementation MiniUITextField
@synthesize userInfo;
@synthesize miniUITextFieldDelegate;
@synthesize scrolled = _scrolled;
@synthesize scrollview = _scrollview;

@synthesize offset = _offset;

@synthesize keyBorderShowing = _keyBorderShowing;
@synthesize keyborderFrame = _keyborderFrame;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)scrollView
{
    self = [self initWithFrame:frame];
    if ( self )
    {
        self.scrollview = scrollView;
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


- (void)initial
{
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.multipleTouchEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBorderWillHide:)name:UIKeyboardWillHideNotification object:nil];
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
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] )
    {
       [self initial];
    }
    return self;
}

- (void)scroollToVisible
{
    UIWindow *window = ([UIApplication sharedApplication].delegate).window;
    CGRect frame = [self.superview convertRect:self.frame toView:window];
    frame.origin.y += 10;
    CGFloat maxY = CGRectGetMaxY(frame);
    if( maxY > self.keyborderFrame.origin.y ) //below keyborder
    {
        CGPoint __offset = self.scrollview.contentOffset;
        __offset.y += (maxY - self.keyborderFrame.origin.y);
        [UIView animateWithDuration:0.30F animations:^{
            self.scrollview.contentOffset = __offset;
        }completion:^(BOOL finished) {
        }];
    }
    else if ( frame.origin.y < 20 )
    {
        CGPoint __offset = self.scrollview.contentOffset;
        __offset.y += 30;
        [UIView animateWithDuration:0.30F animations:^{
            self.scrollview.contentOffset = __offset;
        }completion:^(BOOL finished) {
        }];
    }
}

- (void)handleKeyBorderWillShow:(NSNotification *)noti
{
    CGRect keyborderFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyborderFrame = keyborderFrame;
    if ( [self isFirstResponder] )
    {
        [self scroollToVisible];
    }
    self.keyBorderShowing = YES;
}

- (void)handleKeyBorderWillHide:(NSNotification *)noti
{
    self.keyBorderShowing = NO;
    if ( self.offset.y != MAXFLOAT )
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollview.contentOffset = self.offset;
        }];
    }
    [self resetOffsetTrace];
}

- (BOOL)becomeFirstResponder
{
    if ( self.keyBorderShowing )
    {
        [self scroollToVisible];
    }
    else
    {
        self.offset = self.scrollview.contentOffset;
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
            [tf scroollToVisible];
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
