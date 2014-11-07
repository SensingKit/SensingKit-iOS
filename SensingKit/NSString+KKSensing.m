//
//  NSString+KKSensing.m
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

#import "NSString+KKSensing.h"

@implementation NSString (KKSensing)

+ (NSString *)stringWithCLProximity:(CLProximity)proximity
{
    NSString *string;
    
    switch (proximity) {
        case CLProximityImmediate:
            string = @"Immediate";
            break;
            
        case CLProximityNear:
            string = @"Near";
            break;
            
        case CLProximityFar:
            string = @"Far";
            break;
            
        case CLProximityUnknown:
            string = @"Unknown";
            break;
            
        default:
            NSLog(@"Error: Unknown proximity: %d", (int)proximity);
            break;
    }
    
    return string;
}

+ (NSString *)stringWithCMMotionActivityConfidence:(CMMotionActivityConfidence)confidence
{
    NSString *string;
    
    switch (confidence) {
        case CMMotionActivityConfidenceHigh:
            string = @"High";
            break;
            
        case CMMotionActivityConfidenceMedium:
            string = @"Medium";
            break;
            
        case CMMotionActivityConfidenceLow:
            string = @"Low";
            break;
            
        default:
            NSLog(@"Error: Unknown confidence: %d", (int)confidence);
            break;
    }
    
    return string;
}

+ (NSString *)stringWithUIDeviceBatteryState:(UIDeviceBatteryState)state
{
    NSString *string;
    
    switch (state) {
        case UIDeviceBatteryStateCharging:
            string = @"Charging";
            break;
            
        case UIDeviceBatteryStateFull:
            string = @"Full";
            break;
            
        case UIDeviceBatteryStateUnplugged:
            string = @"Unplugged";
            break;
            
        case UIDeviceBatteryStateUnknown:
            string = @"Unknown";
            break;
            
        default:
            NSLog(@"Error: Unknown state: %d", (int)state);
    }
    
    return string;
}

+ (NSString *)stringWithBeaconSensingDataWithLabel:(NSString *)label
                                        identifier:(NSString *)identifier
                                          accuracy:(CLLocationAccuracy)accuracy
                                         proximity:(CLProximity)proximity
                                              rssi:(NSInteger)rssi
                                         timestamp:(NSString *)timestamp
{
    NSString *proximityString = [NSString stringWithCLProximity:proximity];
    
    return [NSString stringWithFormat:@"%@, %@, %@, %f, %@, %ld", timestamp, label, identifier, accuracy, proximityString, (long)rssi];
}

+ (NSString *)stringWithBeaconSensingDataWithLabel:(NSString *)label
                                        identifier:(NSString *)identifier
                                         timestamp:(NSString *)timestamp
{
    return [NSString stringWithFormat:@"%@, %@, %@", timestamp, label, identifier];
}


+ (NSString *)stringWithLocationSensingData:(CLLocation *)location
                                  timestamp:(NSString *)timestamp
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    return [NSString stringWithFormat:@"%@, %f, %f, %f, %f, %f, %f, %f", timestamp, coordinate.latitude, coordinate.longitude, location.altitude, location.horizontalAccuracy, location.verticalAccuracy, location.speed, location.course];
}

+ (NSString *)stringWithAccelerometerSensingData:(CMAccelerometerData *)accelererometerData
                                       timestamp:(NSString *)timestamp
{
    CMAcceleration acceleration = accelererometerData.acceleration;
    
    // Raw Accelerometer Data
    //NSLog(@"%@", [NSString stringWithFormat:@"%.2f \t %.2f \t %.2f", acceleration.x, acceleration.y, acceleration.z]);
    
    return [NSString stringWithFormat:@"%@, %f, %f, %f, %f", timestamp, accelererometerData.timestamp, acceleration.x, acceleration.y, acceleration.z];
}

+ (NSString *)stringWithGyroSensingData:(CMGyroData *)gyroData
                              timestamp:(NSString *)timestamp
{
    CMRotationRate rotationRate = gyroData.rotationRate;
    
    return [NSString stringWithFormat:@"%@, %f, %f, %f, %f", timestamp, gyroData.timestamp, rotationRate.x, rotationRate.y, rotationRate.z];
}

+ (NSString *)stringWithMagnetometerSensingData:(CMMagnetometerData *)magnetometerData
                                      timestamp:(NSString *)timestamp
{
    CMMagneticField field = magnetometerData.magneticField;
    
    return [NSString stringWithFormat:@"%@, %f, %f, %f, %f", timestamp, magnetometerData.timestamp, field.x, field.y, field.z];
}

+ (NSString *)stringWithDeviceMotionSensingData:(CMDeviceMotion *)motion
                                      timestamp:(NSString *)timestamp
{
    CMAttitude *attitude = motion.attitude;
    CMAcceleration gravity = motion.gravity;
    CMCalibratedMagneticField magneticField = motion.magneticField;
    CMRotationRate rotationRate = motion.rotationRate;
    CMAcceleration userAcceleration = motion.userAcceleration;
    
    // Fused Data
    //NSLog(@"%.2f \t %.2f \t %.2f \t %.2f \t %.2f \t %.2f", userAcceleration.x, userAcceleration.y, userAcceleration.z, gravity.x, gravity.y, gravity.z);
    
    return [NSString stringWithFormat:@"%@, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d, %f, %f, %f, %f, %f, %f", timestamp, motion.timestamp, attitude.roll, attitude.pitch, attitude.yaw, gravity.x, gravity.y, gravity.z, magneticField.field.x, magneticField.field.y, magneticField.field.z, magneticField.accuracy, rotationRate.x, rotationRate.y, rotationRate.z, userAcceleration.x, userAcceleration.y, userAcceleration.z];
}

+ (NSString *)stringWithActivitySensingData:(CMMotionActivity *)activity
                                  timestamp:(NSString *)timestamp
{
    NSString *confidence = [NSString stringWithCMMotionActivityConfidence:activity.confidence];
    
    return [NSString stringWithFormat:@"%@, %f, %d, %d, %d, %d, %d, %@", timestamp, activity.timestamp, activity.stationary, activity.walking, activity.running, activity.automotive, activity.unknown, confidence];
}

+ (NSString *)stringWithBatterySensingDataWithLabel:(NSString *)label
                                              state:(UIDeviceBatteryState)state
                                              level:(CGFloat)level
                                          timestamp:(NSString *)timestamp
{
    NSString *stateString = [NSString stringWithUIDeviceBatteryState:state];
    
    return [NSString stringWithFormat:@"%@, %@, %@, %f", timestamp, label, stateString, level];
}

@end
