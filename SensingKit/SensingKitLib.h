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
#import "NSString+SensorType.h"
#import "SKSensorDataHandler.h"

// Sensor Data
#import "SKAccelerometerData.h"
#import "SKGyroscopeData.h"
#import "SKMagnetometerData.h"
#import "SKDeviceMotionData.h"
#import "SKMotionActivityData.h"
#import "SKPedometerData.h"
#import "SKAltimeterData.h"
#import "SKBatteryData.h"
#import "SKLocationData.h"
#import "SKiBeaconDeviceData.h"
#import "SKEddystoneProximityData.h"
#import "SKMicrophoneData.h"

// Sensor Configuration
#import "SKAccelerometerConfiguration.h"
#import "SKGyroscopeConfiguration.h"
#import "SKMagnetometerConfiguration.h"
#import "SKDeviceMotionConfiguration.h"
#import "SKMotionActivityConfiguration.h"
#import "SKPedometerConfiguration.h"
#import "SKAltimeterConfiguration.h"
#import "SKBatteryConfiguration.h"
#import "SKLocationConfiguration.h"
#import "SKiBeaconProximityConfiguration.h"
#import "SKEddystoneProximityConfiguration.h"
#import "SKMicrophoneConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The 'SensingKitLib' class is the main class of SensingKit library that manages all supported sensors.
 * It uses the Singleton design pattern so that only one instance of the library exists in the application.
 * To init it, you can use [SensingKitLib sharedSensingKitLib].
 */
@interface SensingKitLib : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns the shared `SensingKitLib` instance, creating it if necessary.
 *
 *  @return The shared `SensingKitLib` instance.
 */
+ (SensingKitLib * )sharedSensingKitLib;


/** @name Sensor Status */


/**
 *  A Boolean value that indicates whether the sensor is available on the device. This method should always be used before using a sensor.
 *
 *  @param sensorType The type of the sensor that will be checked.
 *
 *  @return YES if the sensor is available or NO if it is not.
 */
- (BOOL)isSensorAvailable:(SKSensorType)sensorType;

/**
 *  A Boolean value that indicates whether the sensor is registered.
 *
 *  @param sensorType The type of the sensor that will be checked.
 *
 *  @return YES if the sensor is registered or NO if it is not.
 */
- (BOOL)isSensorRegistered:(SKSensorType)sensorType;

/**
 *  A Boolean value that indicates whether the sensor is currently sensing.
 *
 *  @param sensorType The type of the sensor that will be checked.
 *
 *  @return YES if the sensor is currently sensing or NO if it is not.
 */
- (BOOL)isSensorSensing:(SKSensorType)sensorType;


/** @name Sensor Registration and Configuration */

/**
 *  Initializes and registers a sensor into the library with a default sensor configuration.
 *
 *  @param sensorType The type of the sensor that will be initialized and registered in the library.
 */
- (void)registerSensor:(SKSensorType)sensorType;

/**
 *  Initializes and registers a sensor into the library with a custom sensor configuration.
 *
 *  @param sensorType    The type of the sensor that will be initialized and registered in the library.
 *  @param configuration A configuration object that conforms to SKConfiguration. If no configuration is specified, it will default to a pre-determined sensor configuration.
 */
- (void)registerSensor:(SKSensorType)sensorType withConfiguration:(nullable SKConfiguration *)configuration;

/**
 *  Deregisters a sensor from the library. Sensor should not be actively sensing when this method is called. All previously subscribed blocks will also be unsubscribed.
 *
 *  @param sensorType The type of the sensor that will be deregistered.
 */
- (void)deregisterSensor:(SKSensorType)sensorType;

/**
 *  Provides custom configuration to a sensor.
 *
 *  @param configuration A configuration object that conforms to SKConfiguration. If no configuration is specified, it will default to a pre-determined sensor configuration.
 *  @param sensorType    The type of the sensor that will be configured.
 */
- (void)setConfiguration:(nullable SKConfiguration *)configuration toSensor:(SKSensorType)sensorType;

/**
 *  Gets the configuration of a sensor.
 *
 *  @param sensorType  The type of the sensor.
 *
 *  @return The configuration of that particular sensor.
 */
- (SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType;


/** @name Sensor Subscription */

/**
 *  Subscribes for sensor updates using a specified block handler.
 *
 *  @param sensorType  The type of the sensor that the data handler will be subscribed to.
 *  @param handler     A block that is invoked with each update to handle new sensor data. The block must conform to the SKSensorDataHandler type.
 */
- (void)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler;

/**
 *  Unsubscribes all block handlers.
 *
 *  @param sensorType The type of the sensor for which all block handlers will be unsubscribed.
 */
- (void)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType;

/**
 *  A string with a CSV formatted header that describes the data of the particular sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @param sensorType The type of the sensor for which the CSV Header will be returned.
 *
 *  @return A string with a CSV header.
 */
- (nullable NSString *)csvHeaderForSensor:(SKSensorType)sensorType;


/** @name Continuous Sensing */

/**
 *  Starts continuous sensing with the specified sensor.
 *
 *  @param sensorType The type of the sensor that will be started.
 */
- (void)startContinuousSensingWithSensor:(SKSensorType)sensorType;

/**
 *  Stops continuous sensing with the specified sensor.
 *
 *  @param sensorType The type of the sensor that will be stopped.
 */
- (void)stopContinuousSensingWithSensor:(SKSensorType)sensorType;

/**
 *  Starts continuous sensing with all registered sensors.
 */
- (void)startContinuousSensingWithAllRegisteredSensors;

/**
 *  Stops continuous sensing with all registered sensors.
 */
- (void)stopContinuousSensingWithAllRegisteredSensors;

@end

NS_ASSUME_NONNULL_END