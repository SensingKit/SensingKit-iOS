//
//  NSString+SensorModuleType.m
//  SensingKit
//
//  Created by Minos Katevas on 21/08/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import "NSString+SensorModuleType.h"

@implementation NSString (SensorModuleType)

+ (NSString *)stringWithSensorModuleType:(SKSensorModuleType)moduleType
{
    switch (moduleType) {
            
        case Accelerometer:
            return @"Accelerometer";
            
        case Gyroscope:
            return @"Gyroscope";
            
        case Magnetometer:
            return @"Magnetometer";
            
        case DeviceMotion:
            return @"DeviceMotion";
            
        case Activity:
            return @"Activity";
            
        case Battery:
            return @"Battery";
            
        case Location:
            return @"Location";
            
        case iBeaconProximity:
            return @"iBeaconProximity";
            
        default:
            return [NSString stringWithFormat:@"Unknown SensorModule: %li", (long)moduleType];
    }
}

@end
