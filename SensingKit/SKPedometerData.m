//
//  SKPedometerData.m
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

#import "SKPedometerData.h"

@implementation SKPedometerData

- (instancetype)initWithPedometerData:(CMPedometerData *)pedometerData
{
    if (self = [super initWithSensorModuleType:Pedometer])
    {
        _pedometerData = pedometerData;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"timestamp,startDate,endDate,numberOfSteps,distance,floorsAscended,floorsDescended";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"%f,%f,%f,%lu,%lu,%lu,%lu",
            [self timestampEpoch],
            _pedometerData.startDate.timeIntervalSince1970,
            _pedometerData.endDate.timeIntervalSince1970,
            (unsigned long)_pedometerData.numberOfSteps.unsignedIntegerValue,
            (unsigned long)_pedometerData.distance.unsignedIntegerValue,
            (unsigned long)_pedometerData.floorsAscended.unsignedIntegerValue,
            (unsigned long)_pedometerData.floorsDescended.unsignedIntegerValue];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.moduleType),
             @"sensorTypeString": [NSString stringWithSensorModuleType:self.moduleType],
             @"timestamp": [SKSensorData timestampDictionaryFromData:self.timestamp],
             @"pedometerData": @{
                     @"startDate": [SKSensorData timestampDictionaryFromData:_pedometerData.startDate],
                     @"endDate": [SKSensorData timestampDictionaryFromData:_pedometerData.endDate],
                     @"numberOfSteps": @(_pedometerData.numberOfSteps.unsignedIntegerValue),
                     @"distance": @(_pedometerData.distance.unsignedIntegerValue),
                     @"floorsAscended": @(_pedometerData.floorsAscended.unsignedIntegerValue),
                     @"floorsDescended": @(_pedometerData.floorsDescended.unsignedIntegerValue)
                     }
             };
}

@end
