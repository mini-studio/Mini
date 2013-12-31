//
//  MiniImagePickerUtil.h
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniImagePickerUtil : NSObject
@property (nonatomic) BOOL useEditeImage;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniImagePickerUtil)

- (void)pickerImage:(UIViewController *)controller title:(NSString*)title block:(void(^)(UIImage *image))block;

- (void)pickerImageFromCamera:(UIViewController *)controller block:(void(^)(UIImage *image))block;

- (void)pickerImageFromLib:(UIViewController *)controller block:(void(^)(UIImage *image))block;

@end
