//
//  SKProximityData.m
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

#import "SKProximityData.h"

@implementation SKProximityData

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(NSDate *)timestamp
                       withDevices:(NSArray *)devices
{
    if (self = [super initWithSensorType:sensorType
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromDate:timestamp]])
    {
        _devices = devices;
    }
    return self;
}

+ (NSString *)csvHeader
{
    // csvHeader depends on the encapsulated Device Data objects.
    return @"";
}

- (NSString *)csvString
{
    return [[self.devices valueForKey:@"description"] componentsJoinedByString:@"\n"];
}

- (NSDictionary *)dictionaryData
{
    // Get the dictionaries of all devices
    NSMutableArray *dictionaries = [[NSMutableArray alloc] initWithCapacity:self.devices.count];
    
    for (SKSensorData *device in self.devices) {
        [dictionaries addObject:device.dictionaryData];
    }
    
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"timestamp": self.timestamp.timestampDictionary,
             @"devices": dictionaries
             };
}

@end
