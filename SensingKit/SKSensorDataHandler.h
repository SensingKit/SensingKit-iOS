//
//  SKSensorDataHandler.h
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
 Βlock to be invoked when new sensor data is available. You can cast the sensorData object into the actual sensor data (e.g. SKAccelerometerData), based on the reported sensorType.

 @param sensorType The type of the sensor producing the SKSensorData object.
 @param sensorData The new sensor data produced by the SKSensorType sensor.
 @param error This pointer is NULL if an error has occured and sensor data is not available.
 */
typedef void (^SKSensorDataHandler)(SKSensorType sensorType, SKSensorData * __nullable sensorData, NSError * __nullable error);

NS_ASSUME_NONNULL_END
