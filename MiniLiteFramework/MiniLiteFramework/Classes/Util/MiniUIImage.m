//
//  MiniUIImage.m
//  LS
//
//  Created by wu quancheng on 12-6-11.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniUIImage.h"
#import "UIDevice+Ext.h"

@implementation MiniUIImage
+ (UIImage *)imagePreciseNamed:(NSString *)name ext:(NSString *)ext
{
    NSString *n = name;
    if ( IS_IPHONE5 )
    {
        name = [NSString stringWithFormat:@"%@-568h",name];
    }
    if ( ![@"png" isEqualToString:ext] )
    {
        name = [NSString stringWithFormat:@"%@.%@",name,ext];
    }
    UIImage *image = [UIImage imageNamed:name];
    if (image == nil) {
        name = [NSString stringWithFormat:@"%@.%@",n,ext];
    }
    image = [UIImage imageNamed:name];
    return image;
}
@end
