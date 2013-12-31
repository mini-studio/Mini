//
//  UIGroupButtonView.h
//  bake
//
//  Created by Wuquancheng on 12-10-27.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    MiniUISegmentViewStyleSeg,
    MiniUISegmentViewStyleGroup,
};

typedef int MiniUISegmentViewStyle;

@interface MiniUISegmentView : UIView


@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic,retain) UIImageView *backgroudView;
@property (nonatomic,retain) UIImageView *slidderImageView;
@property (nonatomic) MiniUISegmentViewStyle viewStyle;
@property (nonatomic, retain) UIColor *separatorColor;
@property (nonatomic, retain) UIImage *backGroundImage;
@property (nonatomic, retain) UIImage *slidderImage;

- (void)setItems: (NSArray *) array;

- (void)setItems: (NSArray *) array block:(id(^)(int index, NSString *attri))block;

- (UIButton *)buttonAtIndex:(NSInteger)index;

- (void)setTarget:(id)target selector:(SEL)selector;

@end
