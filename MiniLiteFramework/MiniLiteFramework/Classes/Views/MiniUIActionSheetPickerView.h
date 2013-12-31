//
//  HaloUIActionSheetPickerView.h
//  Mini
//
//  Created by wu quancheng on 12-5-27.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUIActionToolbar : UIToolbar

@end

@interface MiniUIActionSheetPickerView : UIPickerView<UIActionSheetDelegate>
- (void)didmiss;
- (void)showInView:(UIView*)view;
@end


@interface MiniSimpleUIActionSheetPickerView : MiniUIActionSheetPickerView
@property (nonatomic)NSInteger selectedIndex;
- (void)setItems:(NSArray *)array valueForIndex:(NSString* (^)(id item))valueForIndex done:(void (^)(id item))done;
@end


@interface MiniUIActionSheetDatePickerView : UIDatePicker<UIActionSheetDelegate>
- (void)setDoneBlock:(void (^)(NSDate *date))done def:(NSDate *)def;
- (void)showInView:(UIView*)view;
@end



