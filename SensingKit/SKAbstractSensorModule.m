//
//  SKAbstractSensorModule.m
//  SensingKit
//
//  Created by Minos Katevas on 13/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import "SKAbstractSensorModule.h"

@interface SKAbstractSensorModule()

@property (nonatomic, strong) NSMutableArray *sensorDataListeners;

@end

@implementation SKAbstractSensorModule

- (void)subscribeSensorDataListener:(SKSensorDataHandler)handler
{
    // Register the callback
    if ([self.sensorDataListeners containsObject:handler]) {
        NSLog(@"SKSensorDataHandler already registered.");
    }
    
    [self.sensorDataListeners addObject:handler];
}

- (void)unsubscribeSensorDataListener:(SKSensorDataHandler)handler
{
    // Unregister the callback
    if (![self.sensorDataListeners containsObject:handler]) {
        NSLog(@"SKSensorDataHandler is not registered.");
    }
    
    [self.sensorDataListeners removeObject:handler];
}

- (void)unsubscribeAllSensorDataListeners
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
        
        if ([self.sensorDataListeners count]) {
            
            // CallBack with data as parameter
            for (SKSensorDataHandler handler in self.sensorDataListeners) {
                handler(self.moduleType, data);
            }
            
        }
    }
}

@end
