//
//  MiniSingletonFactory.m
//  YChat
//
//  Created by wu quancheng on 11-11-22.
//  Copyright (c) 2011年 Mini. All rights reserved.
//

#import "MiniSingletonFactory.h"

@implementation MiniSingletonFactory

SYNTHESIZE_SINGLETON_FOR_CLASS(MiniSingletonFactory)

- (id)init
{
    if ( self = [super init] )
    {
        dic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [dic release];
    [super dealloc];
}

- (id)singleInstanceWith:(NSString*)className
{
    id instance = [dic valueForKey:className];
    if ( instance == nil )
    {
        instance = [[NSClassFromString(className) alloc] init];
        [dic setValue:instance forKey:className];
        [instance release];
    }
    return instance;
}

@end
