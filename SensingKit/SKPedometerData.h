//
//  SKPedometerData.h
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
 *  An instance of SKPedometerData encapsulates measurements related to the Pedometer sensor.
 */
@interface SKPedometerData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKPedometer object, initialized with an instance of CMPedometerData.
 *
 *  @param pedometerData A CMPedometerData object that contains data related to the Pedometer sensor.
 *
 *  @return An SKPedometer object.
 */
- (instancetype)initWithPedometerData:(CMPedometerData *)pedometerData NS_DESIGNATED_INITIALIZER;

/**
 *  An instance of CMPedometerData object contains data about the distance travelled the user by foot.
 */
@property (nonatomic, readonly, copy) CMPedometerData *pedometerData;

/**
 *  Start date that the pedometer data are valid.
 */
@property (nonatomic, readonly, copy) SKSensorTimestamp *startDate;

/**
 *  End date that the pedometer data are valid.
 */
@property (nonatomic, readonly, copy) SKSensorTimestamp *endDate;

/**
 *  A string with a CSV formatted header that describes the data of the Pedometer sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
