//
//  MiniUIAccelerometer.h
//  LS
//
//  Created by wu quancheng on 12-7-22.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniUIAccelerometer : NSObject<UIAccelerometerDelegate>
{
    void (^callBackBlock)(MiniUIAccelerometer *Accelerometer);
}

- (void)stop;

- (void)startWithBlock:( void (^)(MiniUIAccelerometer *Accelerometer))block;

@end
