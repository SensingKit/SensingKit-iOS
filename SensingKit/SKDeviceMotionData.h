//
//  SKDeviceMotionData.h
//  SensingKit
//
//  Copyright (c) 2014. Kleomenis Katevas
//  Kleomenis Katevas, k.katevas@imperial.ac.uk
//
//  This file is part of SensingKit-iOS library.
//  For more information, please visit https://www.sensingkit.org
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

#import "SKSensorData.h"
@import CoreMotion;

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKDeviceMotionData encapsulates measurements related to the Device Motion sensor.
 *  The measurements include the device's Attitude, Magnetic Field, Rotation Rate and a separation of the User Acceleration and the Gravity. For more information, please refer to Apple's Core Motion Documentation.
 */
@interface SKDeviceMotionData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKDeviceMotionData object, initialized with a CMDeviceMotion object.
 *
 *  @param motion The original CMDeviceMotion object.
 *
 *  @return An SKDeviceMotionData object.
 */
- (instancetype)initWithDeviceMotion:(CMDeviceMotion *)motion NS_DESIGNATED_INITIALIZER;

/**
 *  An attitude object is the orientation of a body relative to a given frame of reference.
 */
@property (nonatomic, readonly, copy) CMAttitude *attitude;

/**
 *  The calibrated Magnetic Field vector that contains the magnetic field vector without the device's bias.
 */
@property (nonatomic, readonly) CMCalibratedMagneticField magneticField;

/**
 *  A structure that contains the device's rotation rate in 3-axis, excluding the gyroscopes bias using sensor fusion techniques.
 */
@property (nonatomic, readonly) CMRotationRate rotationRate;

/**
 *  The devices 3-axes acceleration produced by the user, exluding the acceleration of the gravity.
 */
@property (nonatomic, readonly) CMAcceleration userAcceleration;

/**
 *  The gravities 3-axes acceleration, exluding the acceleration of the user.
 */
@property (nonatomic, readonly) CMAcceleration gravity;

/**
 *  A string with a CSV formatted header that describes the data of the Device Motion sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
