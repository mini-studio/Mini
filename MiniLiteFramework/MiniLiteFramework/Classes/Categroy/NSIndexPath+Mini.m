//
//  NSIndexPath+Mini.m
//  LS
//
//  Created by wu quancheng on 12-7-15.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "NSIndexPath+Mini.h"

@implementation NSIndexPath (Mini)
- (BOOL)isEqualToIndexPath:(NSIndexPath*)object
{
    return ( (object.row == self.row) && (object.section == self.section) );
}
@end
