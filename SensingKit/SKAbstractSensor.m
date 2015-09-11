//
//  SKAbstractSensor.m
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
#import "SKAbstractSensor.h"


@interface SKAbstractSensor()

@property (nonatomic, strong) NSMutableArray *sensorDataListeners;

@end


@implementation SKAbstractSensor

- (void)subscribeHandler:(SKSensorDataHandler)handler
{
    // Register the callback
    if ([self.sensorDataListeners containsObject:handler]) {
        NSLog(@"SKSensorDataHandler already registered.");
    }
    
    [self.sensorDataListeners addObject:handler];
}

- (void)unsubscribeHandler:(SKSensorDataHandler)handler
{
    // Unregister the callback
    if (![self.sensorDataListeners containsObject:handler]) {
        NSLog(@"SKSensorDataHandler is not registered.");
    }
    
    [self.sensorDataListeners removeObject:handler];
}

- (void)unsubscribeAllHandlers
{
    [self.sensorDataListeners removeAllObjects];
}

- (void)startSensing
{
    _sensing = YES;
}

- (void)stopSensing
{
    _sensing = NO;
}

- (NSMutableArray *)sensorDataListeners
{
    if (!_sensorDataListeners) {
        _sensorDataListeners = [[NSMutableArray alloc] init];
    }
    return _sensorDataListeners;
}

- (BOOL)shouldPostSensorData:(SKSensorData *)data
{
    // This method can be overrided if needed.
    return YES;
}

- (void)submitSensorData:(SKSensorData *)data
{
    if ([self shouldPostSensorData:data]) {
        
        if (self.sensorDataListeners.count) {
            
            // CallBack with data as parameter
            for (SKSensorDataHandler handler in self.sensorDataListeners) {
                handler(self.sensorType, data);
            }
            
        }
    }
}

@end
