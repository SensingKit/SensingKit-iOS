//
//  SKEddystoneProximityData.m
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

#import "SKEddystoneProximityData.h"

@implementation SKEddystoneProximityData

- (instancetype)initWithTimestamp:(NSDate *)timestamp
                    withNamespace:(NSString *)namespace
                   withInstanceId:(NSUInteger)instanceId
                         withRssi:(NSInteger)rssi
                      withTxPower:(NSInteger)txPower
{
    if (self = [super initWithSensorModuleType:EddystoneProximity withTimestamp:timestamp])
    {
        _namespace = namespace;
        _instanceId = instanceId;
        _rssi = rssi;
        _txPower = txPower;
    }
    return self;
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"%f,%@,%lu,%ld,%ld",
            [self timestampEpoch],
            _namespace,
            (unsigned long)_instanceId,
            (long)_rssi,
            (long)_txPower];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.moduleType),
             @"sensorTypeString": [NSString stringWithSensorModuleType:self.moduleType],
             @"timestamp": @{
                     @"timestamp": self.timestamp,
                     @"timestampEpoch": @(self.timestampEpoch),
                     @"timestampString": self.timestampString
                     },
             @"Eddystone": @{
                     @"namespace": _namespace,
                     @"instanceId": @(_instanceId),
                     @"rssi": @(_rssi),
                     @"txPower": @(_txPower)
                     }
             };
}

@end
