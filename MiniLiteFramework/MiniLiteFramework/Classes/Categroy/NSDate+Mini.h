//
//  NSDate+Mini.h
//  LS
//
//  Created by wu quancheng on 12-6-24.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum 
{
    EDateStyleYMDHM = 0,//yMd hms
    EDateStyleMDHM, // no年
    EDateStyleHM,//hour minute
    EDateStyleYMD,
    EDateStyleY_M_D,
}DateStyle;

@interface NSDate (Mini)

- (NSString*)formatDateStyle:(DateStyle)style;

@end
