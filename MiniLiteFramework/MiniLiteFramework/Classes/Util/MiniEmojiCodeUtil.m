//
//  LSEmojiCodeUtil.m
//  LS
//
//  Created by wu quancheng on 12-7-8.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniEmojiCodeUtil.h"

static const EmojiKey emojiArray[74] = 
{
    {1,@"[微笑]"},
    {2,@"[不高兴]"},
    {3,@"[流汗]"},
    {4,@"[思考]"},
    {5,@"[亲亲]"},
    {6,@"[吃惊]"},
    
    {7,@"[困]"},
    {8,@"[奇妙]"},
    {9,@"[见钱眼开]"},
    {10,@"[大哭]"},    
    {11,@"[害羞]"},
    {12,@"[喷嚏]"},
    
    {13,@"[切]"},
    {14,@"[可爱]"},
    {15,@"[大喜]"},
    {16,@"[大笑]"},
    {17,@"[羞涩]"},
    {18,@"[抓狂]"},
    
    {19,@"[恼怒]"},
    {20,@"[偷笑]"},    
    {21,@"[潇洒]"},
    {22,@"[害怕]"},
    {23,@"[鄙视]"},
    {24,@"[抠鼻]"},
    
    {25,@"[色]"},
    {26,@"[鼓掌]"},
    {27,@"[惊讶]"},
    {28,@"[吐]"},
    {29,@"[笑眯眯]"},
    {30,@"[呵斥]"},
    
    {31,@"[憨笑]"},
    {32,@"[左白眼]"},
    {33,@"[右白眼]"},
    {34,@"[嘘]"},
    {35,@"[委屈]"},
    {36,@"[耍酷]"},
    
    {37,@"[调皮]"},
    {38,@"[晕眩]"},
    {39,@"[强]"},
    {40,@"[OK]"},    
    {41,@"[大拇指]"},
    {42,@"[囧]"},
    
    {43,@"[夜晚]"},
    {44,@"[织]"},
    {45,@"[友情]"},
    {46,@"[威武]"},
    {47,@"[骷髅]"},
    {48,@"[真心]"},
    
    {49,@"[围巾]"},
    {50,@"[帽子]"},    
    {51,@"[鞋]"},
    {52,@"[冰花]"},
    {53,@"[小木人]"},
    {54,@"[枫叶]"},
    
    {55,@"[相机]"},
    {56,@"[云]"},
    {57,@"[礼物]"},
    {58,@"[握手]"},
    {59,@"[胜利]"},
    {60,@"[弱]"},
    
    {61,@"[NO]"},
    {62,@"[勾引]"},
    {63,@"[生日]"},
    {64,@"[爱心]"},
    {65,@"[心碎]"},
    {66,@"[猪头]"},
    
    {67,@"[丝带]"},
    {68,@"[钟表]"},
    {69,@"[绿叶]"},
    {70,@"[碰杯]"},    
    {71,@"[衰]"},
    {72,@"[咖啡]"},
    
    {73,@"[话筒]"},
    {74,@"[帅]"}
};

@implementation MiniEmojiCodeUtil
+ (NSString *)nameWithCode:(NSString *)code
{
    NSInteger index = code.intValue - 1;
    return emojiArray[index].name;
}

+ (NSString *)encodeString:(NSString *)src;
{
    NSInteger count = sizeof(emojiArray)/sizeof(EmojiKey);
    for ( NSInteger index = 0; index < count ; index++ )
    {
        EmojiKey key = emojiArray[index];
        src = [src stringByReplacingOccurrencesOfString:key.name withString:[NSString stringWithFormat:@"[#00%02d]",key.code]];
    }
    return src;
}

+ (UIImage *)emojiWithCode:(NSString *)code
{
    if ( code.length == 7 && [code hasPrefix:@"[#00"] && [code hasSuffix:@"]"])
    {
        code = [code substringWithRange:NSMakeRange(2, 4)];
        NSString *imageName = [NSString stringWithFormat:@"Emoji/face_%@",code];
        UIImage *image = [UIImage imageNamed:imageName];
        return image;
    }
    return nil;
}

+ (BOOL)isEmojiCode:(NSString *)code
{
    if ( code.length == 7 && [code hasPrefix:@"[#00"] && [code hasSuffix:@"]"])
    {
        code = [code substringWithRange:NSMakeRange(2, 4)];
        if ( code.intValue > 0 && code.intValue < 75)
        {
            return YES;
        }
    }
    return NO;
}
@end
