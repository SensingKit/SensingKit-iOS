//
//  SKMicrophoneData.h
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
 *  An instance of SKMicrophoneData encapsulates measurements related to the Microphone sensor. Since Microphone sensor records audio from the environment directly into the device's memory, an SKSensorData object represent a change in the state of the Microphone sensor (e.g. Started or Stopped).
 */
@interface SKMicrophoneData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKMicrophoneData object, initialized with the current state of the sensor and the timestamp.
 *
 *  @param state        Microphone sensor state.
 *  @param timeInterval Time that the state of the sensor changed.
 *
 *  @return An SKMicrophoneData object.
 */
- (instancetype)initWithState:(NSString *)state
             withTimeInterval:(NSTimeInterval)timeInterval NS_DESIGNATED_INITIALIZER;

/**
 *  A string with the state of Microphone sensor (e.g. Started or Stopped).
 */
@property (nonatomic, readonly, copy) NSString *state;

/**
 *  A string with a CSV formatted header that describes the data of the Microphone sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
