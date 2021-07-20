//
//  NSString+SKSensorType.h
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
#import <UIKit/UIKit.h>

#import <SKSensorType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  NSString+SKSensorType is a category responsible for converting an SKSensorType enum into string.
 */
@interface NSString (SKSensorType)

/**
 *  Converts an SKSensorType enum into a string.
 *  This method is useful when you want to use the sensor name in the application's User Interface. The returned string might contain spaces or special characters (such as '™'). For example, iBeacon™ Proximity sensor (enum iBeaconProximity) will be returned as "iBeacon™ Proximity".
 *
 *  @param sensorType The type of the sensor.
 *
 *  @return A string with the sensor name. (e.g. "iBeacon™ Proximity").
 */
+ (NSString *)stringWithSensorType:(SKSensorType)sensorType;

/**
 *  Converts an SKSensorType enum into a non-spaced string that does not include special characters.
 *  This method is useful when you want to use the sensor name in file or directory names. The returned string does not contain spaces or any special character (such as '™'). For example, iBeacon™ Proximity sensor (enum iBeaconProximity) will be returned as "iBeaconProximity".
 *
 *  @param sensorType The type of the sensor.
 *
 *  @return A non-spaced string with the sensor name. (e.g. "iBeaconProximity").
 */
+ (NSString *)nonspacedStringWithSensorType:(SKSensorType)sensorType;

@end

NS_ASSUME_NONNULL_END
