//
//  NSUserDefaults+Mini.m
//  MiniLiteFramework
//
//  Created by Wuquancheng on 13-7-14.
//  Copyright (c) 2013年 Wuquancheng. All rights reserved.
//

#import "NSUserDefaults+Mini.h"

@implementation NSUserDefaults (Mini)
- (void)setMiniObject:(MiniObject*)object forKey:(NSString*)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setValue:data forKey:key];
    [self synchronize];
}

- (MiniObject*)miniObjectValueforKey:(NSString *)key
{
    NSData *data = [self valueForKey:key];
    if ( data != nil )
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else
    {
        return nil;
    }
}

- (void)setString:(NSString*)string forKey:(NSString*)key
{
    [self setValue:string forKey:key];
    [self synchronize];
}

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)df
{
    NSString* v = [self valueForKey:key];
    if ( v == nil ) {
        return df;
    }
    return v;
}

@end
