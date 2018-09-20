//
//  SensingKitLib.m
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

#import "SensingKitLib.h"
#import "SKSensorManager.h"

@interface SensingKitLib()

@property (nonatomic, strong, readonly) SKSensorManager *sensorManager;

@end

@implementation SensingKitLib

+ (SensingKitLib *)sharedSensingKitLib
{
    static SensingKitLib *sensingKitLib;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sensingKitLib = [[self alloc] init];
    });
    return sensingKitLib;
}

- (instancetype)init
{
    if (self = [super init])
    {
        // init sensorManager
        _sensorManager = [[SKSensorManager alloc] init];
    }
    return self;
}


#pragma mark Sensor Status methods

- (BOOL)isSensorAvailable:(SKSensorType)sensorType
{
    return [SKSensorManager isSensorAvailable:sensorType];
}

- (BOOL)isSensorRegistered:(SKSensorType)sensorType
{
    return [self.sensorManager isSensorRegistered:sensorType];
}

- (BOOL)isSensorSensing:(SKSensorType)sensorType
{
    return [self.sensorManager isSensorSensing:sensorType];
}


#pragma mark Sensor Registration and Configuration methods

- (BOOL)registerSensor:(SKSensorType)sensorType
                 error:(NSError * _Nullable * _Nullable)error
{
    return [self registerSensor:sensorType withConfiguration:nil error:error];
}

- (BOOL)registerSensor:(SKSensorType)sensorType
     withConfiguration:(SKConfiguration *)configuration
                 error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager registerSensor:sensorType withConfiguration:configuration error:error];
}

- (BOOL)deregisterSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager deregisterSensor:sensorType error:error];
}

- (BOOL)setConfiguration:(SKConfiguration *)configuration
                toSensor:(SKSensorType)sensorType
                   error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager setConfiguration:configuration toSensor:sensorType error:error];
}

- (SKConfiguration *)getConfigurationFromSensor:(SKSensorType)sensorType
                                          error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager getConfigurationFromSensor:sensorType error:error];
}


#pragma mark Sensor Subscription and Unsubscription methods

- (BOOL)subscribeToSensor:(SKSensorType)sensorType
              withHandler:(SKSensorDataHandler)handler
                    error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager subscribeToSensor:sensorType
                                     withHandler:handler
                                           error:error];
}

- (BOOL)unsubscribeAllHandlersFromSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager unsubscribeAllHandlersFromSensor:sensorType
                                                          error:error];
}

- (NSString *)csvHeaderForSensor:(SKSensorType)sensorType
{
    return [SKSensorManager csvHeaderForSensor:sensorType];
}


#pragma mark Continuous Sensing methods

- (BOOL)startContinuousSensingWithSensor:(SKSensorType)sensorType
                                   error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager startContinuousSensingWithSensor:sensorType
                                                          error:error];
}

- (BOOL)stopContinuousSensingWithSensor:(SKSensorType)sensorType
                                  error:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager stopContinuousSensingWithSensor:sensorType
                                                         error:error];
}

- (BOOL)startContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager startContinuousSensingWithAllRegisteredSensors:error];
}

- (BOOL)stopContinuousSensingWithAllRegisteredSensors:(NSError * _Nullable * _Nullable)error
{
    return [self.sensorManager stopContinuousSensingWithAllRegisteredSensors:error];
}

@end
