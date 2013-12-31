//
//  NSUserDefaults+Mini.h
//  MiniLiteFramework
//
//  Created by Wuquancheng on 13-7-14.
//  Copyright (c) 2013年 Wuquancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniObject.h"

@interface NSUserDefaults (Mini)
- (void)setMiniObject:(MiniObject*)object forkey:(NSString*)key;

- (MiniObject*)miniObjectValueForKey:(NSString *)key;

- (void)setString:(NSString*)string forkey:(NSString*)key;

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)df;

@end
