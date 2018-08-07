//
// Created by Wuquancheng on 2018/7/20.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "NSDictionary+Json.h"


@implementation NSDictionary (Json)
- (NSString*)jsonString
{
    NSError *error; 
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:nil error:&error];
    if (data != nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}
@end