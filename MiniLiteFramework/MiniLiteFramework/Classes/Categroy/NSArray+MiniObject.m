//
// Created by Wuquancheng on 2018/7/17.
// Copyright (c) 2018 Wuquancheng. All rights reserved.
//

#import "NSArray+MiniObject.h"
#import "NSDictionary+MiniObject.h"
#import "MiniObject.h"


@implementation NSArray (MiniObject)
- (NSArray *)jsonArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for(int index = 0; index < self.count; index++) {
        id v = [self objectAtIndex:index];
        if ([v isKindOfClass:[NSArray class]]) {
            v = [(NSArray*)v jsonArray];
        }
        else if ([v isKindOfClass:[NSDictionary class]]) {
            v =  [(NSDictionary*)v jsonDictionary];
        }
        if ([v isKindOfClass:[MiniObject class]]) {
            [arr addObject:[v dictionary]];
        }
        else {
            [arr addObject:v];
        }
    }
    return arr;
}
@end