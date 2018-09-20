//
//  SKBatteryData.h
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

#import <UIKit/UIDevice.h>
#import <Foundation/Foundation.h>

#import "SKSensorData.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKBatteryData encapsulates measurements related to the Battery sensor.
 */
@interface SKBatteryData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKBatteryData object, initialized with measurements of the battery level, as well as the battery state.
 *
 *  @param level A float number that indicates the current battery charge level. Value ranges from 0.0 (fully discharged) to 1.0 (fully charged).
 *  @param state An enumerator that descrives the state of the battery, classified as Charging, Full, Unplugged or Unknown.
 *
 *  @return An SKBatteryData object.
 */
- (instancetype)initWithLevel:(CGFloat)level withState:(UIDeviceBatteryState)state NS_DESIGNATED_INITIALIZER;

/**
 *  A float number that indicates the current battery charge level. Value ranges from 0.0 (fully discharged) to 1.0 (fully charged).
 */
@property (nonatomic, readonly) CGFloat level;

/**
 *  An enumerator that describes the state of the battery, classified as Charging, Full, Unplugged or Unknown.
 */
@property (nonatomic, readonly) UIDeviceBatteryState state;

/**
 *  A string value that describes the state of the battery, classified as Charging, Full, Unplugged or Unknown.
 */
@property (nonatomic, readonly, copy) NSString *stateString;

/**
 *  A string with a CSV formatted header that describes the data of the Battery sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
