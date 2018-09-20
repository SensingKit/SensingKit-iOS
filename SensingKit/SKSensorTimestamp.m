//
//  SKSensorTimestamp.m
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

#import "SKSensorTimestamp.h"
#include <sys/sysctl.h>

@implementation SKSensorTimestamp

+ (instancetype)sensorTimestampFromDate:(NSDate *)date
{
    return [[SKSensorTimestamp alloc] initWithDate:date withTimeInterval:date.timeIntervalSince1970];
}

+ (instancetype)sensorTimestampFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval timestampOffset = [SKSensorTimestamp timestampOffset];
    NSTimeInterval fixedInterval = timeInterval + timestampOffset;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:fixedInterval];
    return [[SKSensorTimestamp alloc] initWithDate:date withTimeInterval:fixedInterval];
}

- (instancetype)initWithDate:(NSDate *)date
            withTimeInterval:(NSTimeInterval)timeInterval
{
    if (self = [super init])
    {
        _timestamp = date;
        _timeIntervalSinceLastBoot = timeInterval;
    }
    return self;
}

+ (NSTimeInterval)timestampOffset
{
    NSTimeInterval upTime = [NSProcessInfo processInfo].systemUptime;
    NSTimeInterval nowTimeIntervalSince1970 = [[NSDate date] timeIntervalSince1970];
    return nowTimeIntervalSince1970 - upTime;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKSensorTimestamp *sensorTimestamp = [[[self class] alloc] initWithDate:_timestamp
                                                           withTimeInterval:_timeIntervalSinceLastBoot];
    
    return sensorTimestamp;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0.0];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS ZZZ";
    }
    return dateFormatter;
}

- (NSDictionary *)timestampDictionary
{
    return  @{
              @"timestamp": self.timestampString,
              @"timeIntervalSince1970": @(self.timeIntervalSince1970),
              @"timeIntervalSinceLastBoot": @(self.timeIntervalSinceLastBoot)
              };
}

- (NSString *)timestampString
{
    return [[SKSensorTimestamp dateFormatter] stringFromDate:_timestamp];
}

- (NSTimeInterval)timeIntervalSince1970
{
    return _timestamp.timeIntervalSince1970;
}

@end
