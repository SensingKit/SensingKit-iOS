//
//  SKiBeaconDeviceData.m
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

#import "SKiBeaconDeviceData.h"

@implementation SKiBeaconDeviceData

- (instancetype)initWithTimestamp:(NSDate *)timestamp
                        withMajor:(uint16_t)major
                        withMinor:(uint16_t)minor
                     withAccuracy:(CLLocationAccuracy)accuracy
                    withProximity:(CLProximity)proximity
                         withRssi:(NSInteger)rssi
{
    if (self = [super initWithSensorType:iBeaconProximity
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromDate:timestamp]])
    {
        _major = major;
        _minor = minor;
        _accuracy = accuracy;
        _proximity = proximity;
        _rssi = rssi;
    }
    return self;
}

- (NSString *)proximityString
{
    switch (_proximity) {
        case CLProximityImmediate:
            return @"Immediate";

        case CLProximityNear:
            return @"Near";
            
        case CLProximityFar:
            return @"Far";
            
        case CLProximityUnknown:
            return @"Unknown";
            
        default:
            NSLog(@"Warning: Unknown proximity: %d", (int)_proximity);
            return @"Unknown";
    }
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,major,minor,accuracy,proximity,rssi";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%lu,%lu,%f,%@,%ld",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            (unsigned long)_major,
            (unsigned long)_minor,
            _accuracy,
            self.proximityString,
            (long)_rssi];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"timestamp": self.timestamp.timestampDictionary,
             @"iBeacon": @{
                     @"major": @(_major),
                     @"minor": @(_minor),
                     @"accuracy": @(_accuracy),
                     @"proximity": @(_proximity),
                     @"proximityString": self.proximityString,
                     @"rssi": @(_rssi)
                     }
             };
}

@end
