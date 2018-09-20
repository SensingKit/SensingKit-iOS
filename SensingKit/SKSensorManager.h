//
//  SKSensorManager.h
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

#import "SKSensorType.h"
#import "SKSensorDataHandler.h"
#import "SKConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@interface SKSensorManager : NSObject

/** @name Sensor Status */

+ (BOOL)isSensorAvailable:(SKSensorType)sensorType;

- (BOOL)isSensorRegistered:(SKSensorType)sensorType;

- (BOOL)isSensorSensing:(SKSensorType)sensorType;


/** @name Sensor Registration and Configuration */

- (BOOL)registerSensor:(SKSensorType)sensorType
     withConfiguration:(nullable SKConfiguration *)configuration
                 error:(NSError * _Nullable * _Nullable)error;

- (BOOL)deregisterSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error;

- (BOOL)setConfiguration:(nullable SKConfiguration *)configuration
                toSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error;

- (nullable SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType
                                          error:(NSError * _Nullable * _Nullable)error;


/** @name Sensor Subscription and Unsubscription */

- (BOOL)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler
                    error:(NSError * _Nullable * _Nullable)error;

- (BOOL)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error;

+ (NSString *)csvHeaderForSensor:(SKSensorType)sensorType;


/** @name Continuous Sensing */

- (BOOL)startContinuousSensingWithSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error;

- (BOOL)stopContinuousSensingWithSensor:(SKSensorType)sensorType
                                  error:(NSError * _Nullable * _Nullable)error;

- (BOOL)startContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error;

- (BOOL)stopContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
