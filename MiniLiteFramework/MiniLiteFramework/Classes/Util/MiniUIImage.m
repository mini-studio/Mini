//
//  MiniUIImage.m
//  LS
//
//  Created by wu quancheng on 12-6-11.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniUIImage.h"
#import "UIDevice+Ext.h"

@implementation MiniUIImage
+ (UIImage *)imagePreciseNamed:(NSString *)name ext:(NSString *)ext
{
    if ( IS_IPHONE5 )
    {
        name = [NSString stringWithFormat:@"%@-568h",name];
    }
    if ( ![@"png" isEqualToString:ext] )
    {
        name = [NSString stringWithFormat:@"%@.%@",name,ext];
    }
    return [UIImage imageNamed:name];
}
@end
