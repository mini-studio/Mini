//
//  MiniUIAlertTableView.h
//  LS
//
//  Created by wu quancheng on 12-6-22.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUIAlertTableView : UIAlertView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_items;
    void (^selectedBlock)(NSInteger selectedIndex, NSInteger buttonIndex );
    UITableView *_tableView;
    NSInteger _selectedIndex;
}

@property (nonatomic)NSInteger selectedIndex;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;



- (void)setItems:(NSArray *)items block:(void (^)(NSInteger selectedIndex , NSInteger buttonIndex ))block;
@end
