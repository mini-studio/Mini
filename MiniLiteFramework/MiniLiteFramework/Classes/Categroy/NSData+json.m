//
// Created by Wuquancheng on 2018/7/17.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "NSData+json.h"


@implementation NSData (json)
- (id)jsonObject
{
    id info = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
    return info;
}
@end