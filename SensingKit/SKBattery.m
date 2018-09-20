//
//  SKBattery.m
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

#import "SKBattery.h"
#import "SKBatteryData.h"


@implementation SKBattery

- (instancetype)initWithConfiguration:(SKBatteryConfiguration *)configuration
{
    if (self = [super init])
    {
        // Register for battery level and state change notifications.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryLevelChanged:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryStateChanged:)
                                                     name:UIDeviceBatteryStateDidChangeNotification object:nil];
        
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
    
    if (![SKBattery isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Battery sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    
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

- (void)batteryLevelChanged:(NSNotification *)notification
{
    SKBatteryData *data = [[SKBatteryData alloc] initWithLevel:[self batteryLevel]
                                                     withState:[self batteryState]];
    
    [self submitSensorData:data error:NULL];
}

- (void)batteryStateChanged:(NSNotification *)notification
{
    SKBatteryData *data = [[SKBatteryData alloc] initWithLevel:[self batteryLevel]
                                                     withState:[self batteryState]];
    
    [self submitSensorData:data error:NULL];
}

@end
