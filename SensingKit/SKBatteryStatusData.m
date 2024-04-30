//
//  SKBatteryStatusData.m
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

#import "SKBatteryStatusData.h"

@implementation SKBatteryStatusData

- (instancetype)initWithLevel:(CGFloat)level
                    state:(UIDeviceBatteryState)state
            lowPowerModeState:(SKLowPowerModeState)lowPowerModeState
{
    if (self = [super initWithSensorType:BatteryStatus
                               timestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:[NSProcessInfo processInfo].systemUptime]])
    {
        _level = level;
        _state = state;
        _lowPowerModeState = lowPowerModeState;
    }
    return self;
}

- (NSString *)stateString
{
    switch (_state) {
        case UIDeviceBatteryStateCharging:
            return @"Charging";
            
        case UIDeviceBatteryStateFull:
            return @"Full";
            
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            
        case UIDeviceBatteryStateUnknown:
            return @"Unknown";
            
        default:
            NSLog(@"Warning: Unknown state: %d", (int)_state);
            return @"Unknown";
    }
}

- (NSString *)lowPowerModeStateString
{
    switch (_lowPowerModeState) {
            
        case SKLowPowerModeStateDisabled:
            return @"Disabled";
            
        case SKLowPowerModeStateEnabled:
            return @"Enabled";
            
        default:
            NSLog(@"Warning: Unknown lowPowerModeState: %d", (int)_lowPowerModeState);
            return @"Unknown";
    }
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,state,level,lowPowerModeState";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%@,%f,%@",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            self.stateString,
            _level,
            self.lowPowerModeStateString];
}

- (NSDictionary *)dictionaryData
{
    return @{
        @"sensorType": @(self.sensorType),
        @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
        @"timestamp": self.timestamp.timestampDictionary,
        @"battery": @{
            @"level": @(_level),
            @"state": @(_state),
            @"stateString": self.stateString,
            @"lowPowerModeState": @(_lowPowerModeState),
            @"lowPowerModeStateString": self.lowPowerModeStateString,
        }
    };
}

@end
