//
//  SensingKitLib.m
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

#import "SensingKitLib.h"
#import "SKSensorModuleManager.h"

@interface SensingKitLib()

@property (nonatomic, strong, readonly) SKSensorModuleManager *sensorModuleManager;

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
        // init sensorModuleManager
        _sensorModuleManager = [[SKSensorModuleManager alloc] init];
    }
    return self;
}


#pragma mark Sensor Registration methods

- (void)registerSensorModule:(SKSensorModuleType)moduleType
{
    [self.sensorModuleManager registerSensorModule:moduleType];
}

- (void)deregisterSensorModule:(SKSensorModuleType)moduleType
{
    [self.sensorModuleManager deregisterSensorModule:moduleType];
}

- (BOOL)isSensorModuleRegistered:(SKSensorModuleType)moduleType
{
    return [self.sensorModuleManager isSensorModuleRegistered:moduleType];;
}


#pragma mark Continuous Sensing methods

- (void)subscribeSensorDataListenerToSensor:(SKSensorModuleType)moduleType
                                withHandler:(SKSensorDataHandler)handler
{
    [self.sensorModuleManager subscribeSensorDataListenerToSensor:moduleType
                                                      withHandler:handler];
}

- (void)unsubscribeSensorDataListenerFromSensor:(SKSensorModuleType)moduleType
                                      ofHandler:(SKSensorDataHandler)handler
{
    [self.sensorModuleManager unsubscribeSensorDataListenerFromSensor:moduleType
                                                            ofHandler:handler];
}

- (void)unsubscribeAllSensorDataListeners:(SKSensorModuleType)moduleType
{
    [self.sensorModuleManager unsubscribeAllSensorDataListeners:moduleType];
}

- (void)startContinuousSensingWithSensor:(SKSensorModuleType)moduleType
{
    [self.sensorModuleManager startContinuousSensingWithSensor:moduleType];
}

- (void)stopContinuousSensingWithSensor:(SKSensorModuleType)moduleType
{
    [self.sensorModuleManager stopContinuousSensingWithSensor:moduleType];
}

- (BOOL)isSensorModuleSensing:(SKSensorModuleType)moduleType
{
    return [self.sensorModuleManager isSensorModuleSensing:moduleType];
}

@end
