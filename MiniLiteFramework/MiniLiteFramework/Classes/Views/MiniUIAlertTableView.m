//
//  MiniUIAlertTableView.m
//  LS
//
//  Created by wu quancheng on 12-6-22.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniUIAlertTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MiniUIAlertTableView
@synthesize selectedIndex = _selectedIndex;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle
{
    self = [super initWithTitle:title message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
    _selectedIndex = -1;
    return self;       
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... 
{
    self = [super initWithTitle:title message:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    _selectedIndex = -1;
    if ( otherButtonTitles != nil )
    {
        [self addButtonWithTitle:otherButtonTitles];
        va_list arg_ptr; 		
        va_start ( arg_ptr, otherButtonTitles ); 
		
        NSString *p = va_arg( arg_ptr,NSString*);
        while ( p != nil ) 
        {
            [self addButtonWithTitle:p];
            p = va_arg( arg_ptr,NSString*);
        }		
        va_end(arg_ptr);
    }    
    return self;       
}



- (void)dealloc
{
    Block_release(selectedBlock);
    [_tableView release];
    [_items release];
    [super dealloc];
}


- (void)setItems:(NSArray *)items block:(void (^)(NSInteger selectedIndex, NSInteger buttonIndex ))block
{
    [items retain];
    [_items release];
    _items = items;
    if ( selectedBlock )
    {
        Block_release(selectedBlock);
    }
    if ( block )
    {
        selectedBlock = Block_copy(block);
    } 
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if ( _tableView == nil )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, self.width - 40, 30*5 + 10) style:UITableViewStylePlain];
        _tableView.bottom = self.height - 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableView.tableFooterView = tableFooterView;
        [tableFooterView release];
        [alertView addSubview:_tableView];
        [_tableView reloadData];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for ( UIView *view in self.subviews )
    {
        if ( [view isKindOfClass:[UIScrollView class]] )
        {
            if ( view != _tableView )
            {
                _tableView.frame = view.frame;
                _tableView.layer.cornerRadius = 4;
                view.hidden = YES;
                break;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != alertView.cancelButtonIndex )
    {
        if ( selectedBlock )
        {
            selectedBlock ( _selectedIndex , buttonIndex );
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( cell == nil )
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    if ( indexPath.row == _selectedIndex )
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *item = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _selectedIndex >= 0 )
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _selectedIndex = indexPath.row;
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
