//
//  SensingKitLib.m
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

#import "SensingKitLib.h"

#import "KKModelManager.h"

#import "KKiBeaconSensing.h"
#import "KKLocationSensing.h"
#import "KKMotionSensing.h"
#import "KKBatterySensing.h"

@interface SensingKitLib()

@property (nonatomic, strong) KKModelManager *modelManager;

@property (nonatomic, strong) KKiBeaconSensing  *iBeaconSensing;
@property (nonatomic, strong) KKLocationSensing *locationSensing;
@property (nonatomic, strong) KKMotionSensing   *motionSensing;
@property (nonatomic, strong) KKBatterySensing  *batterySensing;

@property (nonatomic, strong) NSUUID *uuid;

@property (nonatomic) CGFloat brightness;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SensingKitLib

- (id)initWithUUID:(NSUUID *)uuid
         serverUrl:(NSURL *)url
{
    if (self = [super init])
    {
        // init Model Manager
        KKModelManager *modelManager = [[KKModelManager alloc] init];
        modelManager.interval = 60;  // Default value
        self.modelManager = modelManager;
        
        self.uuid = uuid;
        
        [self initSensing];
    }
    return self;
}

- (void)initSensing
{
    // init Comm Manager
    //KKCommManager *commManager = [[KKCommManager alloc] initWithUrl:url];
    //self.commManager = commManager;
    
    // init iBeacon Sensing
    NSUInteger device_id = arc4random_uniform(1000000); // Produce a random id for now. TODO: Use server to generate a unique one in the future
    KKiBeaconSensing *iBeaconSensing = [[KKiBeaconSensing alloc] initWithUUID:self.uuid withDeviceId:device_id];
    iBeaconSensing.delegate = self.modelManager;  // set delegate to modelManager
    self.iBeaconSensing = iBeaconSensing;
    
    // init Location Sensing
    KKLocationSensing *locationSensing = [[KKLocationSensing alloc] init];
    locationSensing.delegate = self.modelManager;  // set delegate to modelManager
    self.locationSensing = locationSensing;
    
    // init Motion Sensing
    KKMotionSensing *motionSensing = [[KKMotionSensing alloc] init];
    motionSensing.delegate = self.modelManager;  // set delegate to modelManager
    motionSensing.accelerometerUpdateInterval = 1/100.0;
    motionSensing.gyroUpdateInterval = 1/100.0;
    motionSensing.magnetometerUpdateInterval = 1/100.0;
    self.motionSensing = motionSensing;
    
    // init Battery Sensing
    KKBatterySensing *batterySensing = [[KKBatterySensing alloc] init];
    batterySensing.delegate = self.modelManager;  // set delegate to modelManager
    self.batterySensing = batterySensing;
}

- (void)startSensing
{
    NSLog(@"Start Sensing");
    
    // Stop app from going to sleep mode
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Set the screen brightness to low
    //self.brightness = [UIScreen mainScreen].brightness;
    //[[UIScreen mainScreen] setBrightness:0.0];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    // Start the sensing modules
    [self.iBeaconSensing  startBeaconSensingWithPower:nil];  // nil for default power
    [self.locationSensing startLocationSensing];
    [self.motionSensing   startAccelerometerSensing];
    [self.motionSensing   startGyroSensing];
    [self.motionSensing   startMagnetometerSensing];
    [self.motionSensing   startDeviceMotionSensing];
    [self.motionSensing   startActivitySensing];
    [self.batterySensing  startBatterySensing];
    
    // Start AutoFlush
    [self startAutoFlashing];
}

- (void)stopSensing
{
    NSLog(@"Stop Sensing");
    
    // Let the app go to the sleep mode if required
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    // Restore the brightness
    //[[UIScreen mainScreen] setBrightness:self.brightness];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    // Stop the sensing modules
    [self.iBeaconSensing  stopBeaconSensing];
    [self.locationSensing stopLocationSensing];
    [self.motionSensing   stopAccelerometerSensing];
    [self.motionSensing   stopGyroSensing];
    [self.motionSensing   stopMagnetometerSensing];
    [self.motionSensing   stopDeviceMotionSensing];
    [self.motionSensing   stopActivitySensing];
    [self.batterySensing  stopBatterySensing];
    
    // Stop AutoFlush
    [self stopAutoFlashing];
}

- (void)pauseSensing
{
    NSLog(@"Pause Sensing");
}

- (void)continueSensing
{
    NSLog(@"Continue Sensing");
}

- (void)startAutoFlashing
{
    if (self.timer)
    {
        [self stopAutoFlashing];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60.0f * 5 // 5min
                                                  target:self
                                                selector:@selector(autoFlush:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopAutoFlashing
{
    // First flush for last time
    [self autoFlush:self.timer];
    
    // Stop the timer
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoFlush:(NSTimer *)timer {
    
    NSLog(@"Flushing..");
    
    [self saveData];
}

- (void)saveData
{
    [self.modelManager flushBuffers];
}


@end
