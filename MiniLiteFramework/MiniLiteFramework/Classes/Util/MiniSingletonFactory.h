//
//  MiniSingletonFactory.h
//  YChat
//
//  Created by wu quancheng on 11-11-22.
//  Copyright (c) 2011年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface MiniSingletonFactory : NSObject
{
    NSMutableDictionary *dic;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniSingletonFactory)

- (id)singleInstanceWith:(NSString*)className;

@end
