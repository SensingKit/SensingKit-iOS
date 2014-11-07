//
//  KKLocationSensing.m
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

#import "KKLocationSensing.h"

@interface KKLocationSensing ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation KKLocationSensing

- (id)init
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  // kCLLocationAccuracyBestForNavigation??
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return self;
}

- (BOOL)isLocationSensingAvailable
{
    return [CLLocationManager locationServicesEnabled];
}

#pragma mark start / stop sensing

- (void)startLocationSensing
{
    if ([self isLocationSensingAvailable])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopLocationSensing
{
    if ([self isLocationSensingAvailable])
    {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        [self.delegate locationUpdateReceived:location];
    }
}

@end
