//
//  SKiBeaconProximityConfiguration.m
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

#import "SKiBeaconProximityConfiguration.h"

@implementation SKiBeaconProximityConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        // Set default values
        _uuid = [[NSUUID alloc] initWithUUIDString:@"eeb79aec-022f-4c05-8331-93d9b2ba6dce"];
        _mode = SKiBeaconProximityModeScanOnly;
        _major = 65535;  // max supported value
        _minor = 65535;  // max supported value
        _measuredPower = nil;  // default
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKiBeaconProximityConfiguration *configuration = [super copyWithZone:zone];
    configuration.uuid = _uuid;
    configuration.mode = _mode;
    configuration.major = _major;
    configuration.minor = _minor;
    configuration.measuredPower = _measuredPower;
    
    return configuration;
}

@end
