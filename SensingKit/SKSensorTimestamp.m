//
//  SKSensorTimestamp.m
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

#import "SKSensorTimestamp.h"
#include <sys/sysctl.h>

@implementation SKSensorTimestamp

+ (instancetype)sensorTimestampFromDate:(NSDate *)date
{
    NSTimeInterval timeInterval = date.timeIntervalSince1970 - [SKSensorTimestamp dateOfLastBoot].timeIntervalSince1970;
    return [[SKSensorTimestamp alloc] initWithDate:date withTimeInterval:timeInterval];
}

+ (instancetype)sensorTimestampFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval + [SKSensorTimestamp dateOfLastBoot].timeIntervalSince1970];
    NSLog(@"DEBUG: LB (%@) LBf(%f) - %f",[SKSensorTimestamp dateOfLastBoot], [SKSensorTimestamp dateOfLastBoot].timeIntervalSince1970, timeInterval);
    return [[SKSensorTimestamp alloc] initWithDate:date withTimeInterval:timeInterval];
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

- (id)copyWithZone:(NSZone *)zone
{
    SKSensorTimestamp *sensorTimestamp = [[[self class] alloc] initWithDate:_timestamp
                                                           withTimeInterval:_timeIntervalSinceLastBoot];
    
    return sensorTimestamp;
}


// Thanks to https://stackoverflow.com/questions/12488481/getting-ios-system-uptime-that-doesnt-pause-when-asleep/12490414#12490414
+ (NSDate *)dateOfLastBoot
{
    static NSDate *lastBoot;
    
    if (!lastBoot)
    {
        struct timeval boottime;
        int mib[2] = {CTL_KERN, KERN_BOOTTIME};
        size_t size = sizeof(boottime);
        
        struct timeval now;
        struct timezone tz;
        gettimeofday(&now, &tz);
        
        if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
        {
            lastBoot = [[NSDate alloc] initWithTimeIntervalSince1970:boottime.tv_sec];
            NSLog(@"Device Boot: %@ (%ld)", lastBoot, boottime.tv_sec);
        }
    }
    return lastBoot;
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
