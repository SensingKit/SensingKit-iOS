//
//  SKScreenStatus.m
//  SensingKit
//
//  Copyright (c) 2016. Queen Mary University of London
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


#import "SKScreenStatus.h"
#import "SKScreenStatusData.h"

@implementation SKScreenStatus


- (instancetype)initWithConfiguration:(SKScreenStatusConfiguration *)configuration
{
    if (self = [super init])
    {
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    // Check if the correct configuration type provided
    if (configuration.class != SKScreenStatusConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor Screen Status.", configuration.class);
        abort();
    }
    
    super.configuration = configuration;
    
    // Cast the configuration instance
    // SKBatteryConfiguration *batteryConfiguration = (SKBatteryConfiguration *)configuration;
    
    // Make the required updates on the sensor
    //
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    // Always available
    return YES;
}

- (void)startSensing
{
    [super startSensing];
    
    [self registerDeviceLockNotificationListener];
}

- (void)stopSensing
{
    [self unregisterDeviceLockNotificationListener];
    
    [super stopSensing];
}

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // Thanks to:
    // http://stackoverflow.com/questions/14229955/is-there-a-way-to-check-if-the-ios-device-is-locked-unlocked/14271472#14271472
    CFStringRef nameCFString = (CFStringRef)name;
    NSString *lockState = (__bridge NSString *)nameCFString;
    NSLog(@"Darwin notification NAME = %@",name);
    
    if ([lockState isEqualToString:@"com.apple.springboard.lockcomplete"])
    {
        NSLog(@"DEVICE LOCKED");
        //Logic to disable the GPS
    }
    else
    {
        NSLog(@"LOCK STATUS CHANGED");
        //Logic to enable the GPS
    }
}

- (void)registerDeviceLockNotificationListener
{
    //Screen lock notifications
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockstate"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)unregisterDeviceLockNotificationListener
{
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                       NULL,
                                       CFSTR("com.apple.springboard.lockcomplete"),
                                       NULL);
    
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                       NULL,
                                       CFSTR("com.apple.springboard.lockstate"),
                                       NULL);
}

@end
