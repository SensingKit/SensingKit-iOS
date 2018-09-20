//
//  SKLocation.m
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

#import "SKLocation.h"
#import "SKLocationData.h"

@import CoreLocation;


@interface SKLocation () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation SKLocation

- (instancetype)initWithConfiguration:(SKLocationConfiguration *)configuration
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        #if !TARGET_IPHONE_SIMULATOR
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        #endif
        
        self.locationManager.delegate = self;
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    super.configuration = configuration;
    
    // Cast the configuration instance
    SKLocationConfiguration *locationConfiguration = (SKLocationConfiguration *)configuration;
    
    // Make the required updates on the sensor
    self.locationManager.distanceFilter = locationConfiguration.distanceFilter;
    [self updateAccuracy:locationConfiguration.locationAccuracy];
    [self updateAuthorization:locationConfiguration.locationAuthorization];
}

- (void)updateAccuracy:(SKLocationAccuracy)accuracy
{
    switch (accuracy)
    {
        case SKLocationAccuracyBestForNavigation:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            break;
            
        case SKLocationAccuracyBest:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            break;
            
        case SKLocationAccuracyNearestTenMeters:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            break;
            
        case SKLocationAccuracyHundredMeters:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            break;
            
        case SKLocationAccuracyKilometer:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            break;
            
        case SKLocationAccuracyThreeKilometers:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            break;
            
        // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Unknown SKLocationAccuracy: %lu", (unsigned long)accuracy);
            abort();
    }
}

- (void)updateAuthorization:(SKLocationAuthorization)authorization
{
    switch (authorization)
    {
        case SKLocationAuthorizationWhenInUse:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            
            if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                self.locationManager.allowsBackgroundLocationUpdates = NO;
            }
            break;
            
        case SKLocationAuthorizationAlways:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            
            if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                self.locationManager.allowsBackgroundLocationUpdates = YES;
            }
            break;
            
        // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Unknown SKLocationAuthorization: %lu", (unsigned long)authorization);
            abort();
    }
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [CLLocationManager locationServicesEnabled];
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKLocation isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Location sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.locationManager stopUpdatingLocation];
    
    return [super stopSensing:error];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        SKLocationData *data = [[SKLocationData alloc] initWithLocation:location];
        
        [self submitSensorData:data error:NULL];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self submitSensorData:nil error:error];
}

@end
