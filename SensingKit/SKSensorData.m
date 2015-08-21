//
//  SKSensorData.m
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

#import "SKSensorData.h"

@implementation SKSensorData

- (instancetype)initWithSensorModuleType:(SKSensorModuleType)moduleType
{
    if (self = [super init])
    {
        _moduleType = moduleType;
        
        // Save current timestamp
        _timestamp = [NSDate date];
    }
    return self;
}

- (instancetype)initWithSensorModuleType:(SKSensorModuleType)moduleType
                           withTimestamp:(NSDate *)timestamp
{
    if (self = [super init])
    {
        _moduleType = moduleType;
        _timestamp = timestamp;
    }
    return self;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
    return dateFormatter;
}

- (NSString *)timestampString
{
    return [[SKSensorData dateFormatter] stringFromDate:_timestamp];
}

- (double)timestampEpoch
{
    return _timestamp.timeIntervalSince1970;
}

- (NSString *)csvString
{
    NSLog(@"Error: csvString method has not be implemented in the parent SKSensorData file.");
    abort();
}

- (NSDictionary *)dictionaryData
{
    NSLog(@"Error: dictionaryData method has not be implemented in the parent SKSensorData file.");
    abort();
}

@end
