//
//  SKMotionSensing.m
//  iBeaconSensing
//
//  Copyright (c) 2014. Queen Mary University of London
//  Kleomenis Katevas, k.katevas@qmul.ac.uk
//
//  This file is part of SensingKit-iOS library.
//  For more information, please visit http://www.sensingkit.org
//
//  SensingKit-iOS is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  SensingKit-iOS is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with SensingKit-iOS.  If not, see <http://www.gnu.org/licenses/>.
//

#import "SKMotionSensing.h"

@implementation SKMotionSensing

- (instancetype)init
{
    if (self = [super init])
    {
        // init managers
        self.motionManager         = [[CMMotionManager alloc] init];
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    }
    return self;
}

#pragma mark properties

- (void)setAccelerometerUpdateInterval:(NSTimeInterval)accelerometerUpdateInterval
{
    self.motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval;
}

- (NSTimeInterval)accelerometerUpdateInterval
{
    return self.motionManager.accelerometerUpdateInterval;
}

- (void)setGyroUpdateInterval:(NSTimeInterval)gyroUpdateInterval
{
    self.motionManager.gyroUpdateInterval = gyroUpdateInterval;
}

- (NSTimeInterval)gyroUpdateInterval
{
    return self.motionManager.gyroUpdateInterval;
}

- (void)setMagnetometerUpdateInterval:(NSTimeInterval)magnetometerUpdateInterval
{
    self.motionManager.magnetometerUpdateInterval = magnetometerUpdateInterval;
}

- (NSTimeInterval)magnetometerUpdateInterval
{
    return self.motionManager.magnetometerUpdateInterval;
}

- (void)setDeviceMotionUpdateInterval:(NSTimeInterval)deviceMotionUpdateInterval
{
    self.motionManager.deviceMotionUpdateInterval = deviceMotionUpdateInterval;
}

- (NSTimeInterval)deviceMotionUpdateInterval
{
    return self.motionManager.deviceMotionUpdateInterval;
}

#pragma mark hardware availiability methods

- (BOOL)isAccelerometerAvailable
{
    return [self.motionManager isAccelerometerAvailable];
}

- (BOOL)isGyroAvailable
{
    return [self.motionManager isAccelerometerAvailable];
}

- (BOOL)isMagnetometerAvailable
{
    return [self.motionManager isMagnetometerAvailable];
}

- (BOOL)isDeviceMotionAvailable
{
    return [self.motionManager isDeviceMotionAvailable];
}

- (BOOL)isActivityAvailable
{
    return [CMMotionActivityManager isActivityAvailable];
}

#pragma mark start / stop sensing

- (void)startAccelerometerSensing
{
    if ([self isAccelerometerAvailable])
    {
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            
                                                     if (error) {
                                                         NSLog(@"%@", error.localizedDescription);
                                                     } else {
                                                         [self.delegate accelerometerDataReceived:accelerometerData];
                                                     }
                                                 
                                                 }];
    }
}

- (void)stopAccelerometerSensing
{
    if ([self isAccelerometerAvailable])
    {
        [self.motionManager stopAccelerometerUpdates];
        
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (void)startGyroSensing
{
    if ([self isGyroAvailable])
    {
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        
                                            if (error) {
                                                NSLog(@"%@", error.localizedDescription);
                                            } else {
                                                [self.delegate gyroDataReceived:gyroData];
                                            }
                                        
                                        }];
    }
}

- (void)stopGyroSensing
{
    if ([self isGyroAvailable])
    {
        [self.motionManager stopGyroUpdates];
    }
}

- (void)startMagnetometerSensing
{
    if ([self isMagnetometerAvailable])
    {
        [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                                            
                                            if (error) {
                                                NSLog(@"%@", error.localizedDescription);
                                            } else {
                                                [self.delegate magnetometerDataReceived:magnetometerData];
                                            }
                                            
                                        }];
    }
}

- (void)stopMagnetometerSensing
{
    if ([self isMagnetometerAvailable])
    {
        [self.motionManager stopMagnetometerUpdates];
    }
}

- (void)startDeviceMotionSensing
{
    if ([self isDeviceMotionAvailable])
    {
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error.localizedDescription);
                                                    } else {
                                                        [self.delegate deviceMotionDataReceived:motion];
                                                    }
                                                }];
    }
}

- (void)stopDeviceMotionSensing
{
    if ([self isDeviceMotionAvailable])
    {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (void)startActivitySensing
{
    if ([self isActivityAvailable])
    {
        [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue]
                                                    withHandler:^(CMMotionActivity *activity) {
                                                        
                                                            [self.delegate activityDataReceived:activity];
                                                    }];
    }
}

- (void)stopActivitySensing
{
    if ([self isActivityAvailable])
    {
        [self.motionActivityManager stopActivityUpdates];
    }
}

@end
