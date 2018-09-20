//
//  SKGyroscope.m
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

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKGyroscope isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Gyroscope sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        
                                        if (error) {
                                            [self submitSensorData:nil error:error];
                                        } else {
                                            SKGyroscopeData *data = [[SKGyroscopeData alloc] initWithGyroData:gyroData];
                                            [self submitSensorData:data error:NULL];
                                        }
                                        
                                    }];

    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
     [self.motionManager stopGyroUpdates];
    
    return [super stopSensing:error];
}

@end
