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

- (instancetype)init
{
    if (self = [super init])
    {
        self.motionManager = [SKMotionManager sharedMotionManager];
        self.motionManager.gyroUpdateInterval = 1.0/100;
    }
    return self;
}

+ (BOOL)isSensorModuleAvailable
{
    return [SKMotionManager sharedMotionManager].isGyroAvailable;
}

- (void)startSensing
{
    [super startSensing];
    
    if ([self.motionManager isGyroAvailable])
    {
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                            
                                            if (error) {
                                                NSLog(@"%@", error.localizedDescription);
                                            } else {
                                                SKGyroscopeData *data = [[SKGyroscopeData alloc] initWithRotationRate:gyroData.rotationRate];
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
