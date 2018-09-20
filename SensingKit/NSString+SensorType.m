//
//  NSString+SensorType.h
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

#import "NSString+SensorType.h"

@implementation NSString (SensorType)

static const NSString *SENSOR_STRINGS[] = {
    @"Accelerometer",
    @"Gyroscope",
    @"Magnetometer",
    @"Device Motion",
    @"Motion Activity",
    @"Pedometer",
    @"Altimeter",
    @"Battery",
    @"Location",
    @"Heading",
    @"iBeacon™ Proximity",
    @"Eddystone™ Proximity",
    @"Microphone"
};

static const NSString *NONSPACED_SENSOR_STRINGS[] = {
    @"Accelerometer",
    @"Gyroscope",
    @"Magnetometer",
    @"DeviceMotion",
    @"MotionActivity",
    @"Pedometer",
    @"Altimeter",
    @"Battery",
    @"Location",
    @"Heading",
    @"iBeaconProximity",
    @"EddystoneProximity",
    @"Microphone"
};

+ (NSString *)stringWithSensorType:(SKSensorType)sensorType
{
    return SENSOR_STRINGS[sensorType].copy;
}

+ (NSString *)nonspacedStringWithSensorType:(SKSensorType)sensorType
{
    return NONSPACED_SENSOR_STRINGS[sensorType].copy;
}

@end
