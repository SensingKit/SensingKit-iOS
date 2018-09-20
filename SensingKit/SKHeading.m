//
//  SKHeading.m
//  SensingKit
//
//  Copyright (c) 2017. Kleomenis Katevas
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

#import "SKHeading.h"
#import "SKHeadingData.h"

@import CoreLocation;


@interface SKHeading () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation SKHeading

- (instancetype)initWithConfiguration:(SKHeadingConfiguration *)configuration
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
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
    SKHeadingConfiguration *headingConfiguration = (SKHeadingConfiguration *)configuration;
    
    // Make the required updates on the sensor
    self.locationManager.headingFilter = headingConfiguration.headingFilter;
    self.locationManager.headingOrientation = headingConfiguration.headingOrientation;
}

#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [CLLocationManager headingAvailable];
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKHeading isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Heading sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.locationManager startUpdatingHeading];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.locationManager stopUpdatingHeading];
    
    return [super stopSensing:error];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(nonnull CLHeading *)newHeading
{
    // Ignore data if not accurate
    if (newHeading.headingAccuracy < 0)
        return;
    
    SKHeadingData *data = [[SKHeadingData alloc] initWithHeading:newHeading];
    [self submitSensorData:data error:NULL];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self submitSensorData:nil error:error];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    SKHeadingConfiguration *headingConfiguration = (SKHeadingConfiguration *)self.configuration;
    return headingConfiguration.displayHeadingCalibration;
}

@end
