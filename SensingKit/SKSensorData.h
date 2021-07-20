//
//  SKSensorData.h
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
#import <SKSensorType.h>
#import <SKSensorTimestamp.h>
#import <NSString+SensorType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  This is the base class for all Sensor Data objects. A subclass of SKSensorData object is delivered through the SKSensorDataHandler, combined with the related SKSensorType.
 */
@interface SKSensorData : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns an SKSensorData object, initialized with the given SKSensorType and SKSensorTimestamp.
 *
 *  @param sensorType The type of the sensor that produced this data object.
 *  @param timestamp  The time were this data log was captured.
 *
 *  @return A new SKSensorData object.
 */
- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_DESIGNATED_INITIALIZER;

/**
 *  The type of the sensor that produced this data object.
 */
@property (nonatomic, readonly) SKSensorType sensorType;

/**
 *  The time were this data log was captured.
 */
@property (nonatomic, readonly, copy) SKSensorTimestamp *timestamp;

/**
 *  Returns a string with all the sensor data elements into CSV format. For a description of the element types, sensor class method csvHeader can be used.
 */
@property (nonatomic, readonly, copy) NSString *csvString;

/**
 *  Returns a dictionary that encapsulates all the sensor data elements.
 */
@property (nonatomic, readonly, copy) NSDictionary *dictionaryData;

@end

NS_ASSUME_NONNULL_END
