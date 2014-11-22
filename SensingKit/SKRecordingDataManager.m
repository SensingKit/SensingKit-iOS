//
//  SKRecordingDataManager.m
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

#import "SKRecordingDataManager.h"
#import "NSString+SKSensing.h"
#import "SKModel.h"

@interface SKRecordingDataManager ()

@property (nonatomic, strong) NSDateFormatter *dataDateformatter;
@property (nonatomic, strong) NSDateFormatter *filenameDateFormatter;

@property (nonatomic, strong) SKSensorDataBuffer *iBeaconSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *locationSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *accelerometerSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *gyroSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *magnetometerSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *deviceMotionSensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *activitySensingBuffer;
@property (nonatomic, strong) SKSensorDataBuffer *batterySensingBuffer;

// TODO: Add audioSensing (using mic)
// TODO: More sensing?

@property (nonatomic, strong) SKModel *model;

@end

@implementation SKRecordingDataManager

- (id)init
{
    if (self = [super init])
    {
        // init data DateTime formatter
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss.SSS zzz";
        formatter.doesRelativeDateFormatting = NO;
        self.dataDateformatter = formatter;
        
        // init filename DateTime formatter
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"yyMMdd_HHmmss";
        formatter.doesRelativeDateFormatting = NO;
        self.filenameDateFormatter = formatter;
        
        // init model
        self.model = [[SKModel alloc] init];
        
        // init sensing buffers (default capacity: 1000)
        self.iBeaconSensingBuffer        = [[SKSensorDataBuffer alloc] initWithLabel:@"iBeacon"       withCapacity:1000];
        //self.locationSensingBuffer       = [[KKSensorDataBuffer alloc] initWithLabel:@"Location"      withCapacity:1000];
        self.accelerometerSensingBuffer  = [[SKSensorDataBuffer alloc] initWithLabel:@"Accelerometer" withCapacity:1000];
        self.gyroSensingBuffer           = [[SKSensorDataBuffer alloc] initWithLabel:@"Gyro"          withCapacity:1000];
        self.magnetometerSensingBuffer   = [[SKSensorDataBuffer alloc] initWithLabel:@"Magnetometer"  withCapacity:1000];
        self.deviceMotionSensingBuffer   = [[SKSensorDataBuffer alloc] initWithLabel:@"DeviceMotion"  withCapacity:1000];
        self.activitySensingBuffer       = [[SKSensorDataBuffer alloc] initWithLabel:@"Activity"      withCapacity:1000];
        self.batterySensingBuffer        = [[SKSensorDataBuffer alloc] initWithLabel:@"Battery"       withCapacity:1000];
        
        // set delegates
        [self.iBeaconSensingBuffer       setDelegate:self];
        //[self.locationSensingBuffer      setDelegate:self];
        [self.accelerometerSensingBuffer setDelegate:self];
        [self.gyroSensingBuffer          setDelegate:self];
        [self.magnetometerSensingBuffer  setDelegate:self];
        [self.deviceMotionSensingBuffer  setDelegate:self];
        [self.activitySensingBuffer      setDelegate:self];
        [self.batterySensingBuffer       setDelegate:self];
    }
    return self;
}

- (void)syncDataForDeviceWithId:(NSUInteger)device_id
{
    [self.model syncDataForDeviceWithId:device_id];
}

#pragma mark flush buffer methods

- (void)flushBuffers
{
    [self.iBeaconSensingBuffer       flush];
    //[self.locationSensingBuffer      flush];
    [self.accelerometerSensingBuffer flush];
    [self.gyroSensingBuffer          flush];
    [self.magnetometerSensingBuffer  flush];
    [self.deviceMotionSensingBuffer  flush];
    [self.activitySensingBuffer      flush];
    [self.batterySensingBuffer       flush];
}

#pragma mark add to buffer methods

- (void)addBeaconSensingDataWithLabel:(NSString *)label
                           identifier:(NSString *)identifier
                             accuracy:(CLLocationAccuracy)accuracy
                            proximity:(CLProximity)proximity
                                 rssi:(NSInteger)rssi
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithProximitySensingDataWithLabel:label
                                                         identifier:identifier
                                                           accuracy:accuracy
                                                          proximity:proximity
                                                               rssi:rssi
                                                          timestamp:timestamp];
    
    // Add to buffer
    [self.iBeaconSensingBuffer addData:data];
}

- (void)addBeaconSensingDataWithLabel:(NSString *)label
                           identifier:(NSString *)identifier
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithBeaconSensingDataWithLabel:label
                                                         identifier:identifier
                                                          timestamp:timestamp];
    
    // Add to buffer
    [self.iBeaconSensingBuffer addData:data];
}

- (void)addLocationSensingData:(CLLocation *)location
{
    NSString *timestamp = [self.dataDateformatter stringFromDate:location.timestamp];
    
    // Create the string
    NSString *data = [NSString stringWithLocationSensingData:location
                                                   timestamp:timestamp];
    
    // Add to buffer
    [self.locationSensingBuffer addData:data];
}

- (void)addAccelerometerSensingData:(CMAccelerometerData *)accelererometerData
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithAccelerometerSensingData:accelererometerData
                                                        timestamp:timestamp];

    // Add to buffer
    [self.accelerometerSensingBuffer addData:data];
}

- (void)addGyroSensingData:(CMGyroData *)gyroData
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithGyroSensingData:gyroData
                                               timestamp:timestamp];
    
    // Add to buffer
    [self.gyroSensingBuffer addData:data];
}

- (void)addMagnetometerSensingData:(CMMagnetometerData *)magnetometerData
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithMagnetometerSensingData:magnetometerData
                                                       timestamp:timestamp];
    
    // Add to buffer
    [self.magnetometerSensingBuffer addData:data];
}

- (void)addActivitySensingData:(CMMotionActivity *)activity
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithActivitySensingData:activity
                                                   timestamp:timestamp];
    
    // Add to buffer
    [self.activitySensingBuffer addData:data];
}

- (void)addDeviceMotionSensingData:(CMDeviceMotion *)motion
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithDeviceMotionSensingData:motion
                                                       timestamp:timestamp];
    
    // Add to buffer
    [self.activitySensingBuffer addData:data];
}

- (void)addBatterySensingDataWithLabel:(NSString *)label
                                 state:(UIDeviceBatteryState)state
                                 level:(CGFloat)level
{
    NSString *timestamp = [self getTimestamp];
    
    // Create the string
    NSString *data = [NSString stringWithBatterySensingDataWithLabel:label
                                                               state:state
                                                               level:level
                                                           timestamp:timestamp];
    
    // Add to buffer
    [self.batterySensingBuffer addData:data];
}

- (NSString *)getTimestamp
{
    NSDate *current = [NSDate date];
    return [self.dataDateformatter stringFromDate:current];
}

#pragma mark iBeaconSensing delegates

- (void)beaconFoundWithIdentifier:(NSString *)identifier
{
    [self addBeaconSensingDataWithLabel:@"Found"
                             identifier:identifier];
}

- (void)beaconLostWithIdentifier:(NSString *)identifier
{
    [self addBeaconSensingDataWithLabel:@"Lost"
                             identifier:identifier];
}

- (void)rangingBeaconWithIdentifier:(NSString *)identifier
                           accuracy:(CLLocationAccuracy)accuracy
                          proximity:(CLProximity)proximity
                               rssi:(NSInteger)rssi
{
    [self addBeaconSensingDataWithLabel:@"Ranging"
                             identifier:identifier
                               accuracy:accuracy
                              proximity:proximity
                                   rssi:rssi];
}

#pragma mark LocationSensing delegates

- (void)locationUpdateReceived:(CLLocation *)location
{
    [self addLocationSensingData:location];
}

#pragma mark MotionSensing delegates

- (void)accelerometerDataReceived:(CMAccelerometerData *)accelererometerData
{
    [self addAccelerometerSensingData:accelererometerData];
}

- (void)gyroDataReceived:(CMGyroData *)gyroData
{
    [self addGyroSensingData:gyroData];
}

- (void)magnetometerDataReceived:(CMMagnetometerData *)magnetometerData
{
    [self addMagnetometerSensingData:magnetometerData];
}

- (void)deviceMotionDataReceived:(CMDeviceMotion *)motion
{
    [self addDeviceMotionSensingData:motion];
}

- (void)activityDataReceived:(CMMotionActivity *)activity
{
    [self addActivitySensingData:activity];
}

#pragma mark BatterySensing delegates

- (void)batteryLevelChanged:(UIDeviceBatteryState)state level:(CGFloat)level;
{
    [self addBatterySensingDataWithLabel:@"LevelChanged" state:state level:level];
}

- (void)batteryStateChanged:(UIDeviceBatteryState)state level:(CGFloat)level
{
    [self addBatterySensingDataWithLabel:@"StateChanged" state:state level:level];
}

#pragma mark KKSensorDataBuffer delegates

- (void)flushedBuffer:(NSString *)label withData:(NSData *)data
{
    // Compose filename with format: label_date_time.gzip
    NSString *filename = [NSString stringWithFormat:@"%@_%@.gz", label, [self.dataDateformatter stringFromDate:[NSDate date]]];
    
    // Add the data to the model
    [self.model addData:data withFilename:filename];
}

@end
