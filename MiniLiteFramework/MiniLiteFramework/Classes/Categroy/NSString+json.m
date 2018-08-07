//
// Created by Wuquancheng on 2018/7/17.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "NSString+json.h"


@implementation NSString (json)
- (id)jsonObject
{
    id info = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
    return info;
}
@end