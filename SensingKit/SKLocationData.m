//
//  SKLocationData.m
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

#import "SKLocationData.h"

@implementation SKLocationData

- (instancetype)initWithLocation:(CLLocation *)location
{
    if (self = [super initWithTimestamp:location.timestamp])
    {
        _location = location;
    }
    return self;
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f,%f",
            [self timestampEpoch],
            _location.coordinate.latitude,
            _location.coordinate.longitude,
            _location.altitude,
            _location.horizontalAccuracy,
            _location.verticalAccuracy,
            _location.speed,
            _location.course];
}

@end
