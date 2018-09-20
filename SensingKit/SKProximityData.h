//
//  SKProximityData.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKProximityData encapsulates an array of Device Data (e.g. SKiBeaconDeviceData).
 */
@interface SKProximityData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKProximityData object, initialized with an array of Device Data objects as well as the time that the scan was completed.
 *
 *  @param sensorType The type of the sensor that produced this data object.
 *  @param timestamp  The time that this data log was captured.
 *  @param devices    An array that holds the Device Data objects.
 *
 *  @return An SKProximityData object.
 */
- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(NSDate *)timestamp
                       withDevices:(NSArray *)devices NS_DESIGNATED_INITIALIZER;

/**
 *  An array that holds the Device Data objects.
 */
@property (nonatomic, readonly, copy) NSArray *devices;

/**
 *  As the CSV header depends on the encapsulated Device Data objects, this method always returns nil.
 *
 *  @return Always nil.
 */
+ (nullable NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
