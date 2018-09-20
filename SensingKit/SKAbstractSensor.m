//
//  SKAbstractSensor.m
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
#import "SKAbstractSensor.h"
#import "SKErrors.h"


@interface SKAbstractSensor()

@property (nonatomic, strong) NSMutableArray *sensorDataListeners;

@end


@implementation SKAbstractSensor

- (BOOL)subscribeHandler:(SKSensorDataHandler)handler error:(NSError **)error
{
    // Register the callback
    if ([self.sensorDataListeners containsObject:handler]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"SKSensorDataHandler already registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKDataHandlerAlreadyRegistered
                                     userInfo:userInfo];
        }
        
        return NO;
    }
    
    [self.sensorDataListeners addObject:handler];
    
    return YES;
}

- (BOOL)unsubscribeHandler:(SKSensorDataHandler)handler error:(NSError **)error
{
    // Unregister the callback
    if (![self.sensorDataListeners containsObject:handler]) {
        
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"SKSensorDataHandler is not registered.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKDataHandlerAlreadyRegistered
                                     userInfo:userInfo];
        }
        
        return NO;
    }
    
    [self.sensorDataListeners removeObject:handler];
    
    return YES;
}

- (void)unsubscribeAllHandlers
{
    [self.sensorDataListeners removeAllObjects];
}

- (BOOL)startSensing:(NSError **)error
{
    _sensing = YES;
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    _sensing = NO;
    
    return YES;
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

- (void)submitSensorData:(SKSensorData *)data error:(NSError *)error
{
    if ([self shouldPostSensorData:data]) {
        
        if (self.sensorDataListeners.count) {
            
            // CallBack with data and error as parameters
            for (SKSensorDataHandler handler in self.sensorDataListeners) {
                handler(self.sensorType, data, error);
            }
            
        }
    }
}

- (NSUInteger)handlersCount
{
    return self.sensorDataListeners.count;
}

@end
