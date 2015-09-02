//
//  SKSensorManager.m
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

#import "SKSensorManager.h"
#import "SKAbstractSensor.h"
#import "NSString+SensorType.h"

// Sensors
#import "SKAccelerometer.h"
#import "SKGyroscope.h"
#import "SKMagnetometer.h"
#import "SKDeviceMotion.h"
#import "SKActivity.h"
#import "SKPedometer.h"
#import "SKAltimeter.h"
#import "SKBattery.h"
#import "SKLocation.h"
#import "SKiBeaconProximity.h"
#import "SKEddystoneProximity.h"

// SensorData
#import "SKAccelerometerData.h"
#import "SKGyroscopeData.h"
#import "SKMagnetometerData.h"
#import "SKDeviceMotionData.h"
#import "SKActivityData.h"
#import "SKPedometerData.h"
#import "SKAltimeterData.h"
#import "SKBatteryData.h"
#import "SKLocationData.h"
#import "SKBeaconDeviceData.h"
#import "SKEddystoneProximityData.h"

#define TOTAL_SENSORS 11

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
        
        for (NSInteger i = 0; i < TOTAL_SENSORS; i++) {
            [_sensors addObject:[NSNull null]];
        }
    }
    return self;
}

- (NSString *)csvHeaderForSensor:(SKSensorType)sensorType
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
            
        case Activity:
            return [SKActivityData csvHeader];
            
        case Pedometer:
            return [SKPedometerData csvHeader];
            
        case Altimeter:
            return [SKAltimeterData csvHeader];
            
        case Battery:
            return [SKBatteryData csvHeader];
            
        case Location:
            return [SKLocationData csvHeader];
            
        case iBeaconProximity:
            return [SKBeaconDeviceData csvHeader];
            
        case EddystoneProximity:
            return [SKEddystoneProximityData csvHeader];
            
        default:
            NSLog(@"Unknown Sensor: %li", (long)sensorType);
            abort();
    }
}

- (BOOL)isSensorAvailable:(SKSensorType)sensorType
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
            
        case Activity:
            return [SKActivity isSensorAvailable];
            
        case Pedometer:
            return [SKPedometer isSensorAvailable];
            
        case Altimeter:
            return [SKAltimeter isSensorAvailable];
            
        case Battery:
            return [SKBattery isSensorAvailable];
            
        case Location:
            return [SKLocation isSensorAvailable];
            
        case iBeaconProximity:
            return [SKiBeaconProximity isSensorAvailable];
            
        case EddystoneProximity:
            return [SKEddystoneProximity isSensorAvailable];
            
        default:
            NSLog(@"Unknown Sensor: %li", (long)sensorType);
            abort();
    }
    
    return NO;
}

#pragma mark Sensor Registration methods

- (void)registerSensor:(SKSensorType)sensorType
{
    NSLog(@"Register sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    if ([self isSensorRegistered:sensorType]) {
        
        NSLog(@"Sensor is already registered.");
        abort();
    }
    
    SKAbstractSensor *sensor = [self createSensor:sensorType];
    [self.sensors replaceObjectAtIndex:sensorType withObject:sensor];
}

- (void)deregisterSensor:(SKSensorType)sensorType
{
    NSLog(@"Deregister sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    if (![self isSensorRegistered:sensorType]) {
        
        NSLog(@"Sensor is not registered.");
        abort();
    }
    
    if ([self isSensorSensing:sensorType]) {
        
        NSLog(@"Sensor is currently sensing.");
        abort();
    }
    
    // Clear all Callbacks from that sensor
    [[self getSensor:sensorType] unsubscribeAllSensorDataListeners];
    
    // Deregister the Sensor
    [self.sensors replaceObjectAtIndex:sensorType withObject:[NSNull null]];
}

- (BOOL)isSensorRegistered:(SKSensorType)sensorType
{
    return ([self.sensors objectAtIndex:sensorType] != [NSNull null]);
}


#pragma mark Continuous Sensing methods

- (void)subscribeSensorDataListenerToSensor:(SKSensorType)sensorType
                                withHandler:(SKSensorDataHandler)handler {
    
    NSLog(@"Subscribe to sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    [[self getSensor:sensorType] subscribeSensorDataListener:handler];
}

- (void)unsubscribeSensorDataListenerFromSensor:(SKSensorType)sensorType
                                      ofHandler:(SKSensorDataHandler)handler
{
    NSLog(@"Unsubscribe from sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    [[self getSensor:sensorType] unsubscribeSensorDataListener:handler];
}

- (void)unsubscribeAllSensorDataListeners:(SKSensorType)sensorType
{
    NSLog(@"Unsubscribe from all sensors.");
    
    [[self getSensor:sensorType] unsubscribeAllSensorDataListeners];
}

- (void)startContinuousSensingWithSensor:(SKSensorType)sensorType
{
    NSLog(@"Start sensing with sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    if ([self isSensorSensing:sensorType]) {
        
        NSLog(@"Sensor '%@' is already sensing.", [NSString stringWithSensorType:sensorType]);
        abort();
    }
    
    // Start Sensing
    [[self getSensor:sensorType] startSensing];
}

- (void)stopContinuousSensingWithSensor:(SKSensorType)sensorType
{
    NSLog(@"Stop sensing with sensor: %@.", [NSString stringWithSensorType:sensorType]);
    
    if (![self isSensorSensing:sensorType]) {
        
        NSLog(@"Sensor '%@' is already not sensing.", [NSString stringWithSensorType:sensorType]);
        abort();
    }
    
    // Stop Sensing
    [[self getSensor:sensorType] stopSensing];
}

- (void)startContinuousSensingWithAllRegisteredSensors
{
    for (NSInteger i = 0; i < TOTAL_SENSORS; i++) {
        
        SKSensorType sensorType = i;
        
        if ([self isSensorRegistered:sensorType]) {
            [self startContinuousSensingWithSensor:sensorType];
        }
    }
}

- (void)stopContinuousSensingWithAllRegisteredSensors
{
    for (NSInteger i = 0; i < TOTAL_SENSORS; i++) {
        
        SKSensorType sensorType = i;
        
        if ([self isSensorRegistered:sensorType]) {
            [self stopContinuousSensingWithSensor:sensorType];
        }
    }
}

- (BOOL)isSensorSensing:(SKSensorType)sensorType
{
    return [[self getSensor:sensorType] isSensing];
}


- (SKAbstractSensor *)getSensor:(SKSensorType)sensorType
{
    if (![self isSensorRegistered:sensorType]) {
        
        NSLog(@"Sensor '%@' is not registered.", [NSString stringWithSensorType:sensorType]);
        abort();
    }
    
    return [self.sensors objectAtIndex:sensorType];
}

- (SKAbstractSensor *)createSensor:(SKSensorType)sensorType
{
    SKAbstractSensor *sensor;
    
    switch (sensorType) {
            
        case Accelerometer:
            sensor = [[SKAccelerometer alloc] init];
            break;
            
        case Gyroscope:
            sensor = [[SKGyroscope alloc] init];
            break;
            
        case Magnetometer:
            sensor = [[SKMagnetometer alloc] init];
            break;
            
        case DeviceMotion:
            sensor = [[SKDeviceMotion alloc] init];
            break;
            
        case Activity:
            sensor = [[SKActivity alloc] init];
            break;
            
        case Pedometer:
            sensor = [[SKPedometer alloc] init];
            break;
            
        case Altimeter:
            sensor = [[SKAltimeter alloc] init];
            break;
            
        case Battery:
            sensor = [[SKBattery alloc] init];
            break;
            
        case Location:
            sensor = [[SKLocation alloc] init];
            break;
            
        case iBeaconProximity:
            sensor = [[SKiBeaconProximity alloc] initWithUUID:[[NSUUID alloc] initWithUUIDString:@"d45a1046-15b0-11e5-b60b-1697f925ec7b"]
                                                    withMajor:arc4random_uniform(65535)    // Random Major
                                                    withMinor:arc4random_uniform(65535)];  // Random Minor
            break;
            
        case EddystoneProximity:
            // First 10 bytes of SHA1 'org.sensingkit.EddystoneIdentifier'
            sensor = [[SKEddystoneProximity alloc] initWithNamespaceFilter:@"90643f1a5253bff747fa"];
            break;
            
            // Don't forget to break!
            
        default:
            NSLog(@"Unknown Sensor: %li", (long)sensorType);
            abort();
    }
    
    return sensor;
}

@end
