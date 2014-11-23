//
//  SKBatterySensing.m
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

#import "SKBatterySensing.h"

@implementation SKBatterySensing

- (instancetype)init
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
    }
    return self;
}

- (void)startBatterySensing
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
}

- (void)stopBatterySensing
{
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
}

- (CGFloat)batteryLevel
{
    return [[UIDevice currentDevice] batteryLevel];
}

- (UIDeviceBatteryState)batteryState
{
    return [[UIDevice currentDevice] batteryState];
}

- (void)batteryLevelChanged:(NSNotification *)notification
{
    [self.delegate batteryLevelChanged:[self batteryState] level:[self batteryLevel]];
}

- (void)batteryStateChanged:(NSNotification *)notification
{
    [self.delegate batteryStateChanged:[self batteryState] level:[self batteryLevel]];
}

@end
