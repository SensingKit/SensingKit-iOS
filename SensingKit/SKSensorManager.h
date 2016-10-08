//
//  SKSensorManager.h
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


NS_ASSUME_NONNULL_BEGIN

@interface SKSensorManager : NSObject

/** @name Sensor Status */

+ (BOOL)isSensorAvailable:(SKSensorType)sensorType;

- (BOOL)isSensorRegistered:(SKSensorType)sensorType;

- (BOOL)isSensorSensing:(SKSensorType)sensorType;


/** @name Sensor Registration and Configuration */

- (BOOL)registerSensor:(SKSensorType)sensorType withConfiguration:(nullable SKConfiguration *)configuration error:(NSError * _Nullable * _Nullable)error;

- (BOOL)deregisterSensor:(SKSensorType)sensorType error:(NSError * _Nullable * _Nullable)error;

- (BOOL)setConfiguration:(nullable SKConfiguration *)configuration toSensor:(SKSensorType)sensorType error:(NSError * _Nullable * _Nullable)error;

- (SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType error:(NSError * _Nullable * _Nullable)error;


/** @name Sensor Subscription and Unsubscription */

- (void)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler;

- (void)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType;

+ (nullable NSString *)csvHeaderForSensor:(SKSensorType)sensorType;


/** @name Continuous Sensing */

- (void)startContinuousSensingWithSensor:(SKSensorType)sensorType;

- (void)stopContinuousSensingWithSensor:(SKSensorType)sensorType;

- (void)startContinuousSensingWithAllRegisteredSensors;

- (void)stopContinuousSensingWithAllRegisteredSensors;

@end

NS_ASSUME_NONNULL_END
