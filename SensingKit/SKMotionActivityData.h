//
//  SKMotionActivityData.h
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
 *  An instance of SKMotionActivityData encapsulates measurements related to the Motion Activity sensor. Activity is classified between Stationary, Walking, Running, Automotive, Cycling and Unknown.
 */
@interface SKMotionActivityData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKMotionActivityData object, initialized with an instance of CMMotionActivity.
 *
 *  @param motionActivity A CMMotionActivity object that contains data related to the Motion Activity sensor.
 *
 *  @return An SKMotionActivityData object.
 */
- (instancetype)initWithMotionActivity:(CMMotionActivity *)motionActivity NS_DESIGNATED_INITIALIZER;

/**
 *  An instance of CMMotionActivity object contains data about the measured motion activity, classified between Stationary, Walking, Running, Automotive, Cycling and Unknown.
 */
@property (nonatomic, readonly, copy) CMMotionActivity *motionActivity;

/**
 *  Start date that the activity data are valid.
 */
@property (nonatomic, readonly, copy) SKSensorTimestamp *startDate;

/**
 *  A string with a CSV formatted header that describes the data of the Activity sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
