//
//  UIImage+Mini.h
//  LS
//
//  Created by wu quancheng on 12-6-11.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Mini)
+ (UIImage*)imageWithFilePath:(NSString*)fpath;

- (UIImage*)scaleToSize:(CGSize)size;

- (CGSize)sizeForScaleToFixSize:(CGSize)aSize;

- (UIImage*)scaleToFixSize:(CGSize)size;

- (UIImage*)scaleToFixSizeIgnoreScale:(CGSize)aSize;

- (UIImage*)clipImageToSize:(CGSize)size;

- (UIImage *)convertToGrayscale;

- (UIImage*)imageUseMask:(UIImage*)mask ;

- (UIImage*)mirrorImage;

- (UIImage*)clipImageFrom:(CGFloat)left width:(CGFloat)width;

- (UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

- (UIImage*)imageMerged:(UIImage*)image;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage insetSize:(CGSize)insetSize size:(CGSize)size;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage;

+ (UIImage*)imageMerged:(UIImage*)image withTopImage:(UIImage*)topImage offset:(CGPoint)offset;

- (UIImage*)imageMergedWithBg:(UIImage*)image expandSize:(CGSize)expandSize offset:(CGPoint)offset;

- (UIImage *)roundCorner;

- (UIImage*)scaleAndRotateImage:(CGSize)targetSize;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
