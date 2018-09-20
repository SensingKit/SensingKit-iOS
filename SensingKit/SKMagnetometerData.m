//
//  SKMagnetometerData.m
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

#import "SKMagnetometerData.h"

@implementation SKMagnetometerData

- (instancetype)initWithMagnetometerData:(CMMagnetometerData *)magnetometerData
{
    if (self = [super initWithSensorType:Magnetometer
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:magnetometerData.timestamp]])
    {
        _magneticField = magnetometerData.magneticField;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,x,y,z";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%f,%f,%f",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            _magneticField.x,
            _magneticField.y,
            _magneticField.z];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"timestamp": self.timestamp.timestampDictionary,
             @"magneticField": @{
                     @"x": @(_magneticField.x),
                     @"y": @(_magneticField.y),
                     @"z": @(_magneticField.z)
                     }
             };
}

@end
