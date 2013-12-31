//
//  NSDate+Mini.m
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "NSDate+Mini.h"

@implementation NSDate (Mini)
- (NSString*)formatDateStyle:(DateStyle)style
{
    NSDateFormatter *__dateFormate = [[NSDateFormatter alloc] init];
    [__dateFormate setLocale:[NSLocale currentLocale]];
    switch (style) {
        case EDateStyleYMDHM:
        {
            [__dateFormate setDateStyle:NSDateFormatterLongStyle];
            [__dateFormate setTimeStyle:kCFDateFormatterShortStyle];
        }
            break;
        case EDateStyleMDHM:
        {
            NSString *region = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
            if ([region compare:@"cn" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"tw" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"hk" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"mo" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"sg" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                [__dateFormate setDateFormat:@"M-d ah:mm"];       
            }
            else
            {
                [__dateFormate setDateFormat:@"M-d h:mm a"];
            }
        }
            break;
        case EDateStyleHM:
        {
            [__dateFormate setDateStyle:NSDateFormatterNoStyle];
            [__dateFormate setTimeStyle:NSDateFormatterShortStyle];  
        }
            break;
        case EDateStyleYMD:
        {
            [__dateFormate setDateStyle:NSDateFormatterLongStyle];
            [__dateFormate setTimeStyle:NSDateFormatterNoStyle];
            
        }
        case EDateStyleY_M_D:
        {
             [__dateFormate setDateFormat:@"yyyy-MM-d"];
        }
            break;
        default:
            break;
    }
    NSString *f = [__dateFormate stringFromDate:self];
    [__dateFormate release];
	return f; 
}

@end
