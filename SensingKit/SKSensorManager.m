//
//  SKSensorManager.m
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

#import "SKSensorManager.h"
#import "SKAbstractSensor.h"
#import "NSString+SensorType.h"
#import "SKErrors.h"

// Sensors
#import "SKAccelerometer.h"
#import "SKGyroscope.h"
#import "SKMagnetometer.h"
#import "SKDeviceMotion.h"
#import "SKMotionActivity.h"
#import "SKPedometer.h"
#import "SKAltimeter.h"
#import "SKBattery.h"
#import "SKLocation.h"
#import "SKHeading.h"
#import "SKiBeaconProximity.h"
#import "SKEddystoneProximity.h"
#import "SKMicrophone.h"

// SensorData
#import "SKAccelerometerData.h"
#import "SKGyroscopeData.h"
#import "SKMagnetometerData.h"
#import "SKDeviceMotionData.h"
#import "SKMotionActivityData.h"
#import "SKPedometerData.h"
#import "SKAltimeterData.h"
#import "SKBatteryData.h"
#import "SKLocationData.h"
#import "SKHeadingData.h"
#import "SKiBeaconDeviceData.h"
#import "SKEddystoneProximityData.h"
#import "SKMicrophoneData.h"

// SensorConfiguration
#import "SKAccelerometerConfiguration.h"
#import "SKGyroscopeConfiguration.h"
#import "SKMagnetometerConfiguration.h"
#import "SKDeviceMotionConfiguration.h"
#import "SKMotionActivityConfiguration.h"
#import "SKPedometerConfiguration.h"
#import "SKAltimeterConfiguration.h"
#import "SKBatteryConfiguration.h"
#import "SKLocationConfiguration.h"
#import "SKHeadingConfiguration.h"
#import "SKiBeaconProximityConfiguration.h"
#import "SKEddystoneProximityConfiguration.h"
#import "SKMicrophoneConfiguration.h"


@interface SKSensorManager()

@property (nonatomic, strong, readonly) NSMutableArray *sensors;

@end


@implementation SKSensorManager

- (instancetype)init
{
    if (self = [super init])
    {
        // init array that holds the sensors
        _sensors = [[NSMutableArray alloc] initWithCapacity:TOTAL_SENSORS];
        
        for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
            [_sensors addObject:[NSNull null]];
        }
    }
    return self;
}


#pragma mark Sensor Status methods

+ (BOOL)isSensorAvailable:(SKSensorType)sensorType
{
    switch (sensorType) {
            
        case Accelerometer:
            return [SKAccelerometer isSensorAvailable];
            
        case Gyroscope:
            return [SKGyroscope isSensorAvailable];
            
        case Magnetometer:
            return [SKMagnetometer isSensorAvailable];
            
        case DeviceMotion:
            return [SKDeviceMotion isSensorAvailable];
            
        case MotionActivity:
            return [SKMotionActivity isSensorAvailable];
            
        case Pedometer:
            return [SKPedometer isSensorAvailable];
            
        case Altimeter:
            return [SKAltimeter isSensorAvailable];
            
        case Battery:
            return [SKBattery isSensorAvailable];
            
        case Location:
            return [SKLocation isSensorAvailable];
        
        case Heading:
            return [SKHeading isSensorAvailable];
            
        case iBeaconProximity:
            return [SKiBeaconProximity isSensorAvailable];
            
        case EddystoneProximity:
            return [SKEddystoneProximity isSensorAvailable];
            
        case Microphone:
            return [SKMicrophone isSensorAvailable];
        
            // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Internal Error: Unknown Sensor: %li", (long)sensorType);
            abort();
    }
}

- (BOOL)isSensorRegistered:(SKSensorType)sensorType
{
    return (self.sensors[sensorType] != [NSNull null]);
}

- (BOOL)isSensorSensing:(SKSensorType)sensorType
{
    SKAbstractSensor *sensor = [self getSensor:sensorType error:NULL];
    
    if (sensor) {
        return sensor.sensing;
    }
    else {
        // Just return NO since we don't have error support here.
        return NO;
    }
}


#pragma mark Sensor Registration and Configuration methods

- (BOOL)registerSensor:(SKSensorType)sensorType
     withConfiguration:(SKConfiguration *)configuration
                 error:(NSError **)error
{
    NSLog(@"Register sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    // Sensor should be available first
    if (![SKSensorManager isSensorAvailable:sensorType]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Sensor should not be registered
    if ([self isSensorRegistered:sensorType]) {
        
        if (error) {
                        
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is already registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorAlreadyRegisteredError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // if configuration is provided, check the type
    if (configuration) {
        
        if (![configuration isValidForSensor:sensorType]) {
            
            if (error) {
                
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Configuration is not compatible with the registered sensor.", nil),
                                           };
                
                *error = [NSError errorWithDomain:SKErrorDomain
                                             code:SKConfigurationNotValid
                                         userInfo:userInfo];
            }
            return NO;
        }
    } else {
        // If configuration was not provided, get the Default
        configuration = [SKSensorManager defaultConfigurationForSensor:sensorType];
    }
    
    SKAbstractSensor *sensor = [SKSensorManager createSensor:sensorType withConfiguration:configuration];
    self.sensors[sensorType] = sensor;
    
    return YES;
}

- (BOOL)deregisterSensor:(SKSensorType)sensorType
                   error:(NSError **)error
{
    NSLog(@"Deregister sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    // Sensor should not already be sensing
    if ([self isSensorSensing:sensorType]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is currently sensing.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorCurrentlySensingError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Clear all Callbacks from that sensor
    [sensor unsubscribeAllHandlers];
    
    // Deregister the Sensor
    self.sensors[sensorType] = [NSNull null];
    
    return YES;
}

- (BOOL)setConfiguration:(SKConfiguration *)configuration
                toSensor:(SKSensorType)sensorType
                   error:(NSError **)error
{
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    // if configuration is provided, check the type
    if (configuration)
    {
        if (![configuration isValidForSensor:sensorType]) {
            
            if (error) {
                
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Configuration is not compatible with the registered sensor.", nil),
                                           };
                
                *error = [NSError errorWithDomain:SKErrorDomain
                                             code:SKConfigurationNotValid
                                         userInfo:userInfo];
            }
            return NO;
        }
    }
    else {
        // If configuration was not provided, get the Default
        configuration = [SKSensorManager defaultConfigurationForSensor:sensorType];
    }
    
    // Set the configuration
    sensor.configuration = configuration;
    
    return YES;
}

- (SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType
                                          error:(NSError **)error
{
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return nil;
    }
    
    return sensor.configuration;
}


#pragma mark Sensor Subscription and Unsubscription methods

- (BOOL)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler
                    error:(NSError **)error
{
    NSLog(@"Subscribe to sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    return [sensor subscribeHandler:handler error:error];
}

- (BOOL)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType
                                   error:(NSError **)error
{
    NSLog(@"Unsubscribe all handlers from sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    // At least one handler should be registered
    if (!sensor.handlersCount) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor Data Handler is not registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotRegisteredError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [sensor unsubscribeAllHandlers];
    
    return YES;
}

+ (NSString *)csvHeaderForSensor:(SKSensorType)sensorType
{
    switch (sensorType) {
            
        case Accelerometer:
            return [SKAccelerometerData csvHeader];
            
        case Gyroscope:
            return [SKGyroscopeData csvHeader];
            
        case Magnetometer:
            return [SKMagnetometerData csvHeader];
            
        case DeviceMotion:
            return [SKDeviceMotionData csvHeader];
            
        case MotionActivity:
            return [SKMotionActivityData csvHeader];
            
        case Pedometer:
            return [SKPedometerData csvHeader];
            
        case Altimeter:
            return [SKAltimeterData csvHeader];
            
        case Battery:
            return [SKBatteryData csvHeader];
            
        case Location:
            return [SKLocationData csvHeader];
        
        case Heading:
            return [SKHeadingData csvHeader];
            
        case iBeaconProximity:
            return [SKiBeaconDeviceData csvHeader];
            
        case EddystoneProximity:
            return [SKEddystoneProximityData csvHeader];
            
        case Microphone:
            return [SKMicrophoneData csvHeader];
        
            // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Internal Error: Unknown Sensor: %li", (long)sensorType);
            abort();
    }
}


#pragma mark Continuous Sensing methods

- (BOOL)startContinuousSensingWithSensor:(SKSensorType)sensorType
                                   error:(NSError **)error
{
    NSLog(@"Start sensing with sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    // At least one handler should be registered
    if (!sensor.handlersCount) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor Data Handler is not registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotRegisteredError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Sensor should not be currently sensing
    if ([self isSensorSensing:sensorType]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is currenyly sensing.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorCurrentlySensingError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Start Sensing
    return [sensor startSensing:error];
}

- (BOOL)stopContinuousSensingWithSensor:(SKSensorType)sensorType
                                  error:(NSError **)error
{
    NSLog(@"Stop sensing with sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    // Sensor should be currently sensing
    if (![self isSensorSensing:sensorType]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is currenyly not sensing.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorCurrentlyNotSensingError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    SKAbstractSensor *sensor = [self getSensor:sensorType error:error];
    
    // Sensor should be registered
    if (!sensor) {
        return NO;
    }
    
    // Stop Sensing
    return [sensor stopSensing:error];
}

- (BOOL)startContinuousSensingWithAllRegisteredSensors:(NSError **)error
{
    NSLog(@"Start sensing with all registered sensors.");
    
    // Start each sensor individually
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        SKSensorType sensorType = i;
        
        if ([self isSensorRegistered:sensorType]) {
            
            if (![self startContinuousSensingWithSensor:sensorType error:error]) {
                
                // Error, return NO
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)stopContinuousSensingWithAllRegisteredSensors:(NSError **)error
{
    NSLog(@"Stop sensing with all registered sensors.");
    
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        SKSensorType sensorType = i;
        
        if ([self isSensorRegistered:sensorType]) {
            
            if (![self stopContinuousSensingWithSensor:sensorType error:error]) {
                
                // Error, return NO
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark private methods

- (SKAbstractSensor *)getSensor:(SKSensorType)sensorType
                          error:(NSError **)error
{
    // Sensor should be registered
    if (![self isSensorRegistered:sensorType]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Sensor is not registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotRegisteredError
                                     userInfo:userInfo];
        }
        return nil;
    }
    
    return self.sensors[sensorType];
}

+ (SKAbstractSensor *)createSensor:(SKSensorType)sensorType withConfiguration:(SKConfiguration *)configuration
{
    SKAbstractSensor *sensor;
    
    switch (sensorType) {
            
        case Accelerometer:
            sensor = [[SKAccelerometer alloc] initWithConfiguration:(SKAccelerometerConfiguration *)configuration];
            break;
            
        case Gyroscope:
            sensor = [[SKGyroscope alloc] initWithConfiguration:(SKGyroscopeConfiguration *)configuration];
            break;
            
        case Magnetometer:
            sensor = [[SKMagnetometer alloc] initWithConfiguration:(SKMagnetometerConfiguration *)configuration];
            break;
            
        case DeviceMotion:
            sensor = [[SKDeviceMotion alloc] initWithConfiguration:(SKDeviceMotionConfiguration *)configuration];
            break;
            
        case MotionActivity:
            sensor = [[SKMotionActivity alloc] initWithConfiguration:(SKMotionActivityConfiguration *)configuration];
            break;
            
        case Pedometer:
            sensor = [[SKPedometer alloc] initWithConfiguration:(SKPedometerConfiguration *)configuration];
            break;
            
        case Altimeter:
            sensor = [[SKAltimeter alloc] initWithConfiguration:(SKAltimeterConfiguration *)configuration];
            break;
            
        case Battery:
            sensor = [[SKBattery alloc] initWithConfiguration:(SKBatteryConfiguration *)configuration];
            break;
            
        case Location:
            sensor = [[SKLocation alloc] initWithConfiguration:(SKLocationConfiguration *)configuration];
            break;
        
        case Heading:
            sensor = [[SKHeading alloc] initWithConfiguration:(SKHeadingConfiguration *)configuration];
            break;
            
        case iBeaconProximity:
            sensor = [[SKiBeaconProximity alloc] initWithConfiguration:(SKiBeaconProximityConfiguration *)configuration];
            break;
            
        case EddystoneProximity:
            sensor = [[SKEddystoneProximity alloc] initWithConfiguration:(SKEddystoneProximityConfiguration *)configuration];
            break;
            
        case Microphone:
            sensor = [[SKMicrophone alloc] initWithConfiguration:(SKMicrophoneConfiguration *)configuration];
            break;
            
            // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Internal Error: Unknown Sensor: %li", (long)sensorType);
            abort();
    }
    
    return sensor;
}

+ (SKConfiguration *)defaultConfigurationForSensor:(SKSensorType)sensorType
{
    SKConfiguration *configuration;
    
    switch (sensorType) {
            
        case Accelerometer:
            configuration = [[SKAccelerometerConfiguration alloc] init];
            break;
            
        case Gyroscope:
            configuration = [[SKGyroscopeConfiguration alloc] init];
            break;
            
        case Magnetometer:
            configuration = [[SKMagnetometerConfiguration alloc] init];
            break;
            
        case DeviceMotion:
            configuration = [[SKDeviceMotionConfiguration alloc] init];
            break;
            
        case MotionActivity:
            configuration = [[SKMotionActivityConfiguration alloc] init];
            break;
            
        case Pedometer:
            configuration = [[SKPedometerConfiguration alloc] init];
            break;
            
        case Altimeter:
            configuration = [[SKAltimeterConfiguration alloc] init];
            break;
            
        case Battery:
            configuration = [[SKBatteryConfiguration alloc] init];
            break;

        case Location:
            configuration = [[SKLocationConfiguration alloc] init];
            break;
        
        case Heading:
            configuration = [[SKHeadingConfiguration alloc] init];
            break;
            
        case iBeaconProximity:
            configuration = [[SKiBeaconProximityConfiguration alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"eeb79aec-022f-4c05-8331-93d9b2ba6dce"]];
            break;
            
        case EddystoneProximity:
            configuration = [[SKEddystoneProximityConfiguration alloc] init];
            break;
            
        case Microphone:
            configuration = [[SKMicrophoneConfiguration alloc] initWithOutputDirectory:[SKSensorManager applicationDocumentsDirectory] withFilename:@"Recording"];
            break;
            
            // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Internal Error: Unknown Sensor: %li", (long)sensorType);
            abort();
    }
    
    return configuration;
}

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
}

@end
