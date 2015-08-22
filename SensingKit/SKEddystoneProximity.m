//
//  SKEddystoneProximity.m
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

#import "SKEddystoneProximity.h"
#import "ESSBeaconScanner.h"
#import "ESSEddystone.h"
#import "SKEddystoneProximityData.h"

@interface SKEddystoneProximity () <ESSBeaconScannerDelegate>

@property (strong, nonatomic) ESSBeaconScanner *beaconScanner;

@end

@implementation SKEddystoneProximity

- (id)init
{
    return [self initWithNamespace:nil];
}

- (id)initWithNamespace:(NSString *)namespaceFilter;
{
    if (self = [super init])
    {
        _namespaceFilter = namespaceFilter;
        
        // init ESSBeaconScanner
        self.beaconScanner = [[ESSBeaconScanner alloc] init];
        self.beaconScanner.delegate = self;
    }
    return self;
}

- (void)startSensing
{
    [super startSensing];
    
    [self.beaconScanner startScanning];
}

- (void)stopSensing
{
    [self.beaconScanner stopScanning];
    
    [super stopSensing];
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
    if (beaconInfo.beaconID.beaconType == kESSBeaconTypeEddystone) {
        
        // 16 bytes long data. 10byte namespace + 6byte instance ID
        NSData *beaconId = beaconInfo.beaconID.beaconID;
        NSData *namespaceData = [beaconId subdataWithRange:NSMakeRange(0, 10)];

        // Separate the namespace (10 bytes)
        NSString *namespaceString = [self hexadecimalStringFromData:namespaceData];
        
        if (!self.namespaceFilter || [self.namespaceFilter isEqualToString:namespaceString]) {
            
            // Separate the instanceId (6 bytes)
            NSData *instanceIdData = [beaconId subdataWithRange:NSMakeRange(10, 6)];
            
            // Convert NSData bytes into NSUInteger (quick and dirty way for now!)
            NSString *instanceIdString = [self hexadecimalStringFromData:instanceIdData];
            NSUInteger instanceId = instanceIdString.integerValue;
            
            // Get all remaining properties
            NSInteger  rssi = beaconInfo.RSSI.integerValue;
            NSInteger  txPower = beaconInfo.txPower.integerValue;
            
            // Create and submit the data
            SKEddystoneProximityData *data = [[SKEddystoneProximityData alloc] initWithTimestamp:[NSDate date]
                                                                                   withNamespace:namespaceString
                                                                                  withInstanceId:instanceId
                                                                                        withRssi:rssi
                                                                                     withTxPower:txPower];
            
            [self submitSensorData:data];
        }
    }
}

// Serialize an NSData into a hexadeximal string
// Thanks to http://stackoverflow.com/questions/1305225/best-way-to-serialize-a-nsdata-into-an-hexadeximal-string
- (NSString *)hexadecimalStringFromData:(NSData *)data
{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02hhx", dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end
