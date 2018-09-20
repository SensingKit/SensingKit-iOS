//
//  SensingKitLib.h
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

/**
 The 'SensingKitLib' class is the main class of SensingKit library that manages all supported sensors.
 It uses the Singleton design pattern so that only one instance of the library exists in the application.
 To init it, you can use [SensingKitLib sharedSensingKitLib].
 */
@interface SensingKitLib : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 Returns the shared `SensingKitLib` instance, creating it if necessary.
 
 @return The shared `SensingKitLib` instance.
 */
+ (SensingKitLib *)sharedSensingKitLib;

/**
 A string with a CSV formatted header that describes the data of the particular sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 
 @param sensorType The type of the sensor for which the CSV Header will be returned.
 @return A string with a CSV header.
 */
- (NSString *)csvHeaderForSensor:(SKSensorType)sensorType;



/** @name Sensor Status */

/**
 A Boolean value that indicates whether the sensor is available on the device. This method should always be used before using a sensor.

 @param sensorType The type of the sensor that will be checked.
 @return YES if the sensor is available or NO if it is not.
 */
- (BOOL)isSensorAvailable:(SKSensorType)sensorType;

/**
 A Boolean value that indicates whether the sensor is registered.

 @param sensorType The type of the sensor that will be checked.
 @return YES if the sensor is registered or NO if it is not.
 */
- (BOOL)isSensorRegistered:(SKSensorType)sensorType;

/**
 A Boolean value that indicates whether the sensor is currently sensing.
 
 @param sensorType The type of the sensor that will be checked.
 @return YES if the sensor is currently sensing or NO if it is not.
 */
- (BOOL)isSensorSensing:(SKSensorType)sensorType;



/** @name Sensor Registration and Configuration */

/**
 Initializes and registers a sensor into the library with a default sensor configuration.

 @param sensorType The type of the sensor that will be initialized and registered in the library.
 @param error This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)registerSensor:(SKSensorType)sensorType
                 error:(NSError * _Nullable * _Nullable)error;

/**
 Initializes and registers a sensor into the library with a custom sensor configuration.
 
 @param sensorType    The type of the sensor that will be initialized and registered in the library.
 @param configuration A configuration object that conforms to SKConfiguration. If no configuration is specified, it will default to a pre-determined sensor configuration.
 @param error         This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)registerSensor:(SKSensorType)sensorType
     withConfiguration:(nullable SKConfiguration *)configuration
                 error:(NSError * _Nullable * _Nullable)error;

/**
 Deregisters a sensor from the library. Sensor should not be actively sensing when this method is called. All previously subscribed blocks will also be unsubscribed.

 @param sensorType The type of the sensor that will be deregistered.
 @param error      This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)deregisterSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error;

/**
 Provides custom configuration to a sensor.
 
 @param configuration A configuration object that conforms to SKConfiguration. If no configuration is specified, it will default to a pre-determined sensor configuration.
 @param sensorType    The type of the sensor that will be configured.
 @param error         This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)setConfiguration:(nullable SKConfiguration *)configuration
                toSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error;

/**
 Gets the configuration of a sensor.
 
 @param sensorType  The type of the sensor.
 @param error       This pointer is NULL if the action was performed successfully.
 @return The configuration of that particular sensor, or nil if an error has occured.
 */
- (nullable SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType
                                          error:(NSError * _Nullable * _Nullable)error;


/** @name Sensor Subscription */

/**
 Subscribes for sensor updates using a specified block handler.

 @param sensorType  The type of the sensor that the data handler will be subscribed to.
 @param handler     A block that is invoked with each update to handle new sensor data. The block must conform to the SKSensorDataHandler type.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler
                    error:(NSError * _Nullable * _Nullable)error;

/**
 Unsubscribes all block handlers.
 
 @param sensorType The type of the sensor for which all block handlers will be unsubscribed.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error;



/** @name Continuous Sensing */

/**
 Starts continuous sensing with the specified sensor.
 
 @param sensorType The type of the sensor that will be started.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)startContinuousSensingWithSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error;

/**
 Stops continuous sensing with the specified sensor.
 
 @param sensorType The type of the sensor that will be stopped.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)stopContinuousSensingWithSensor:(SKSensorType)sensorType
                                  error:(NSError * _Nullable * _Nullable)error;

/**
 Starts continuous sensing with all registered sensors.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)startContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error;

/**
 Stops continuous sensing with all registered sensors.
 @param error       This pointer is NULL if the action was performed successfully.
 @return YES if the action was performed successfully, or NO if an error has occuried.
 */
- (BOOL)stopContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
