//
//  SKAltimeterData.m
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

#import "SKAltimeterData.h"

@implementation SKAltimeterData

- (instancetype)initWithAltitudeData:(CMAltitudeData *)altitudeData
{
    if (self = [super initWithSensorType:Altimeter
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:altitudeData.timestamp]])
    {
        _altitudeData = altitudeData;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,relativeAltitude,pressure";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%ld,%lu",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            (long)_altitudeData.relativeAltitude.integerValue,
            (unsigned long)_altitudeData.pressure.unsignedIntegerValue];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
            @"timestamp": self.timestamp.timestampDictionary,
             @"altitudeData": @{
                     @"relativeAltitude": _altitudeData.relativeAltitude,
                     @"pressure": _altitudeData.pressure
                     }
             };
}

@end
