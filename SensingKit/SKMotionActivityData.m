//
//  SKMotionActivityData.m
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

#import "SKMotionActivityData.h"

@implementation SKMotionActivityData

- (instancetype)initWithMotionActivity:(CMMotionActivity *)motionActivity
{
    if (self = [super initWithSensorType:MotionActivity
                           withTimestamp:[SKSensorTimestamp sensorTimestampFromTimeInterval:motionActivity.timestamp]])
    {
        _startDate = [SKSensorTimestamp sensorTimestampFromDate:motionActivity.startDate];
        _motionActivity = motionActivity;
    }
    return self;
}

- (NSString *)confidenceString
{
    switch (_motionActivity.confidence) {
        case CMMotionActivityConfidenceHigh:
            return @"High";
            
        case CMMotionActivityConfidenceMedium:
            return @"Medium";
            
        case CMMotionActivityConfidenceLow:
            return @"Low";
            
        default:
            NSLog(@"Warning: Unknown confidence: %d", (int)_motionActivity.confidence);
            return @"Unknown";
    }
}

+ (NSString *)csvHeader
{
    return @"timestamp,timeIntervalSince1970,createDate,createDateSince1970,stationary,walking,running,automotive,cycling,unknown,confidence";
}

- (NSString *)csvString
{
    return [NSString stringWithFormat:@"\"%@\",%f,\"%@\",%f,%d,%d,%d,%d,%d,%d,%@",
            self.timestamp.timestampString,
            self.timestamp.timeIntervalSince1970,
            _startDate.timestampString,
            _startDate.timeIntervalSince1970,
            _motionActivity.stationary,
            _motionActivity.walking,
            _motionActivity.running,
            _motionActivity.automotive,
            _motionActivity.cycling,
            _motionActivity.unknown,
            [self confidenceString]];
}

- (NSDictionary *)dictionaryData
{
    return @{
             @"sensorType": @(self.sensorType),
             @"sensorTypeString": [NSString stringWithSensorType:self.sensorType],
             @"timestamp": self.timestamp.timestampDictionary,
             @"startDate": self.startDate.timestampDictionary,
             @"activity": @{
                     @"stationary": @(_motionActivity.stationary),
                     @"walking": @(_motionActivity.walking),
                     @"running": @(_motionActivity.running),
                     @"automotive": @(_motionActivity.automotive),
                     @"cycling": @(_motionActivity.cycling),
                     @"unknown": @(_motionActivity.unknown)
                     }
             };
}

@end
