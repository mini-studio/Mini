//
// Created by Wuquancheng on 2018/7/17.
// Copyright (c) 2018 Wuquancheng. All rights reserved.
//

#import "NSDictionary+MiniObject.h"
#import "NSArray+MiniObject.h"
#import "MiniObject.h"


@implementation NSDictionary (MiniObject)
- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSEnumerator *it = [self keyEnumerator];
    id key = nil;
    do  {
        key = [it nextObject];
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            [dic setValue:[(NSArray *)value jsonArray] forKey:key];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [dic setValue:[(NSDictionary *)value jsonDictionary] forKey:key];
        }
        else {
            if ([value isKindOfClass:[MiniObject class]]) {
                [dic setValue:[value dictionary] forKey:key];
            }
            else {
                [dic setValue:value forKey:key];
            }
        }
    }
    while (key != nil);
    return dic;
}
@end