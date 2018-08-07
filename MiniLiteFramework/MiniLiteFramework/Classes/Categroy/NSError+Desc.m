//
// Created by Wuquancheng on 2018/7/20.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "NSError+Desc.h"


@implementation NSError (Desc)
+ (NSError*)errorWithDescription:(NSString*)description code:(NSInteger)code
{
    return [NSError errorWithDomain:@"ErrorDomain"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey : description}];
}

+ (NSError*)errorWithDescription:(NSString*)description
{
    return [NSError errorWithDomain:@"ErrorDomain"
                               code:500
                           userInfo:@{NSLocalizedDescriptionKey : description}];
}
@end