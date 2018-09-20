//
//  SKSensorTimestamp.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 *  SKSensorTimestamp object represent a single point in time. 
 */
@interface SKSensorTimestamp : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Creates and returns a new SKSensorTimestamp from an NSDate object. If the sensor does not provide an NSDate object, [NSDate date] can be used.
 *
 *  @param date The absolute date that this SKSensorTimestamp object should be initialized with.
 *
 *  @return A new SKSensorTimestamp object initialized with the (NSDate *)date parameter.
 */
+ (instancetype)sensorTimestampFromDate:(NSDate *)date;

/**
 *  Creates and returns a new SKSensorTimestamp from a NSTimeInterval object. The time interval should be relative to the last time the device was boot. If the sensor does not provide this value, [NSProcessInfo processInfo].systemUptime can be used.
 *
 *  @param timeInterval The number of seconds since the last time the device was boot.
 *
 *  @return A new SKSensorTimestamp object initialized relative to the timeInterval parameter.
 */
+ (instancetype)sensorTimestampFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  Returns an NSDate object of the sensor timestamp.
 */
@property (nonatomic, readonly, copy) NSDate *timestamp;

/**
 *  Returns the interval between the timestamp and the last time the device was boot.
 */
@property (nonatomic, readonly) NSTimeInterval timeIntervalSinceLastBoot;

/**
 *  Returns a dictionary that encapsulates the timestamp as a string, the interval since 1970, and the interval since the device was boot.
 */
@property (nonatomic, readonly, copy) NSDictionary *timestampDictionary;

/**
 *  Returns a string representation of the timestamp. The format of the string is "yyyy-MM-dd HH:mm:ss.SSS ZZZ".
 */
@property (nonatomic, readonly, copy) NSString *timestampString;

/**
 *  Returns the interval between the timestamp and 00:00:00 UTC on 1 January 1970.
 */
@property (nonatomic, readonly) NSTimeInterval timeIntervalSince1970;

@end

NS_ASSUME_NONNULL_END