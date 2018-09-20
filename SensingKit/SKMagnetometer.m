//
//  SKMagnetometer.m
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

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKMagnetometer isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Magnetometer sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
                                                
                                                if (error) {
                                                    [self submitSensorData:nil error:error];
                                                } else {
                                                    SKMagnetometerData *data = [[SKMagnetometerData alloc] initWithMagnetometerData:magnetometerData];
                                                    [self submitSensorData:data error:NULL];
                                                }
                                                
                                            }];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.motionManager stopMagnetometerUpdates];
    
    return [super stopSensing:error];
}

@end
