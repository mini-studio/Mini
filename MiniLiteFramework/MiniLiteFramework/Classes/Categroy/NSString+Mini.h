//
//  NSString+Mini.h
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Mini.h"

@interface NSString(Mini)
- (NSString*)MD5String;
- (NSString*)trimSpaceAndReturn;
- (NSDate *)dataWithStyle:(DateStyle)style;
+ (NSString *)uuid;
+ (NSString *)unistring;

- (NSString*)base64Encode;
- (NSString*)base64Decode;

- (NSString*)EncryptWithKey:(NSString*)key;
- (NSString*)DecryptWithKey:(NSString*)key;

@end
