//
// Created by Wuquancheng on 2018/7/20.
// Copyright (c) 2018 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Desc)
+ (NSError*)errorWithDescription:(NSString*)description code:(NSInteger)code;
+ (NSError*)errorWithDescription:(NSString*)description;
@end