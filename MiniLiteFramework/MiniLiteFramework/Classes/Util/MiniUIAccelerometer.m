//
//  MiniUIAccelerometer.m
//  LS
//
//  Created by wu quancheng on 12-7-22.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniUIAccelerometer.h"

@implementation MiniUIAccelerometer

- (id)init
{
    self = [super init];
    if ( self )
    {
        UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.delegate = self;
        accelerometer.updateInterval = 1.0/60.0;
    }
    return self;
}

- (void)dealloc
{
    Block_release(callBackBlock);
    [UIAccelerometer sharedAccelerometer].delegate = nil;
    [super dealloc];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    static NSInteger shakeCount = 0;  
    static NSDate *shakeStart;  
    NSDate *now = [[NSDate alloc] init];  
    NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:1.5f sinceDate:shakeStart];  
    if ([now compare:checkDate] == NSOrderedDescending || shakeStart == nil)  
    {  
        shakeCount = 0;  
        [shakeStart release];  
        shakeStart = [[NSDate alloc] init];  
    }  
    [now release];  
    [checkDate release];  
    if (fabsf(acceleration.x) > 2.0 || fabsf(acceleration.y) > 2.0 || fabsf(acceleration.z) > 2.0)  
    {  
        shakeCount++;  
        if (shakeCount > 4)  
        {   
            shakeCount = 0;  
            [shakeStart release];  
            shakeStart = [[NSDate alloc] init];  
            if ( callBackBlock )
            {
                callBackBlock( self );
            }
        }  
    }  
}

- (void)stop
{
    [UIAccelerometer sharedAccelerometer].delegate = nil;
}

- (void)startWithBlock:( void (^)(MiniUIAccelerometer *Accelerometer))block
{
    if ( callBackBlock )
    {
        Block_release( callBackBlock );
        callBackBlock = nil;
    }
    if ( block )
    {
        callBackBlock = Block_copy( block );
    }    
    [UIAccelerometer sharedAccelerometer].delegate = self;     
}

@end
