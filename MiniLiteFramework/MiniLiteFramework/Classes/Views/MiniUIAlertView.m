//
//  MiniUIAlertControl.m
//  Youlu
//
//  Created by wu quancheng on 12-3-14.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//
#define KMiniMainBundle [NSBundle mainBundle]
#define KALERT_BG_IMAGE_TAG 0xAB43001

#import "MiniUIAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface MiniUIAlertView() <UITextFieldDelegate>
{    
    BOOL      _flag;
    BOOL      _isModal;
    BOOL      _willPresent;
    BOOL      _revamped;
    NSMutableDictionary *_textFieldLengthDic;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
    UIAlertViewStyle alertViewStyle;
    NSMutableArray *_inputTextArray;
#endif
    
    void (^showTextFiledBlock)(MiniUIAlertView *alertView ,UITextField *showTextFiled);
    void (^alertBlock)(MiniUIAlertView *alertView , NSInteger index);
}
- (BOOL)runAsModal;
@end

@implementation MiniUIAlertView

#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
@synthesize alertViewStyle;

#endif
@synthesize backgroundImage = _backgroundImage;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    if ( _inputTextArray.count > textFieldIndex ) 
    {
        return [_inputTextArray objectAtIndex:textFieldIndex];
    }
    return nil;
}
#endif

- (id)init
{
    if ( self = [super init] )
    {
        _flag = NO;
        _isModal = NO;
        _revamped = NO;
    }
    return self;
}

- (void)dealloc
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
    [_inputTextArray release];
#endif
    [_textFieldLengthDic release];
    [_backgroundImage release];
    Block_release( alertBlock );
    Block_release( showTextFiledBlock);
    [super dealloc];
}

- (UIImage *)backgroundImage
{
    if ( _backgroundImage == nil )
    {
        _backgroundImage = [UIImage imageNamed:@"alter_view_background"];
        _backgroundImage = [[_backgroundImage stretchableImageWithLeftCapWidth:_backgroundImage.size.width/2
                                                                                     topCapHeight:_backgroundImage.size.height/2] retain];
    }
    return _backgroundImage;
}


- (BOOL)isButton:(UIView *)view
{
    return [view isKindOfClass:[UIButton class]] || [[[view class] description] isEqualToString:@"UIThreePartButton"];
}

- (void)adjustButtonFrame:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] )
    {
        view.frame = CGRectInset(view.frame, 8, 3);
    }    
}


- (void)setShowTextFiledBlock:(void (^)(MiniUIAlertView *alertView ,UITextField *showTextFiled))block
{
    if ( showTextFiledBlock )
    {
        Block_release(showTextFiledBlock);
        showTextFiledBlock = nil;
    }
    showTextFiledBlock = Block_copy( block );
}

- (void)show:(void (^)( MiniUIAlertView *alertView ,NSInteger index))block
{
    self.delegate = self;
    if ( block != nil )
    {
        alertBlock = Block_copy( block );
    }    
    [self show];
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
    if ( alpha == 0.0f )
    {
        if ( !_willPresent )
        {
            for ( UITextField *filed in _inputTextArray )
            {
                [filed resignFirstResponder];
            }
        }        
    }
#endif
}

- (void)setMaxLength:(NSInteger)length forTextField:(UITextField *)field
{
    field.delegate = self;
    if ( _textFieldLengthDic == nil )
    {
        _textFieldLengthDic = [[NSMutableDictionary alloc] init];
        [_textFieldLengthDic setValue:[NSNumber numberWithInt:length] forKey:[NSString stringWithFormat:@"%d",field.tag]];
    }
}

- (void)enableButtonWithTitle:(NSString *)title enable:(BOOL)enabel
{
    for ( UIView *view in self.subviews )
    {
        if ( [self isButton:view] )
        {
            if ( [view isKindOfClass:[UIButton class]] )
            {
                NSString *_btitle = [(UIButton *)view titleLabel].text;
                if ( [_btitle isEqualToString:title])
                {
                    ((UIButton *)view).enabled = enabel;
                }
            }
            
        }
    }
}

- (void)enableButtonWithIndex:(NSInteger)index enable:(BOOL)enabel
{
    NSString *title = [self buttonTitleAtIndex:index];
    [self enableButtonWithTitle:title enable:enabel];
}

- (BOOL)runAsModal
{
    self.delegate = self;
    _isModal = YES;
    [self show];
    CFRunLoopRun();
    return _flag;
}

+ (void)showAlertTipWithTitle:(NSString*) title message:(NSString*) message block:(void (^)(MiniUIAlertView *alertView ,NSInteger index))block
{
    MiniUIAlertView *alert = [[MiniUIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show:block];
    [alert release];
}

+ (void)showAlertWithTitle:(NSString*) title message:(NSString*) message block:(void (^)(MiniUIAlertView *alertView ,NSInteger index))block cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:otherButtonTitle, ...
{
    MiniUIAlertView *alert = [[MiniUIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
    if ( otherButtonTitle != nil )
    {
        [alert addButtonWithTitle:otherButtonTitle];
        va_list arg_ptr; 		
        va_start ( arg_ptr, otherButtonTitle ); 
		
        NSString *p = va_arg( arg_ptr,NSString*);
        while ( p != nil ) 
        {
            [alert addButtonWithTitle:p];
            p = va_arg( arg_ptr,NSString*);
        }		
        va_end(arg_ptr);
    }    
    [alert show:block];
    [alert release];
}

+ (BOOL)showModalAlertTipWithTitle:(NSString*) title message:(NSString *)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle
{
    MiniUIAlertView *alert = [[[MiniUIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil] autorelease];
    return [alert runAsModal];
}

+ (void)showAlertWithMessage:(NSString*)message
{
    MiniUIAlertView *alert = [[MiniUIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show:nil];
    [alert release];
}

+ (void)showAlertWithMessage:(NSString*)message title:(NSString *)title
{
    MiniUIAlertView *alert = [[MiniUIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show:nil];
    [alert release];
}

@end

@implementation MiniUIAlertView(delegate)

- (void)resetSystemBackGroundImage:(UIAlertView *)alertView
{
    if ( self.backgroundImage )
    {
        for (UIView *view in alertView.subviews )
        {
            if ( self.alertViewStyle == UIAlertViewStyleDefault )
            {
                if ( [self isButton:view] )
                {
                    [self adjustButtonFrame:view];
                    continue;
                }
            }
            if ( [view isKindOfClass:[UIImageView class]] )
            {
                if ( view.frame.size.height == self.frame.size.height )
                {
                    UIImageView *imageView = (UIImageView *)[self viewWithTag:KALERT_BG_IMAGE_TAG];
                    if ( imageView == nil )
                    {
                        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
                        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                        imageView.image = self.backgroundImage;
                        imageView.tag = KALERT_BG_IMAGE_TAG;
                        [self insertSubview:imageView aboveSubview:view];
                        [imageView release];
                        view.hidden = YES;
                    }
                    imageView.frame = self.bounds;
                }

            }
            
        }
    }
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
- (void)addTextViewWithStyle:(UIAlertViewStyle )style
{
    if ( _inputTextArray == nil )
    {
        _inputTextArray = [[NSMutableArray array] retain];
    }
    [_inputTextArray removeAllObjects];
    NSInteger inputsHeight = 30;
    NSInteger inputHeight = 30;
    if ( style == UIAlertViewStyleLoginAndPasswordInput ) 
    {
        inputsHeight = 62;
        NSInteger height = self.height + inputsHeight;
        self.height = height;
        CGRect frame = CGRectMake( 20, ( self.height - inputHeight  - 60 - 5 ) , self.width - 40 , inputHeight );
        UITextField *field = [[UITextField alloc] initWithFrame:frame];
        field.placeholder = @"Password";
        [self addSubview:field]; 
        [_inputTextArray addObject:field];
        [field release];        
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.secureTextEntry = YES;
        field.delegate = self;
        
        frame.origin.y = field.top - inputHeight - 2;
        field = [[UITextField alloc] initWithFrame:frame];
        field.placeholder = @"Name";
        [self addSubview:field];
        field.delegate = self;
        [_inputTextArray insertObject:field atIndex:0];
        field.borderStyle = UITextBorderStyleRoundedRect;
        [field release];        
    }
    
    else if ( style == UIAlertViewStylePlainTextInput || style == UIAlertViewStyleSecureTextInput ) 
    {
        self.height += inputsHeight;
        CGRect frame = CGRectMake( 20, ( self.height - inputHeight )/2-5 , self.width - 40 , inputHeight );
        UITextField *field = [[UITextField alloc] initWithFrame:frame];
        [self addSubview:field]; 
        field.delegate = self;
        [_inputTextArray addObject:field];
        [field release];
        if ( style == UIAlertViewStyleSecureTextInput )
        {
            field.secureTextEntry = YES;
        }
    }
    
    for (UIView *view in self.subviews )
    {
        if ( [self isButton:view] )
        {
            view.top += inputsHeight;
        }
    }
}
#endif

- (void)resetTextField:(MiniUIAlertView *)alertView
{
    if ( self.alertViewStyle != UIAlertViewStyleDefault ) 
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
        [self addTextViewWithStyle:self.alertViewStyle];
#endif
        if ( self.alertViewStyle != UIAlertViewStyleLoginAndPasswordInput ) 
        {
            UITextField *textField = [alertView textFieldAtIndex:0];
            for (UIView *view in alertView.subviews )
            {
                if ( [view isKindOfClass:[UITextField class]] ) 
                {
                    continue;
                }
                else if ( [self isButton:view] )
                {
                    [self adjustButtonFrame:view];
                }
                else
                {
                    if ( fabs(view.frame.size.height - textField.frame.size.height) < 5 && fabs(view.frame.size.width - textField.frame.size.width))
                    {
                        view.hidden = YES;
                    }
                }
            }
            textField.top -= 5;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            
            if ( showTextFiledBlock )
            {
                textField.tag = 0xA000001;
                textField.keyboardAppearance = UIKeyboardAppearanceDefault;
                showTextFiledBlock(self,textField);
            }
        }
        else
        {
            for (UIView *view in alertView.subviews )
            {
               if ( [self isButton:view] )
               {
                    [self adjustButtonFrame:view];
               }
            }
            UITextField *textField0 = [alertView textFieldAtIndex:0];
            UITextField *textField1 = [alertView textFieldAtIndex:1];
            if ( showTextFiledBlock )
            {
                textField0.tag = 0xA000001;
                textField0.keyboardAppearance = UIKeyboardAppearanceDefault;
                showTextFiledBlock(self,textField0);
                textField1.tag = 0xA000002;
                textField1.keyboardAppearance = UIKeyboardAppearanceDefault;
                showTextFiledBlock(self,textField1);
            }
        }
    }
}

- (void)willPresentAlertView:(MiniUIAlertView *)alertView
{   
    if ( !_revamped ) 
    {
        [self resetSystemBackGroundImage:alertView];
        [self resetTextField:alertView];
        _revamped = YES;
    }
    _willPresent = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < MAX_ALLOWED_VERSION
    if ( _inputTextArray.count > 0 )
    {
        [[_inputTextArray objectAtIndex:0] becomeFirstResponder];
        [UIView animateWithDuration:0.20 animations:^{
            self.top = 50; 
        }];
    }
#endif
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    _willPresent = NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSNumber *length = [_textFieldLengthDic valueForKey:[NSString stringWithFormat:@"%d",textField.tag]];
    if ( length != nil )
    {
        if (string.length == 1 && [string characterAtIndex:0] == '\n')
        {
            return NO;
        }        
        NSInteger newLength = textField.text.length - range.length + string.length;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 50000
        if ( textField == [self textFieldAtIndex:0] )
        {
            [self enableButtonWithIndex:self.cancelButtonIndex + 1 enable:(newLength>0)];
        }        
#endif        
        if ( newLength > length.intValue )
        {
            return NO;
        }         
        return YES;
    }
    return YES;
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if ( alertBlock ) 
//    {
//        alertBlock( (MiniUIAlertView*)alertView , buttonIndex);
//        alertView.delegate = nil;
//    }
//    if ( _isModal )
//    {
//        _flag = ( buttonIndex != alertView.cancelButtonIndex );
//        alertView.delegate = nil;
//        CFRunLoopStop(CFRunLoopGetCurrent());
//    }
//}
//
//- (void)alertViewCancel:(UIAlertView *)alertView
//{
//    if ( alertBlock ) 
//    {
//        alertBlock( (MiniUIAlertView*)alertView, alertView.cancelButtonIndex);
//    }
//    if ( _isModal )
//    {
//        _flag = NO;
//        alertView.delegate = nil;
//        CFRunLoopStop(CFRunLoopGetCurrent());
//    }
//}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( alertBlock ) 
    {
        alertBlock( (MiniUIAlertView*)alertView , buttonIndex);
        alertView.delegate = nil;
    }
    if ( _isModal )
    {
      _flag = NO;
      alertView.delegate = nil;
      CFRunLoopStop(CFRunLoopGetCurrent());
    }
}

@end

@implementation MiniUIAlertView(input)

- (BOOL)alertViewShouldEnableFirstOtherButton:(MiniUIAlertView *)alertView
{
    if ( self.alertViewStyle != UIAlertViewStyleDefault )
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        return ( textField.text.length > 0 );
    }
    return YES;    
}

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle showTextFiledBlock:(void (^)(MiniUIAlertView *alertView ,UITextField * showTextFiled))showTextFiledBlock block:(void (^)(MiniUIAlertView *alertView ,NSInteger index))block
{
    [self showInputAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle style:UIAlertViewStylePlainTextInput showTextFiledBlock:showTextFiledBlock block:block];
}

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString*) message cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle style:(UIAlertViewStyle)style showTextFiledBlock:(void (^)(MiniUIAlertView *alertView ,UITextField * showTextFiled))showTextFiledBlock block:(void (^)(MiniUIAlertView *alertView ,NSInteger index))block
{
    MiniUIAlertView *alert = [[MiniUIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
    alert.alertViewStyle = style;
    [alert setShowTextFiledBlock:showTextFiledBlock];
    [alert show:block];
    [alert release];
}
@end
