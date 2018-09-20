//
//  SKBatteryData.m
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

#import "SKBatteryData.h"

@implementation SKBatteryData

- (instancetype)initWithLevel:(CGFloat)level withState:(UIDeviceBatteryState)state
{
    if (self = [super initWithSensorType:Battery
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:[NSProcessInfo processInfo].systemUptime]])
    {
        _level = level;
        _state = state;
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

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,state,level";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%@,%f",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            self.stateString,
            _level];
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
                     @"stateString": self.stateString
                     }
             };
}

@end
