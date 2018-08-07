//
// Created by Wuquancheng on 2018/7/19.
// Copyright (c) 2018 mini. All rights reserved.
//

#import "UILabel+string.h"


@implementation UILabel (string)
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing
{
    if (!text || lineSpacing < 0.01) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

+ (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(NSString *)textColor
{
    return [self labelWithText:text frame:frame fontSize:fontSize textColor:textColor boldFont:NO];
}

+ (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame fontSize:(CGFloat)fontSize textColor:(NSString *)textColor boldFont:(BOOL)boldFont
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (boldFont) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    label.text = text;
    label.textColor = [UIColor colorWithString:textColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end