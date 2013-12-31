//
//  MiniLocationManager.m
//  LS
//
//  Created by wu quancheng on 12-7-22.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniLocationManager.h"

@implementation MiniLocationManager
@synthesize miniLocationManagerDelegate = _miniLocationManagerDelegate;
@synthesize coordinate = _coordinate;


- (id)init
{
    self = [super init];
    if (self) 
    {
        self.delegate = self;
        self.coordinate = kCLLocationCoordinate2DInvalid;
    }    
    return self;
}

- (void)dealloc
{
    self.miniLocationManagerDelegate = nil;
    [super dealloc];
}

- (void)clearStatus
{
    self.coordinate = kCLLocationCoordinate2DInvalid;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    if (!CLLocationCoordinate2DIsValid(self.coordinate))
    {
        if (oldLocation)
        {
            CLLocationDistance delta = [newLocation
                                        distanceFromLocation:oldLocation];
            if (delta < .5f) 
            {
                self.coordinate = newLocation.coordinate;
                [manager stopUpdatingLocation];
                if ( self.miniLocationManagerDelegate ) 
                {
                    [self.miniLocationManagerDelegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
                }
            }
            else
            {
                [manager stopUpdatingLocation];
                [manager startUpdatingLocation];
            }
        }
        else
        {
            NSDate* eventDate = newLocation.timestamp;
            NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
            if (abs(howRecent) < 15.0)
            {
                [manager stopUpdatingLocation];
                if ( self.miniLocationManagerDelegate ) 
                {
                    self.coordinate = newLocation.coordinate;
                    [self.miniLocationManagerDelegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
                }
            }
            else
            {
                [manager stopUpdatingLocation];
                [manager startUpdatingLocation];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.miniLocationManagerDelegate)
    {
        [self.miniLocationManagerDelegate locationManager:manager didFailWithError:error];
    }
    [manager stopUpdatingLocation];
}

@end
