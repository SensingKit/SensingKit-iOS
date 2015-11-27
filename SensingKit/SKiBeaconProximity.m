//
//  SKiBeaconProximity.m
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

#import "SKiBeaconProximity.h"
#import "SKProximityData.h"
#import "SKiBeaconDeviceData.h"

@import CoreBluetooth;
@import CoreLocation;

#define SKiBeaconIdentifier @"org.sensingkit.iBeaconIdentifier"


@interface SKiBeaconProximity() <CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@property (nonatomic) SKiBeaconProximityMode mode;

@property (strong, nonatomic) CLBeaconRegion      *broadcast_beaconRegion;
@property (strong, nonatomic) CLBeaconRegion      *scan_beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager   *locationManager;

@property (strong, nonatomic) NSDictionary *broadcastPayload;

@end


@implementation SKiBeaconProximity

- (instancetype)initWithConfiguration:(SKiBeaconProximityConfiguration *)configuration
{
    if (self = [super init])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.configuration = configuration;
    }
    return self;
}

#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    // Check if the correct configuration type provided
    if (configuration.class != SKiBeaconProximityConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor iBeaconProximity.", configuration.class);
        abort();
    }
    
    super.configuration = configuration;
    
    // Cast the configuration instance
    SKiBeaconProximityConfiguration *beaconConfiguration = (SKiBeaconProximityConfiguration *)configuration;
    
    // Save mode
    self.mode = beaconConfiguration.mode;
    
    // Make the required updates on the sensor
    switch (self.mode)
    {
        case SKiBeaconProximityModeScanOnly:
            [self enableScanningWithConfiguration:beaconConfiguration];
            [self disableBroadcasting];
            break;
            
        case SKiBeaconProximityModeBroadcastOnly:
            [self disableScanning];
            [self enableBroadcastingWithConfiguration:beaconConfiguration];
            break;
            
        case SKiBeaconProximityModeScanAndBroadcast:
            [self enableScanningWithConfiguration:beaconConfiguration];
            [self enableBroadcastingWithConfiguration:beaconConfiguration];
            break;
            
        default:
            NSLog(@"Unknown SKiBeaconProximityMode: %lu", (unsigned long)beaconConfiguration.mode);
            abort();
    }
}

- (void)enableScanningWithConfiguration:(SKiBeaconProximityConfiguration *)configuration
{
    // Request authorization. Only WhenInUse is required for proximity scanning.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.scan_beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:configuration.UUID
                                                                identifier:SKiBeaconIdentifier];
}

- (void)disableScanning
{
    self.scan_beaconRegion = nil;
}

- (void)enableBroadcastingWithConfiguration:(SKiBeaconProximityConfiguration *)configuration
{
    if (!self.peripheralManager)  // No need to init it again
    {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil];
    }
    
    self.broadcast_beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:configuration.UUID
                                                                          major:configuration.major
                                                                          minor:configuration.minor
                                                                     identifier:SKiBeaconIdentifier];
    
    self.broadcastPayload = [self.broadcast_beaconRegion peripheralDataWithMeasuredPower:configuration.measuredPower];
}

- (void)disableBroadcasting
{
    self.peripheralManager = nil;
    self.broadcast_beaconRegion = nil;
    self.broadcastPayload = nil;
}

#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    return [CLLocationManager isRangingAvailable];
}

- (void)startBroadcasting
{
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        
        // Start advertising
        [self.peripheralManager startAdvertising:self.broadcastPayload];
    }
    else {
        NSLog(@"CBPeripheralManager state is %li", (long)self.peripheralManager.state);
        abort();
    }
}

- (void)stopBroadcasting
{
    // Stop advertising
    [self.peripheralManager stopAdvertising];
}

- (void)startScanning
{
    if ([SKiBeaconProximity isSensorAvailable]) {
        
        // Start monitoring
        [self.locationManager startRangingBeaconsInRegion:self.scan_beaconRegion];
    }
    else {
        NSLog(@"Ranging is not available.");
        abort();
    }
}

- (void)stopScanning
{
    // Stop monitoring
    [self.locationManager stopRangingBeaconsInRegion:self.scan_beaconRegion];
}

- (void)startSensing
{
    [super startSensing];
    
    if (self.mode != SKiBeaconProximityModeBroadcastOnly)
    {
        [self startScanning];
    }
    
    if (self.mode != SKiBeaconProximityModeScanOnly)
    {
        [self startBroadcasting];
    }
}

- (void)stopSensing
{
    if (self.mode != SKiBeaconProximityModeBroadcastOnly)
    {
        [self stopScanning];
    }
    
    if (self.mode != SKiBeaconProximityModeScanOnly)
    {
        [self stopBroadcasting];
    }
    
    [super stopSensing];
}

#pragma mark delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn)
    {
        NSLog(@"Warning: Bluetooth radio is not available. (State: %d)", (int)peripheral.state);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // Only if beacons exist
    if (beacons.count) {
        
        // Get current timestamp
        NSDate *timestamp = [NSDate date];
        
        // Create an array that will hold the SKBeaconDeviceData objects
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:beacons.count];
        
        // Add the objects
        for (CLBeacon *beacon in beacons)
        {
            if (beacon)
            {
                SKiBeaconDeviceData *deviceData = [[SKiBeaconDeviceData alloc] initWithTimestamp:timestamp
                                                                                       withMajor:beacon.major.unsignedIntegerValue
                                                                                       withMinor:beacon.minor.unsignedIntegerValue
                                                                                    withAccuracy:beacon.accuracy
                                                                                   withProximity:beacon.proximity
                                                                                        withRssi:beacon.rssi];
                
                [array addObject:deviceData];
            }
        }
        
        // Only if beacons exist
        if (array.count) {
            
            // Create and submit the SKProximityData object
            SKProximityData *data = [[SKProximityData alloc] initWithSensorType:iBeaconProximity
                                                                  withTimestamp:timestamp
                                                                    withDevices:array];
            
            [self submitSensorData:data];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Region monitoring failed with error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Raging Beacons failed with error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Monitoring failed with error: %@", error.localizedDescription);
}

@end
