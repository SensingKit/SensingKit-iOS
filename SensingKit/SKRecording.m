//
//  SKRecording.m
//  SensingKit
//
//  Created by Minos Katevas on 09/11/2014.
//  Copyright (c) 2014 Queen Mary University of London. All rights reserved.
//

#import "SKRecording.h"

#import "SKModelManager.h"
#import "SKRecordingDataManager.h"

#import "SKProximitySensing.h"
#import "SKLocationSensing.h"
#import "SKMotionSensing.h"
#import "SKBatterySensing.h"

@interface SKRecording()

@property (nonatomic, strong) SKModelManager *modelManager;
@property (nonatomic, strong) NSMutableDictionary *recordingDetails;

@property (nonatomic, strong) SKRecordingDataManager *dataManager;

@property (nonatomic, strong) SKProximitySensing  *iBeaconSensing;
@property (nonatomic, strong) SKLocationSensing *locationSensing;
@property (nonatomic, strong) SKMotionSensing   *motionSensing;
@property (nonatomic, strong) SKBatterySensing  *batterySensing;

@property (nonatomic, strong) NSUUID *uuid;

@property (nonatomic) CGFloat brightness;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SKRecording

- (instancetype)init
{
    if (self = [super init])
    {
        // Get shared ModelManager
        self.modelManager = [SKModelManager sharedModelManager];
        
        // Create a new Recording in the ModelManager and get the generated MutableDictionary
        self.recordingDetails = [self.modelManager createRecording];
        
        // init DataManager
        SKRecordingDataManager *dataManager = [[SKRecordingDataManager alloc] init];
        dataManager.interval = 60;  // Default value
        self.dataManager = dataManager;
        
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
    SKProximitySensing *iBeaconSensing = [[SKProximitySensing alloc] initWithUUID:self.uuid withDeviceId:device_id];
    iBeaconSensing.delegate = self.dataManager;  // set delegate to modelManager
    self.iBeaconSensing = iBeaconSensing;
    
    // init Location Sensing
    SKLocationSensing *locationSensing = [[SKLocationSensing alloc] init];
    locationSensing.delegate = self.dataManager;  // set delegate to modelManager
    self.locationSensing = locationSensing;
    
    // init Motion Sensing
    SKMotionSensing *motionSensing = [[SKMotionSensing alloc] init];
    motionSensing.delegate = self.dataManager;  // set delegate to modelManager
    motionSensing.accelerometerUpdateInterval = 1/100.0;
    motionSensing.gyroUpdateInterval = 1/100.0;
    motionSensing.magnetometerUpdateInterval = 1/100.0;
    self.motionSensing = motionSensing;
    
    // init Battery Sensing
    SKBatterySensing *batterySensing = [[SKBatterySensing alloc] init];
    batterySensing.delegate = self.dataManager;  // set delegate to modelManager
    self.batterySensing = batterySensing;
}

- (void)setRecordingName:(NSString *)recordingName
{
    self.recordingDetails[@"name"] = recordingName;
    [self.modelManager save];
    
    _recordingName = recordingName;
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
    [self.iBeaconSensing  startProximitySensingWithPower:nil];  // nil for default power
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
    [self.iBeaconSensing  stopProximitySensing];
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

- (void)saveSyncPoint
{
    NSLog(@"Save Sync Point");
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
    [self.dataManager flushBuffers];
}

@end
