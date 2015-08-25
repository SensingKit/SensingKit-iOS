//
//  SKAccelerometer.m
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

#import "SKAccelerometer.h"
#import "SKMotionManager.h"
#import "SKAccelerometerData.h"

@interface SKAccelerometer ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation SKAccelerometer

- (instancetype)init
{
    if (self = [super init])
    {
        self.motionManager = [SKMotionManager sharedMotionManager];
        self.motionManager.accelerometerUpdateInterval = 1.0/100;
    }
    return self;
}

+ (BOOL)isSensorModuleAvailable
{
    return [SKMotionManager sharedMotionManager].isAccelerometerAvailable;
}

- (void)startSensing
{
    [super startSensing];
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     
                                                     if (error) {
                                                         NSLog(@"%@", error.localizedDescription);
                                                     } else {
                                                         SKAccelerometerData *data = [[SKAccelerometerData alloc] initWithAcceleration:accelerometerData.acceleration];
                                                         [self submitSensorData:data];
                                                     }
                                                     
                                                 }];
    }
    else
    {
        NSLog(@"Accelerometer Sensor is not available.");
        abort();
    }
}

- (void)stopSensing
{
    [self.motionManager stopAccelerometerUpdates];
    
    [super stopSensing];
}

@end
