//
//  SKDeviceMotionData.m
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

#import "SKDeviceMotionData.h"

@implementation SKDeviceMotionData

- (instancetype)initWithAattitude:(CMAttitude *)attitude
                      withGravity:(CMAcceleration)gravity
                withMagneticField:(CMCalibratedMagneticField)magneticField
                 withRotationRate:(CMRotationRate)rotationRate
             withUserAcceleration:(CMAcceleration)userAcceleration
{
    if (self = [super init])
    {
        _attitude = attitude;
        _gravity = gravity;
        _magneticField = magneticField;
        _rotationRate = rotationRate;
        _userAcceleration = userAcceleration;
    }
    return self;
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d, %f, %f, %f, %f, %f, %f",
            [self timestampEpoch],
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

@end
