//
// Created by Wuquancheng on 2018/8/2.
// Copyright (c) 2018 Wuquancheng. All rights reserved.
//

#import "MiniApp.h"


@implementation MiniApp
+ (NSString*)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString*)appBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
+ (NSString*)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end