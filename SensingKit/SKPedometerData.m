//
//  SKPedometerData.m
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

#import "SKPedometerData.h"

@implementation SKPedometerData

- (instancetype)initWithPedometerData:(CMPedometerData *)pedometerData
{
    if (self = [super initWithSensorType:Pedometer
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromDate:pedometerData.startDate]])
    {
        // No need to have two instances of the same timestamp. We point startDate to self.timestamp
        _startDate = self.timestamp;
        _endDate = [SKSensorTimestamp sensorTimestampFromDate:pedometerData.endDate];
        _pedometerData = pedometerData;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"startTimestamp,startTimeIntervalSince1970,endTimestamp,endTimeIntervalSince1970,numberOfSteps,distance,currentPace,currentCadence,floorsAscended,floorsDescended";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,\"%@\",%f,%lu,%lu,%lu,%lu,%lu,%lu",
            self.startDate.timestampString,
            self.startDate.timeIntervalSince1970,
            self.endDate.timestampString,
            self.endDate.timeIntervalSince1970,
            (unsigned long)_pedometerData.numberOfSteps.unsignedIntegerValue,
            (unsigned long)_pedometerData.distance.unsignedIntegerValue,
            (unsigned long)_pedometerData.currentPace.unsignedIntegerValue,
            (unsigned long)_pedometerData.currentCadence.unsignedIntegerValue,
            (unsigned long)_pedometerData.floorsAscended.unsignedIntegerValue,
            (unsigned long)_pedometerData.floorsDescended.unsignedIntegerValue];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"startDate": self.startDate.timestampDictionary,
             @"endDate": self.endDate.timestampDictionary,
             @"pedometerData": @{
                     @"numberOfSteps": _pedometerData.numberOfSteps,
                     @"distance": _pedometerData.distance,
                     @"currentPace": _pedometerData.currentPace,
                     @"currentCadence": _pedometerData.currentCadence,
                     @"floorsAscended": _pedometerData.floorsAscended,
                     @"floorsDescended": _pedometerData.floorsDescended
                     }
             };
}

@end
