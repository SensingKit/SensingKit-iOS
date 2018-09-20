//
//  SKAltimeterConfiguration.m
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

#import "SKAltimeterConfiguration.h"

@implementation SKAltimeterConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        // Set default values
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKAltimeterConfiguration *configuration = [super copyWithZone:zone];
    
    return configuration;
}

- (BOOL)isValidForSensor:(SKSensorType)sensorType
{
    return sensorType == Altimeter;
}


@end
