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
#import "SKBeaconData.h"

@interface SKiBeaconProximity()

@property (strong, nonatomic) CLBeaconRegion      *broadcast_beaconRegion;
@property (strong, nonatomic) CLBeaconRegion      *scan_beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager   *locationManager;

@end

@implementation SKiBeaconProximity

- (instancetype)initWithUUID:(NSUUID *)UUID
                   withMajor:(NSUInteger)major
                   withMinor:(NSUInteger)minor
{
    if (self = [super init])
    {
        // init iBeacon managers
        [self initBeaconSensingWithUUID:UUID
                              withMajor:major
                              withMinor:minor];
    }
    return self;
}

- (void)initBeaconSensingWithUUID:(NSUUID *)UUID
                        withMajor:(NSUInteger)major
                        withMinor:(NSUInteger)minor
{
    // Get a unique identifier for the device
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.broadcast_beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:UUID
                                                                          major:major
                                                                          minor:minor
                                                                     identifier:identifier];
    
    self.scan_beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:UUID
                                                                identifier:identifier];
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

#pragma mark start / stop sensing

- (void)startAdvertisingWithPower:(NSNumber *)power
{
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        
        // Start advertising
        NSDictionary *payload = [self.broadcast_beaconRegion peripheralDataWithMeasuredPower:power];
        [self.peripheralManager startAdvertising:payload];
        
        // What is the MeasuredPower?
        // The received signal strength indicator (RSSI) value (measured in decibels) for the device.
        // This value represents the measured strength of the beacon from one meter away and is used during ranging.
        // Specify nil to use the default value for the device.
    }
    else {
        NSLog(@"CBPeripheralManager state is %li", (long)self.peripheralManager.state);
        abort();
    }
}

- (void)stopAdvertising
{
    // Stop advertising
    [self.peripheralManager stopAdvertising];
}

- (void)startMonitoring
{
    if ([CLLocationManager isRangingAvailable]) {
        
        // Start monitoring
        [self.locationManager startMonitoringForRegion:self.scan_beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:self.scan_beaconRegion];
    }
    else {
        NSLog(@"Ranging is not available.");
        abort();
    }
}

- (void)stopMonitoring
{
    // Stop monitoring
    [self.locationManager stopMonitoringForRegion:self.scan_beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:self.scan_beaconRegion];
}

- (void)startSensing
{
    [super startSensing];
    
    [self startMonitoring];
    [self startAdvertisingWithPower:nil];
}

- (void)stopSensing
{
    [self stopAdvertising];
    [self stopMonitoring];
    
    [super stopSensing];
}

#pragma mark delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn)
    {
        NSLog(@"Warning: Bluetooth is not available. (State: %d)", (int)peripheral.state);
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        if (beacon)
        {
            SKBeaconData *data = [[SKBeaconData alloc] initWithMajor:beacon.major.unsignedIntegerValue
                                                           withMinor:beacon.minor.unsignedIntegerValue
                                                        withAccuracy:beacon.accuracy
                                                       withProximity:beacon.proximity
                                                            withRssi:beacon.rssi];
            
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
