//
//  SKEddystoneProximityData.h
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
 *  An instance of SKEddystoneProximityData encapsulates measurements related to the Eddystone™ Proximity sensor.
 */
@interface SKEddystoneProximityData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKEddystoneProximityData object, initialized with the time the data log was captured, its namespace and instance identifiers, as well as its rssi and txPower.
 *
 *  @param timestamp   The time that this data log was captured.
 *  @param namespaceId A 10-byte (80 bit) identifier that can used to group a particular set of beacons. This value should be in Hexadecimal format, with a maximum character length of 20 characters.
 *  @param instanceId  A 6-byte (48 bit) unsigned integer that is used to identify individual devices inside the namespace group. It ranges between 0 and 281474976710655.
 *  @param rssi        The strength of the signal (Received Signal Strength Indication).
 *  @param txPower     The strength of the signal measured at a distance of 1 meter.
 *
 *  @return An SKEddystoneProximityData object.
 */
- (instancetype)initWithTimestamp:(NSDate *)timestamp
                  withNamespaceId:(NSString * _Nullable)namespaceId
                   withInstanceId:(NSUInteger)instanceId
                         withRssi:(NSInteger)rssi
                      withTxPower:(NSInteger)txPower NS_DESIGNATED_INITIALIZER;

/**
 *  A 10-byte (80 bit) identifier that can used to group a particular set of beacons. This value should be in Hexadecimal format, with a maximum character length of 20 characters.
 */
@property (nonatomic, readonly, copy, nullable) NSString *namespaceId;

/**
 *  A 6-byte (48 bit) unsigned integer that is used to identify individual devices inside the namespace group. It ranges between 0 and 281474976710655.
 */
@property (nonatomic, readonly) NSUInteger instanceId;

/**
 *  The strength of the signal (Received Signal Strength Indication).
 */
@property (nonatomic, readonly) NSInteger rssi;

/**
 *  The strength of the signal measured at a distance of 1 meter.
 */
@property (nonatomic, readonly) NSInteger txPower;

/**
 *  A string with a CSV formatted header that describes the data of the Eddystone™ Proximity sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
