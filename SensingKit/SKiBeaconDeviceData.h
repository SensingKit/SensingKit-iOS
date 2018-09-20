//
//  SKiBeaconDeviceData.h
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
@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKiBeaconDeviceData encapsulates measurements related to the iBeacon™ Proximity sensor. For more information about iBeacon™ technology, please refer to Apple's Getting Started with iBeacon documentation.
 */
@interface SKiBeaconDeviceData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKiBeaconDeviceData object, initialized with the time the device was found, its major and minor identifiers, as well as its accuracy, proximity and RSSI.
 *
 *  @param timestamp The time that this data log was captured.
 *  @param major     A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535.
 *  @param minor     A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535.
 *  @param accuracy  A double value that represents the accuracy of the device's proximity in meters.
 *  @param proximity The proximity of the device classified as Immediate, Near, Far or Unknown.
 *  @param rssi      The strength of the signal (Received Signal Strength Indication).
 *
 *  @return An SKiBeaconDeviceData object.
 */
- (instancetype)initWithTimestamp:(NSDate *)timestamp
                        withMajor:(uint16_t)major
                        withMinor:(uint16_t)minor
                     withAccuracy:(CLLocationAccuracy)accuracy
                    withProximity:(CLProximity)proximity
                         withRssi:(NSInteger)rssi NS_DESIGNATED_INITIALIZER;

/**
 *  A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535. This identifier can be used in combination with the minor identifier.
 */
@property (nonatomic, readonly) uint16_t major;

/**
 *  A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535. This identifier can be used in combination with the major identifier.
 */
@property (nonatomic, readonly) uint16_t minor;

/**
 *  A double value that represents the accuracy of the device's proximity in meters.
 */
@property (nonatomic, readonly) CLLocationAccuracy accuracy;

/**
 *  The proximity of the device classified as Immediate, Near, Far or Unknown.
 */
@property (nonatomic, readonly) CLProximity proximity;

/**
 *  A string representation of the proximity, classified as Immediate, Near, Far or Unknown.
 */
@property (nonatomic, readonly, copy) NSString *proximityString;

/**
 *  The strength of the signal (Received Signal Strength Indication).
 */
@property (nonatomic, readonly) NSInteger rssi;

/**
 *  A string with a CSV formatted header that describes the data of the iBeacon™ Proximity sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
