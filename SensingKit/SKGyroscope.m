//
//  SKGyroscope.m
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

#import "SKGyroscope.h"
#import "SKMotionManager.h"
#import "SKGyroscopeData.h"


@interface SKGyroscope ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end


@implementation SKGyroscope

- (instancetype)initWithConfiguration:(SKGyroscopeConfiguration *)configuration
{
    if (self = [super init])
    {
        self.motionManager = [SKMotionManager sharedMotionManager];
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    // Check if the correct configuration type provided
    if (configuration.class != SKGyroscopeConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor Gyroscope.", configuration.class);
        abort();
    }
    
    super.configuration = configuration;
    
    // Cast the configuration instance
    SKGyroscopeConfiguration *gyroscopeConfiguration = (SKGyroscopeConfiguration *)configuration;
    
    // Make the required updates on the sensor
    self.motionManager.gyroUpdateInterval = 1.0 / gyroscopeConfiguration.sampleRate;  // Convert Hz into interval
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [SKMotionManager sharedMotionManager].isGyroAvailable;
}

- (void)startSensing
{
    [super startSensing];
    
    if (self.motionManager.gyroAvailable)
    {
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                            
                                            if (error) {
                                                NSLog(@"%@", error.localizedDescription);
                                            } else {
                                                SKGyroscopeData *data = [[SKGyroscopeData alloc] initWithGyroData:gyroData];
                                                [self submitSensorData:data];
                                            }
                                            
                                        }];
    }
    else
    {
        NSLog(@"Gyroscope Sensor is not available.");
        abort();
    }
}

- (void)stopSensing
{
    [self.motionManager stopGyroUpdates];
    
    [super stopSensing];
}

@end
