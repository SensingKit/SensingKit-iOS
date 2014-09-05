//
//  NSString+KKSensing.h
//  CrowdSensingApp
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

#import <Foundation/Foundation.h>

@import CoreLocation;
@import CoreMotion;

@interface NSString (KKSensing)

+ (NSString *)stringWithCLProximity:(CLProximity)proximity;
+ (NSString *)stringWithCMMotionActivityConfidence:(CMMotionActivityConfidence)confidence;
+ (NSString *)stringWithUIDeviceBatteryState:(UIDeviceBatteryState)state;

+ (NSString *)stringWithBeaconSensingDataWithLabel:(NSString *)label
                                        identifier:(NSString *)identifier
                                          accuracy:(CLLocationAccuracy)accuracy
                                         proximity:(CLProximity)proximity
                                              rssi:(NSInteger)rssi
                                         timestamp:(NSString *)timestamp;

+ (NSString *)stringWithBeaconSensingDataWithLabel:(NSString *)label
                                        identifier:(NSString *)identifier
                                         timestamp:(NSString *)timestamp;

+ (NSString *)stringWithLocationSensingData:(CLLocation *)location
                                  timestamp:(NSString *)timestamp;

+ (NSString *)stringWithAccelerometerSensingData:(CMAccelerometerData *)accelererometerData
                                       timestamp:(NSString *)timestamp;

+ (NSString *)stringWithGyroSensingData:(CMGyroData *)gyroData
                              timestamp:(NSString *)timestamp;

+ (NSString *)stringWithMagnetometerSensingData:(CMMagnetometerData *)magnetometerData
                                      timestamp:(NSString *)timestamp;

+ (NSString *)stringWithDeviceMotionSensingData:(CMDeviceMotion *)motion
                                      timestamp:(NSString *)timestamp;

+ (NSString *)stringWithActivitySensingData:(CMMotionActivity *)activity
                                  timestamp:(NSString *)timestamp;

+ (NSString *)stringWithBatterySensingDataWithLabel:(NSString *)label
                                              state:(UIDeviceBatteryState)state
                                              level:(CGFloat)level
                                          timestamp:(NSString *)timestamp;

@end
