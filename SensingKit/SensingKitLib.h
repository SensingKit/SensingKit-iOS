//
//  SensingKitLib.h
//  SensingKit
//
//  Copyright (c) 2014. Queen Mary University of London
//  Kleomenis Katevas, k.katevas@qmul.ac.uk
//
//  This file is part of SensingKit-iOS library.
//  For more information, please visit http://www.sensingkit.org
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

/**
 * The 'SensingKitLib' class is the main class of SensingKit library that manages all supported sensors.
 * It uses the Singleton design pattern so that only one instance of the library exists in the application.
 * To init it, you can use [SensingKitLib sharedSensingKitLib].
 */
@interface SensingKitLib : NSObject

- (instancetype)init __attribute__((unavailable("Use [SensingKitLib sharedSensingKitLib] instead.")));

/**
 *  Returns the shared `SensingKitLib` instance, creating it if necessary.
 *
 *  @return The shared `SensingKitLib` instance.
 */
+ (SensingKitLib * )sharedSensingKitLib;


/** @name Sensor Status */

- (BOOL)isSensorAvailable:(SKSensorType)sensorType;

- (BOOL)isSensorRegistered:(SKSensorType)sensorType;

- (BOOL)isSensorSensing:(SKSensorType)sensorType;


/** @name Sensor Registration and Configuration */

- (void)registerSensor:(SKSensorType)sensorType;

- (void)registerSensor:(SKSensorType)sensorType withConfiguration:(SKConfiguration *)configuration;

- (void)deregisterSensor:(SKSensorType)sensorType;

- (void)setConfiguration:(SKConfiguration *)configuration toSensor:(SKSensorType)sensorType;

- (SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType;


/** @name Sensor Subscription and Unsubscription */

- (void)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler;

- (void)unsubscribeFromSensor:(SKSensorType)sensorType
                      handler:(SKSensorDataHandler)handler;

- (void)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType;

+ (NSString *)csvHeaderForSensor:(SKSensorType)sensorType;


/** @name Continuous Sensing */

- (void)startContinuousSensingWithSensor:(SKSensorType)sensorType;

- (void)stopContinuousSensingWithSensor:(SKSensorType)sensorType;

- (void)startContinuousSensingWithAllRegisteredSensors;

- (void)stopContinuousSensingWithAllRegisteredSensors;

@end
