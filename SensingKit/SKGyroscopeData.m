//
//  SKGyroscopeData.m
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

#import "SKGyroscopeData.h"

@implementation SKGyroscopeData

- (instancetype)initWithRotationRate:(CMRotationRate)rotationRate
{
    if (self = [super initWithSensorModuleType:Gyroscope])
    {
        _rotationRate = rotationRate;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"timestamp,x,y,z";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"%f,%f,%f,%f",
            [self timestampEpoch],
            _rotationRate.x,
            _rotationRate.y,
            _rotationRate.z];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.moduleType),
             @"sensorTypeString": [NSString stringWithSensorModuleType:self.moduleType],
             @"timestamp": [SKSensorData timestampDictionaryFromData:self.timestamp],
             @"rotationRate": @{
                     @"x": @(_rotationRate.x),
                     @"y": @(_rotationRate.y),
                     @"z": @(_rotationRate.z)
                     }
             };
}

@end
