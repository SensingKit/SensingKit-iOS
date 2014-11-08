//
//  SKMotionSensing.h
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

#import <Foundation/Foundation.h>

@import CoreMotion;

@protocol SKMotionSensingDelegate <NSObject>

- (void)accelerometerDataReceived:(CMAccelerometerData *)accelerometerData;
- (void)gyroDataReceived:(CMGyroData *)gyroData;
- (void)magnetometerDataReceived:(CMMagnetometerData *)magnetometerData;
- (void)deviceMotionDataReceived:(CMDeviceMotion *)motion;
- (void)activityDataReceived:(CMMotionActivity *)activity;

@end

@interface SKMotionSensing : NSObject

@property (strong, nonatomic) CMMotionManager         *motionManager;
@property (strong, nonatomic) CMMotionActivityManager *motionActivityManager;

@property (nonatomic) NSTimeInterval accelerometerUpdateInterval;
@property (nonatomic) NSTimeInterval gyroUpdateInterval;
@property (nonatomic) NSTimeInterval magnetometerUpdateInterval;
@property (nonatomic) NSTimeInterval deviceMotionUpdateInterval;

@property (weak, nonatomic) id <SKMotionSensingDelegate> delegate;

- (BOOL)isAccelerometerAvailable;
- (BOOL)isGyroAvailable;
- (BOOL)isMagnetometerAvailable;
- (BOOL)isDeviceMotionAvailable;
- (BOOL)isActivityAvailable;

- (void)startAccelerometerSensing;
- (void)stopAccelerometerSensing;

- (void)startGyroSensing;
- (void)stopGyroSensing;

- (void)startMagnetometerSensing;
- (void)stopMagnetometerSensing;

- (void)startDeviceMotionSensing;
- (void)stopDeviceMotionSensing;

- (void)startActivitySensing;
- (void)stopActivitySensing;

@end
