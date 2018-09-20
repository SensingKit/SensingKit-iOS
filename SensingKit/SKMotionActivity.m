//
//  SKMotionActivity.m
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

#import "SKMotionActivity.h"
#import "SKMotionActivityData.h"

@import CoreMotion;


@interface SKMotionActivity ()

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;

@end


@implementation SKMotionActivity

- (instancetype)initWithConfiguration:(SKMotionActivityConfiguration *)configuration
{
    if (self = [super init])
    {
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    super.configuration = configuration;
    
    // Cast the configuration instance
    // SKMotionActivityConfiguration *motionActivityConfiguration = (SKMotionActivityConfiguration *)configuration;
    
    // Make the required updates on the sensor
    //
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [CMMotionActivityManager isActivityAvailable];
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKMotionActivity isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"SKMotionActivity sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMMotionActivity *activity) {
                                                    SKMotionActivityData *data = [[SKMotionActivityData alloc] initWithMotionActivity:activity];
                                                    [self submitSensorData:data error:NULL];
                                                }];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.motionActivityManager stopActivityUpdates];
    
    return [super stopSensing:error];
}

@end
