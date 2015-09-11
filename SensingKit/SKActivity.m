//
//  SKActivity.m
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

#import "SKActivity.h"
#import "SKActivityData.h"

@import CoreMotion;


@interface SKActivity ()

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;

@end


@implementation SKActivity

- (instancetype)initWithConfiguration:(SKActivityConfiguration *)configuration
{
    if (self = [super initWithConfiguration:configuration])
    {
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    // Check if the correct configuration type provided
    if (configuration.class != SKActivityConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor Activity.", configuration.class);
        abort();
    }
    
    if (super.configuration != configuration)
    {
        super.configuration = configuration;
        
        // Cast the configuration instance
        // SKActivityConfiguration *activityConfiguration = (SKActivityConfiguration *)configuration;
        
        // Make the required updates on the sensor
        //
    }
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [CMMotionActivityManager isActivityAvailable];
}

- (void)startSensing
{
    [super startSensing];
    
    if ([CMMotionActivityManager isActivityAvailable])
    {
        [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue]
                                                    withHandler:^(CMMotionActivity *activity) {
                                                        SKActivityData *data = [[SKActivityData alloc] initWithActivity:activity];
                                                        [self submitSensorData:data];
                                                    }];
    }
    else
    {
        NSLog(@"DeviceMotion Sensing is not available.");
        abort();
    }
}

- (void)stopSensing
{
    [self.motionActivityManager stopActivityUpdates];
    
    [super stopSensing];
}

@end
