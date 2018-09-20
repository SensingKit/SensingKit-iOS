//
//  SKMagnetometerData.h
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
 *  An instance of SKMagnetometerData encapsulates measurements related to the Magnetometer sensor.
 */
@interface SKMagnetometerData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKMagnetometerData object, initialized with a CMMagnetometerData structure.
 *
 *  @param magnetometerData A structure that contains 3-axis magnetometer data.
 *
 *  @return An SKMagnetometerData object.
 */
- (instancetype)initWithMagnetometerData:(CMMagnetometerData *)magnetometerData NS_DESIGNATED_INITIALIZER;

/**
 *  A structure that contains 3-axis magnetometer data.
 */
@property (nonatomic, readonly) CMMagneticField magneticField;

/**
 *  A string with a CSV formatted header that describes the data of the Magnetometer sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
