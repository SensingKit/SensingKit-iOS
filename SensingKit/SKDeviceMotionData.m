//
//  SKDeviceMotionData.m
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

#import "SKDeviceMotionData.h"

@implementation SKDeviceMotionData

- (instancetype)initWithDeviceMotion:(CMDeviceMotion *)motion
{
    if (self = [super initWithSensorType:DeviceMotion
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:motion.timestamp]])
    {
        _attitude = motion.attitude;
        _gravity = motion.gravity;
        _magneticField = motion.magneticField;
        _rotationRate = motion.rotationRate;
        _userAcceleration = motion.userAcceleration;
    }
    return self;
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,attitude.roll,attitude.pitch,attitude.yaw,gravity.x,gravity.y,gravity.z,magneticField.x,magneticField.y,magneticField.z,magneticField.accuracy,rotationRate.x,rotationRate.y,rotationRate.z,userAcceleration.x,userAcceleration.y,userAcceleration.z";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%f,%f,%f,%f,%f,%f",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            _attitude.roll,
            _attitude.pitch,
            _attitude.yaw,
            _gravity.x,
            _gravity.y,
            _gravity.z,
            _magneticField.field.x,
            _magneticField.field.y,
            _magneticField.field.z,
            _magneticField.accuracy,
            _rotationRate.x,
            _rotationRate.y,
            _rotationRate.z,
            _userAcceleration.x,
            _userAcceleration.y,
            _userAcceleration.z];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"timestamp": self.timestamp.timestampDictionary,
             @"attitude": @{
                     @"roll": @(_attitude.roll),
                     @"pitch": @(_attitude.pitch),
                     @"yaw": @(_attitude.yaw)
                     },
             @"gravity": @{
                     @"x": @(_gravity.x),
                     @"y": @(_gravity.y),
                     @"z": @(_gravity.z)
                     },
             @"calibratedMagneticField": @{
                     @"field": @{
                             @"x": @(_magneticField.field.x),
                             @"y": @(_magneticField.field.y),
                             @"z": @(_magneticField.field.z)
                             },
                     @"accuracy" : @(_magneticField.accuracy)
                     },
             @"rotationRate": @{
                     @"x": @(_rotationRate.x),
                     @"y": @(_rotationRate.y),
                     @"z": @(_rotationRate.z)
                     },
             @"userAcceleration": @{
                     @"x": @(_userAcceleration.x),
                     @"y": @(_userAcceleration.y),
                     @"z": @(_userAcceleration.z)
                     }
             };
}

@end
