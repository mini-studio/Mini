//
//  MiniLocationManager.h
//  LS
//
//  Created by wu quancheng on 12-7-22.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
@interface MiniLocationManager : CLLocationManager <CLLocationManagerDelegate>
{
    id<CLLocationManagerDelegate> _miniLocationManagerDelegate;
    CLLocationCoordinate2D      _coordinate;
}

@property (nonatomic,assign) id<CLLocationManagerDelegate> miniLocationManagerDelegate;
@property (nonatomic)  CLLocationCoordinate2D      coordinate;

- (void)clearStatus;
@end
