//
//  MiniUIActionSheetPickerView.m
//  Mini
//
//  Created by wu quancheng on 12-5-27.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIActionSheetPickerView.h"

@implementation MiniUIActionToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
    }
    return self;
}

- (id)init
{
    if ( self = [super init] ) 
    {
        self.barStyle = UIBarStyleBlack;
        self.translucent = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}
@end

@interface MiniUIActionSheetPickerView()
{
    UIActionSheet *_actionSheet;
}
@end

@implementation MiniUIActionSheetPickerView

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.showsSelectionIndicator = YES;
    }   
    return self;
}

- (void)didmiss
{
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSArray *)buttonItems
{
    return nil;
}

- (void)showInView:(UIView*)view
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    _actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [_actionSheet addSubview:self]; 
    
    self.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 216);
    MiniUIActionToolbar *bar = [[MiniUIActionToolbar alloc] initWithFrame:CGRectMake(0.f, 0, [UIScreen mainScreen].bounds.size.width, 44.f)];    
    bar.items = [self buttonItems];
    [_actionSheet addSubview:bar];    
    [bar release];
    [_actionSheet showInView:view];
    [_actionSheet release];
}


@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface MiniSimpleUIActionSheetPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString* (^valueForIndexBlock)(id item);
    void (^doneBlock)(id item);
    NSArray *items;
    NSInteger selectedIndex;
}
@property (nonatomic,retain)NSArray *items;
@end


@implementation MiniSimpleUIActionSheetPickerView : MiniUIActionSheetPickerView
@synthesize items;
@synthesize selectedIndex;
- (id)init
{
    self = [super init];
    if ( self )
    {
        self.showsSelectionIndicator = YES;
        self.delegate = self;
    }   
    return self;
}

- (void)dealloc
{
    if ( valueForIndexBlock )
    {
        Block_release(valueForIndexBlock);
    }    
    if ( doneBlock )
    {
        Block_release(doneBlock);
    }
    [items release];
    [super dealloc];
}

- (void)setItems:(NSArray *)array valueForIndex:(NSString* (^)(id item))valueForIndex done:(void (^)(id item))done
{
    self.items = array;
    if ( valueForIndexBlock )
    {
        Block_release(valueForIndexBlock);
        valueForIndexBlock = nil;
    }
    valueForIndexBlock = Block_copy(valueForIndex);
    
    if ( doneBlock )
    {
        Block_release(doneBlock);
        doneBlock = nil;
    }
    doneBlock = Block_copy(done);
}

- (NSArray *)buttonItems
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" 
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self 
                                                                action:@selector(OKButtonClicked:)];
    UIBarButtonItem *fillItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *array = [NSArray arrayWithObjects:cancelItem, fillItem, doneItem, nil];
    [cancelItem release];
    [doneItem release];
    [fillItem release];
    return array;

}

- (void)cancelButtonClicked:(id)sender
{
    [self didmiss];
}

- (void)OKButtonClicked:(id)sender
{
    if ( doneBlock )
    {
        doneBlock([self.items objectAtIndex:selectedIndex]);
    }
    [self didmiss];
}

- (void)showInView:(UIView*)view
{
    [super showInView:view];
    [self selectRow:selectedIndex inComponent:0 animated:YES];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return valueForIndexBlock([self.items objectAtIndex:row]);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.items.count;
}
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MiniUIActionSheetDatePickerView() 
{
    UIActionSheet *_actionSheet;
    void (^doneblock)(NSDate *date);
}
@end

@implementation MiniUIActionSheetDatePickerView

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.datePickerMode = UIDatePickerModeDate;
    }   
    return self;
}

- (void)didmiss
{
    [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSArray *)buttonItems
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleBordered 
                                                                  target:self 
                                                                  action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" 
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self 
                                                                action:@selector(OKButtonClicked:)];
    UIBarButtonItem *fillItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *array = [NSArray arrayWithObjects:cancelItem, fillItem, doneItem, nil];
    [cancelItem release];
    [doneItem release];
    [fillItem release];
    return array;
}

- (void)showInView:(UIView*)view
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    _actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [_actionSheet addSubview:self]; 
    
    self.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 216);
    MiniUIActionToolbar *bar = [[MiniUIActionToolbar alloc] initWithFrame:CGRectMake(0.f, 0, [UIScreen mainScreen].bounds.size.width, 44.f)];    
    bar.items = [self buttonItems];
    [_actionSheet addSubview:bar];    
    [bar release];
    [_actionSheet showInView:view];
    [_actionSheet release];
}


- (void)dealloc
{
    if ( doneblock )
    {
        Block_release (doneblock);
    }
    [super dealloc];
}

- (void)setDoneBlock:(void (^)(NSDate *date))done def:(NSDate *)def
{
    if ( doneblock )
    {
        Block_release (doneblock);
        doneblock = nil;
    }
    if ( done )
    {
        doneblock = Block_copy(done);
    }
    self.date = def;
}

- (void)cancelButtonClicked:(id)sender
{
    [self didmiss];
}

- (void)OKButtonClicked:(id)sender
{
    if ( doneblock )
    {
        doneblock( self.date );
    }
    [self didmiss];
}


@end
