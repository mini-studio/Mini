//
//  MiniUIActionSheet.h
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiniUIActionSheet : UIActionSheet

- (void)setBlock:(void (^)(MiniUIActionSheet *ach, NSInteger buttonIndex))block;
@end
