//
//  HaloUIAlertControl.m
//  TestArc
//
//  Created by Wuquancheng on 12-12-1.
//  Copyright (c) 2012年 youlu. All rights reserved.
//

#import "MiniUIAlertControl.h"

#define KALERTVIEW_WIDTH 284
#define KTITLE_FONT_SIZE 18
#define KKESSAGE_FONT_SIZE 18
#define KBUTTON_FONT_SIZE 16
#define K_GAP           10
#define K_TOPGAP        30
#define KLEFT_GAP          20
#define KButtonTagStart    0xaaaaa01

#ifdef  __ARC__
#define HARelease(v) do {} while(0)
#define HAAutorelease(v) do {} while(0)
#define HARetain (v) do {} while(0)
#define HASuperDealloc do {} while(0)

#else
#define HARelease(v) do { [v release]; } while(0)
#define HAAutorelease(v) do {[v autorelease];} while(0)
#define HARetain (v) do {[v retain];} while(0)
#define HASuperDealloc do {[super dealloc];} while(0)
#endif

typedef enum
{
  EBUTTON_CANCEL,
  EBUTTON_DESTRUCTIVE,
  EBUTTON_OTHER
}
ALERT_BUTTON_TYPE;


@interface MiniUIAlertControl ()

@property (nonatomic,strong)UIImageView *hBackground;

@property (nonatomic,strong)UILabel *hTitleLabel;
@property (nonatomic,strong)UILabel *hMessageLabel;
@property (nonatomic,strong)UIButton *hCancelButton;
@property (nonatomic,strong)UIButton *hDestructiveButton;
@property (nonatomic,strong)NSArray  *hOtherButtons;

@property (nonatomic,strong)UIView  *buttonsView;
@property (nonatomic,strong)UIView  *contentView;

@property (nonatomic)CGSize hTitleSize;
@property (nonatomic)CGSize hMessageSize;

@property (nonatomic,retain)NSMutableDictionary *buttonImagesDic;

@property (nonatomic,copy)void(^callback)(MiniUIAlertControl* control, NSInteger buttonIndex );
@property (nonatomic,copy)void(^willShow)(MiniUIAlertControl* control);

@end



@implementation MiniUIAlertControl
+ (MiniUIAlertControl *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle  willShow:(void (^)(MiniUIAlertControl* alertView))willShow block:(void (^)( MiniUIAlertControl* control, NSInteger buttonIndex)) block
{
    MiniUIAlertControl *alertControl = [[MiniUIAlertControl alloc] initWithTitle:title message:message cancelButton:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitleArrays:(otherButtonTitle==nil?nil:@[otherButtonTitle])];
    alertControl.willShow = willShow;
    [alertControl show:block];
    HARelease(alertControl);
    return alertControl;
}

+ (MiniUIAlertControl *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    MiniUIAlertControl *alertControl = [[MiniUIAlertControl alloc] initWithTitle:title message:message cancelButton:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitleArrays:(otherButtonTitle==nil?nil:@[otherButtonTitle])];
    HAAutorelease(alertControl);
    return alertControl;
}

#pragma mark - prepare for alert view 

+ (void)prepareWithTitle:(NSString *)title message:(NSString *)message outString:(NSString **)outString titleSize:(CGSize*)titleSize messageSize:(CGSize *)messageSize
{
    CGFloat labelWidth = KALERTVIEW_WIDTH - 2*KLEFT_GAP;
    CGFloat totalHeight = K_TOPGAP;
    if ( title != nil && title.length > 0 )
    {
        UIFont *font = [UIFont boldSystemFontOfSize:KTITLE_FONT_SIZE];
        CGFloat titleHeight = [title sizeWithFont:font constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        totalHeight += titleHeight;
        (*titleSize).width = labelWidth;
        (*titleSize).height = titleHeight;
    }
    if ( message != nil && message.length > 0 )
    {
        UIFont *font = [UIFont systemFontOfSize:KKESSAGE_FONT_SIZE];
        CGFloat messageHeight = [message sizeWithFont:font constrainedToSize:CGSizeMake(labelWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        if ( totalHeight != K_GAP )
        {
            totalHeight += K_GAP;
        }
        totalHeight += messageHeight;
        (*messageSize).width = labelWidth;
        (*messageSize).height = messageHeight;
    }
    totalHeight += K_GAP;
    NSInteger numberofrn = totalHeight/KKESSAGE_FONT_SIZE;
    NSMutableString *string = [NSMutableString string];
    for (NSInteger index = 0; index <numberofrn; index++ )
    {
        [string appendFormat:@"\n"];
    }
    *outString = string;
    
}

#pragma mark - init alert view

- (id)init
{
    if ( self = [super init] )
    {
        self.buttonImagesDic = [NSMutableDictionary dictionary];
        [self initButtonsImage];
    }
    return self;
}

- (MiniUIAlertControl *)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle  destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    NSString *outString = nil;
    CGSize titleSize = CGSizeZero,messageSize = CGSizeZero;
    [MiniUIAlertControl prepareWithTitle:title message:message outString:&outString titleSize:&titleSize messageSize:&messageSize];
    if ( self = [super initWithTitle:nil message:outString delegate:self cancelButtonTitle:nil otherButtonTitles:nil])
    {
        NSMutableArray *array = nil;
        if ( otherButtonTitles != nil )
		{
            array = [NSMutableArray array];
            [array addObject:otherButtonTitles];
			va_list arg_ptr;
			va_start ( arg_ptr, otherButtonTitles );
            
			NSString *p = va_arg( arg_ptr,NSString*);
			while ( p != nil )
			{
				[array addObject:p];
				p = va_arg( arg_ptr,NSString*);
			}
			va_end(arg_ptr);
		}
        [self initWithTitle:title message:message cancelButton:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:array titleSize:titleSize messageSize:messageSize];
		
    }
    return self;
}

- (MiniUIAlertControl *)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle  destructiveButtonTitle:(NSString *)destructiveButtonTitle  otherButtonTitleArrays:(NSArray *)otherButtonTitleArrays
{
    NSString *outString = nil;
    CGSize titleSize = CGSizeZero,messageSize = CGSizeZero;
    [MiniUIAlertControl prepareWithTitle:title message:message outString:&outString titleSize:&titleSize messageSize:&messageSize];
    if ( self = [super initWithTitle:nil message:outString delegate:self cancelButtonTitle:nil otherButtonTitles:nil])
    {
        [self initWithTitle:title message:message cancelButton:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitleArrays titleSize:titleSize messageSize:messageSize];
    }
    return self;
}

- (void)dealloc
{
    HARelease(_hBackground);
    HARelease(_hTitleLabel);
    HARelease(_hMessageLabel);
    HARelease(_hCancelButton);
    HARelease(_hDestructiveButton);
    HARelease(_hOtherButtons);
    HARelease(_buttonsView);
    HARelease(_contentView);
    HARelease(_buttonImagesDic);
    HARelease(_callback);
    HARelease(_willShow);
    HASuperDealloc;
}

#pragma mark - contruct label

- (UILabel *)labelWithFont:(UIFont *)font frame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    HAAutorelease(label);
    return label;
}

#pragma - mark ui imag style

- (NSString *)backGroundName
{
    return @"dialog/dialog_bg";
}

- (void)initButtonsImage
{
    [self.buttonImagesDic removeAllObjects];
    [self.buttonImagesDic setObject:@{[NSNumber numberWithInt:UIControlStateNormal]:@"dialog/dialog_btn_graw_normal",[NSNumber numberWithInt:UIControlStateHighlighted]:@"dialog/dialog_btn_graw_pressed",
     } forKey:[NSNumber numberWithInt:EBUTTON_CANCEL]];
    
    [self.buttonImagesDic setObject:@{[NSNumber numberWithInt:UIControlStateNormal]:@"dialog/dialog_btn_red_normal",[NSNumber numberWithInt:UIControlStateHighlighted]:@"dialog/dialog_btn_red_pressed",
     } forKey:[NSNumber numberWithInt:EBUTTON_DESTRUCTIVE]];
    
    
    [self.buttonImagesDic setObject:@{[NSNumber numberWithInt:UIControlStateNormal]:@"dialog/dialog_btn_green_normal",[NSNumber numberWithInt:UIControlStateHighlighted]:@"dialog/dialog_btn_green_pressed",
     } forKey:[NSNumber numberWithInt:EBUTTON_OTHER]];
}


- (void)setTitleColor:(UIColor *)color messageColor:(UIColor *)messageColor cancelButtonTitleColor:(UIColor *)cancelButtonTitleColor destructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor otherButtonTitleColor:(UIColor *)otherButtonTitleColor
{
    self.hTitleLabel.textColor = color;
    self.hMessageLabel.textColor = messageColor;
    for ( UIButton *button in self.buttonsView.subviews )
    {
        if ( button == self.hCancelButton )
        {
            [button setTitleColor:cancelButtonTitleColor forState:UIControlStateNormal];
        }
        else if ( button == self.hDestructiveButton )
        {
            [button setTitleColor:destructiveButtonTitleColor forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:otherButtonTitleColor forState:UIControlStateNormal];
        }
    }
}

- (UIImage *)imageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName];
}

#pragma mark - contruct button

- (NSString *)buttonImageNameForState:(UIControlState)state buttonType:(ALERT_BUTTON_TYPE)buttonType
{
    return [[self.buttonImagesDic objectForKey:[NSNumber numberWithInt:buttonType]] objectForKey:[NSNumber numberWithInt:state]];
}

- (UIButton *)buttonWithTitle:(NSString *)title backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [self imageNamed:backgroundImageName];
    CGFloat top = image.size.height / 2;
    CGFloat left = image.size.width / 2;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [self imageNamed:highlightedBackgroundImageName];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left)];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:KBUTTON_FONT_SIZE]];
    button.frame = CGRectMake(0, 0, 0, image.size.height);
    return button;
}

#pragma mark - init sub views

- (void)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButtonTitle  destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles  titleSize:(CGSize)titleSize messageSize:(CGSize)messageSize
{
    self.hTitleSize = titleSize;
    self.hMessageSize = messageSize;
    [self initViewsWithTitle:title message:message cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles];
}

- (void)initViewsWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    
    UIImage *image = [self imageNamed:[self backGroundName]];
    CGFloat v = image.size.height/2;
    CGFloat h = image.size.width/2;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(v, h, v, h)];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:image];
    self.hBackground = bgView;
    [self addSubview:self.hBackground];
    HARelease(bgView);
    self.hBackground.userInteractionEnabled = YES;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    self.contentView = contentView;
    [self.hBackground addSubview:contentView];
    HARelease(contentView);
    
    if ( title.length > 0 )
    {
        self.hTitleLabel = [self labelWithFont:[UIFont boldSystemFontOfSize:KTITLE_FONT_SIZE] frame:CGRectMake(0, 0, self.hTitleSize.width, self.hTitleSize.height) text:title];
        [self.contentView addSubview:self.hTitleLabel];
    }
    if ( message.length >0 )
    {
        self.hMessageLabel = [self labelWithFont:[UIFont systemFontOfSize:KKESSAGE_FONT_SIZE] frame:CGRectMake(0, 0, self.hMessageSize.width, self.hMessageSize.height) text:message];
        [self.contentView addSubview:self.hMessageLabel];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    self.buttonsView = view;
    HARelease(view);
    [self.contentView addSubview:self.buttonsView];
    NSInteger tag = KButtonTagStart;
    if ( cancelButtonTitle.length > 0 )
    {
        self.hCancelButton = [self buttonWithTitle:cancelButtonTitle backgroundImageName:[self buttonImageNameForState:UIControlStateNormal buttonType:EBUTTON_CANCEL] highlightedBackgroundImageName:[self buttonImageNameForState:UIControlStateHighlighted buttonType:EBUTTON_CANCEL]];
        self.hCancelButton.tag = tag++;
        [self.hCancelButton addTarget:self action:@selector(actionForButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:self.hCancelButton];
    }
    
    if ( destructiveButtonTitle.length > 0 )
    {
        self.hDestructiveButton = [self buttonWithTitle:destructiveButtonTitle backgroundImageName:[self buttonImageNameForState:UIControlStateNormal buttonType:EBUTTON_DESTRUCTIVE] highlightedBackgroundImageName:[self buttonImageNameForState:UIControlStateHighlighted buttonType:EBUTTON_DESTRUCTIVE]];
        self.hDestructiveButton.tag = tag++;
        [self.hDestructiveButton addTarget:self action:@selector(actionForButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:self.hDestructiveButton];
    }
    
    if ( otherButtonTitles.count > 0 )
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:otherButtonTitles.count];
        for ( NSString *title in otherButtonTitles )
        {
            UIButton *button = [self buttonWithTitle:title backgroundImageName:[self buttonImageNameForState:UIControlStateNormal buttonType:EBUTTON_OTHER] highlightedBackgroundImageName:[self buttonImageNameForState:UIControlStateHighlighted buttonType:EBUTTON_OTHER]];
            button.tag = tag++;
            [array addObject:button];
            [button addTarget:self action:@selector(actionForButtonTap:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsView addSubview:button];
        }
        self.hOtherButtons = array;
    }
    
}

#pragma mark - layout sub views 

- (void)layoutHSubViews
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width - 2*KLEFT_GAP, 0);
    if ( self.hTitleLabel != nil )
    {
        frame = CGRectMake(frame.origin.x, frame.origin.y, self.hTitleLabel.frame.size.width, self.hTitleLabel.frame.size.height);
        self.hTitleLabel.frame = frame;
        frame.origin.y = CGRectGetMaxY(frame) + K_GAP;
    }
    if ( self.hMessageLabel != nil )
    {
        frame = CGRectMake(frame.origin.x, frame.origin.y, self.hMessageLabel.frame.size.width, self.hMessageLabel.frame.size.height);
        self.hMessageLabel.frame = frame;
        frame.origin.y = CGRectGetMaxY(frame) + K_GAP;
    }
    
    NSInteger buttonsCount = self.buttonsView.subviews.count;
    if (  buttonsCount > 0  )
    {
        NSInteger buttonsCount = self.buttonsView.subviews.count;
        CGFloat buttonHeight = ((UIButton*)[self.buttonsView.subviews objectAtIndex:0]).frame.size.height;
        frame = CGRectMake( 0 ,  frame.origin.y  + KLEFT_GAP, self.frame.size.width - 2*KLEFT_GAP, buttonHeight);
        self.buttonsView.frame = frame;
        CGFloat buttonWidth = (frame.size.width - (buttonsCount-1)*KLEFT_GAP)/buttonsCount;
        for ( NSInteger index = 0; index < buttonsCount; index ++  )
        {
            UIButton *button = (UIButton *)[self.buttonsView.subviews objectAtIndex:index];
            button.frame = CGRectMake(index *(buttonWidth + KLEFT_GAP) , 0, buttonWidth, buttonHeight);
        }
    }
    NSInteger top = K_TOPGAP;
    self.contentView.frame = CGRectMake(KLEFT_GAP, top, frame.size.width, CGRectGetMaxY(frame));
    self.hBackground.frame = CGRectMake(0, 0, self.bounds.size.width,  CGRectGetMaxY(self.contentView.frame) + KLEFT_GAP);
    if ( self.willShow )
    {
        self.willShow( self );
    }
}

#pragma mark - delegate method for UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}

- (void)willPresentAlertView:(UIAlertView *)alertView // before animation and showing view
{
    for (UIView *v in [alertView subviews] )
    {
        if ( v != self.hBackground )
        {
            [v removeFromSuperview];
        }
    }
    [self layoutHSubViews];
}

- (void)didPresentAlertView:(UIAlertView *)alertView  // after animation
{
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex // before animation and hiding view
{
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    if ( self.callback )
    {
        self.callback(self,buttonIndex);
    }
}

- (NSInteger)cancelButtonIndex
{
    return 0;
}

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
}

#pragma mark - action for button 

- (void)actionForButtonTap:(UIButton *)button
{
    [self dismissWithClickedButtonIndex:(button.tag - KButtonTagStart) animated:YES];
}


#pragma mark - show alert view with block
- (void)show:(void (^)( MiniUIAlertControl* control, NSInteger buttonIndex)) block
{
    self.callback = block;
    [self show];
}

@end
