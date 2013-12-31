//
//  LSEmojiCodeUtil.h
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct 
{
    //	NSString*   emotionString;
    NSInteger code;
	NSString  *name;
} EmojiKey;



@interface MiniEmojiCodeUtil : NSObject

+ (NSString *)nameWithCode:(NSString *)code;

+ (NSString *)encodeString:(NSString *)string;

+ (UIImage *)emojiWithCode:(NSString *)code;

+ (BOOL)isEmojiCode:(NSString *)code;

@end
