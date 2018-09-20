//
//  SKEddystoneProximity.m
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

#import "SKEddystoneProximity.h"
#import "ESSBeaconScanner.h"
#import "ESSEddystone.h"
#import "SKEddystoneProximityData.h"
@import CoreLocation;


@interface SKEddystoneProximity () <ESSBeaconScannerDelegate>

@property (strong, nonatomic) ESSBeaconScanner *beaconScanner;
@property (strong, nonatomic, readonly) NSData *namespaceFilterData;

@end


@implementation SKEddystoneProximity

- (instancetype)initWithConfiguration:(SKEddystoneProximityConfiguration *)configuration
{
    if (self = [super init])
    {
        self.beaconScanner = [[ESSBeaconScanner alloc] init];
        self.beaconScanner.delegate = self;
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    super.configuration = configuration;
    
    // Cast the configuration instance
    SKEddystoneProximityConfiguration *eddystoneConfiguration = (SKEddystoneProximityConfiguration *)configuration;
    
    // Make the required updates on the sensor
    
    // Save the hex filter in lowercase
    _namespaceFilterData = [SKEddystoneProximity dataFromHexString:eddystoneConfiguration.namespaceFilter];
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    // Bluetooth 4 supports monitoring, so device should have a Bluetooth Smart HW.
    return [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKEddystoneProximity isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Eddystone Proximity sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    [self.beaconScanner startScanning];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.beaconScanner stopScanning];
    
    return [super stopSensing:error];
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didFindBeacon:(id)beaconInfo
{
    [self beaconFoundWithInfo:beaconInfo];
}

- (void)beaconScanner:(ESSBeaconScanner *)scanner didUpdateBeacon:(id)beaconInfo
{
    [self beaconFoundWithInfo:beaconInfo];
}

- (void)beaconFoundWithInfo:(ESSBeaconInfo *)beaconInfo
{
    // If this is an Eddystone beacon
    if (beaconInfo.beaconID.beaconType == kESSBeaconTypeEddystone) {
        
        // 16 bytes long data. 10byte namespaceId + 6byte instanceId
        NSData *beaconId = beaconInfo.beaconID.beaconID;
        
        // Separate the namespaceId (10 bytes)
        NSData *namespaceData = [beaconId subdataWithRange:NSMakeRange(0, 10)];
        
        // If filter doesn't exist at all OR filter equals with the device's namespaceId
        if (!self.namespaceFilterData || [self.namespaceFilterData isEqualToData:namespaceData]) {
            
            // Convert NSData bytes into NSString
            NSString *namespaceId = [SKEddystoneProximity hexStringFromData:namespaceData];
            
            // Separate the instanceId (6 bytes)
            NSData *instanceIdData = [beaconId subdataWithRange:NSMakeRange(10, 6)];
            
            // Convert NSData bytes into NSUInteger (quick and dirty way for now!)
            NSUInteger instanceId = [SKEddystoneProximity hexStringFromData:instanceIdData].integerValue;
            
            // Get all remaining properties
            NSInteger  rssi = beaconInfo.RSSI.integerValue;
            NSInteger  txPower = beaconInfo.txPower.integerValue;
            
            // Create and submit the data
            SKEddystoneProximityData *data = [[SKEddystoneProximityData alloc] initWithTimestamp:[NSDate date]
                                                                                 withNamespaceId:namespaceId
                                                                                  withInstanceId:instanceId
                                                                                        withRssi:rssi
                                                                                     withTxPower:txPower];
            
            [self submitSensorData:data error:NULL];
        }
    }
}

// Serialize an NSData into a hexadeximal string
// Thanks to http://stackoverflow.com/questions/1305225/best-way-to-serialize-a-nsdata-into-an-hexadeximal-string
+ (NSString *)hexStringFromData:(NSData *)data
{
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    
    if (!dataBuffer) {
        return [NSString string];
    }
    
    NSUInteger dataLength = data.length;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02hhx", dataBuffer[i]]];
    }
    
    return [NSString stringWithString:hexString];
}

// Convert a NSString hex into NSData
// Thanks to ESSEddystone.m
+ (NSData *)dataFromHexString:(NSString *)hexString
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    
    for (int i = 0; i < hexString.length/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i * 2];
        byte_chars[1] = [hexString characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    return data;
}

@end
