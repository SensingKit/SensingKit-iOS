//
//  SKiBeaconProximity.m
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
            
        // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
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

- (BOOL)startBroadcasting:(NSError **)error
{
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        
        if (error) {
            
            NSLog(@"CBPeripheralManager state is %li", (long)self.peripheralManager.state);

            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"iBeacon Proximity sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Start advertising
    [self.peripheralManager startAdvertising:self.broadcastPayload];
    
    return YES;
}

- (void)stopBroadcasting
{
    // Stop advertising
    [self.peripheralManager stopAdvertising];
}

- (void)startScanning
{
    // Start monitoring and ranging
    [self.locationManager startMonitoringForRegion:self.scan_beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.scan_beaconRegion];
}

- (void)stopScanning
{
    // Stop monitoring and ranging
    [self.locationManager stopRangingBeaconsInRegion:self.scan_beaconRegion];
    [self.locationManager stopMonitoringForRegion:self.scan_beaconRegion];
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKiBeaconProximity isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"iBeacon Proximity sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    if (self.mode != SKiBeaconProximityModeBroadcastOnly)
    {
        [self startScanning];
    }
    
    if (self.mode != SKiBeaconProximityModeScanOnly)
    {
        if (![self startBroadcasting:error]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    if (self.mode != SKiBeaconProximityModeBroadcastOnly)
    {
        [self stopScanning];
    }
    
    if (self.mode != SKiBeaconProximityModeScanOnly)
    {
        [self stopBroadcasting];
    }
    
    return [super stopSensing:error];
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
            
            [self submitSensorData:data error:NULL];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [self submitSensorData:nil error:error];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    [self submitSensorData:nil error:error];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self submitSensorData:nil error:error];
}

@end
