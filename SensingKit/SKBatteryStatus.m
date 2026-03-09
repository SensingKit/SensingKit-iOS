//
//  SKBatteryStatus.m
//  SensingKit
//
//  Copyright (c) 2014. Kleomenis Katevas
//  Kleomenis Katevas, minos.kat@gmail.com
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

#import "SKBatteryStatus.h"
#import "SKBatteryStatusData.h"


@implementation SKBatteryStatus

- (instancetype)initWithConfiguration:(SKBatteryStatusConfiguration *)configuration
{
    if (self = [super init])
    {
        // Register for battery level and state change notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batterySensorStateChanged:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batterySensorStateChanged:)
                                                     name:UIDeviceBatteryStateDidChangeNotification object:nil];
        
        // powerModeChanged: will be registered later (on startSensing:)
        
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    super.configuration = configuration;
    
    // Cast the configuration instance
    // SKBatteryConfiguration *batteryConfiguration = (SKBatteryConfiguration *)configuration;
    
    // Make the required updates on the sensor
    //
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    // Always available
    return YES;
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKBatteryStatus isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey: NSLocalizedString(@"Battery Status sensor is not available.", nil),
            };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // start receiving battery level and state change notifications
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    // start receiving powerModeChanged related notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batterySensorStateChanged:)
                                                 name:NSProcessInfoPowerStateDidChangeNotification
                                               object:nil];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    // stop receiving battery level and state change notifications
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    
    // stop receiving powerModeChanged related notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSProcessInfoPowerStateDidChangeNotification
                                                  object:nil];
    
    return [super stopSensing:error];
}

- (CGFloat)batteryLevel
{
    return [UIDevice currentDevice].batteryLevel;
}

- (UIDeviceBatteryState)batteryState
{
    return [UIDevice currentDevice].batteryState;
}

- (SKLowPowerModeState)lowPowerModeState
{
    if ([[NSProcessInfo processInfo] isLowPowerModeEnabled])
    {
        return SKLowPowerModeStateEnabled;
    }
    else
    {
        return SKLowPowerModeStateDisabled;
    }
}

- (void)batterySensorStateChanged:(NSNotification *)notification
{
    SKBatteryStatusData *data = [[SKBatteryStatusData alloc] initWithLevel:[self batteryLevel]
                                                                     state:[self batteryState]
                                                         lowPowerModeState:[self lowPowerModeState]];
    
    [self submitSensorData:data error:NULL];
}

@end
