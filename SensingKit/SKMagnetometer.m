//
//  SKMagnetometer.m
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

#import "SKMagnetometer.h"
#import "SKMotionManager.h"
#import "SKMagnetometerData.h"


@interface SKMagnetometer ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end


@implementation SKMagnetometer

- (instancetype)initWithConfiguration:(SKMagnetometerConfiguration *)configuration
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
    if (configuration.class != SKMagnetometerConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor Magnetometer.", configuration.class);
        abort();
    }
    
    super.configuration = configuration;
    
    // Cast the configuration instance
    SKMagnetometerConfiguration *magnetometerConfiguration = (SKMagnetometerConfiguration *)configuration;
    
    // Make the required updates on the sensor
    self.motionManager.magnetometerUpdateInterval = 1.0 / magnetometerConfiguration.sampleRate;  // Convert Hz into interval
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [SKMotionManager sharedMotionManager].isMagnetometerAvailable;
}

- (void)startSensing
{
    [super startSensing];
    
    if (self.motionManager.magnetometerAvailable)
    {
        [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                                                    
                                                    if (error) {
                                                        NSLog(@"%@", error.localizedDescription);
                                                    } else {
                                                        SKMagnetometerData *data = [[SKMagnetometerData alloc] initWithMagnetometerData:magnetometerData];
                                                        [self submitSensorData:data];
                                                    }
                                                    
                                                }];
    }
    else
    {
        NSLog(@"Magnetometer Sensor is not available.");
        abort();
    }
}

- (void)stopSensing
{
    [self.motionManager stopMagnetometerUpdates];
    
    [super stopSensing];
}

@end
