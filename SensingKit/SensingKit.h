//
//  SKSensorManager.h
//  SensingKit
//
//  Copyright (c) 2016. Kleomenis Katevas
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

#import <Foundation/Foundation.h>

//! Project version number for SensingKit.
FOUNDATION_EXPORT double SensingKitVersionNumber;

//! Project version string for SensingKit.
FOUNDATION_EXPORT const unsigned char SensingKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SensingKit/PublicHeader.h>

#import <SensingKit/SensingKitLib.h>

#import <SensingKit/SKErrors.h>
#import <SensingKit/SKSensorType.h>
#import <SensingKit/NSString+SensorType.h>
#import <SensingKit/SKSensorDataHandler.h>

// Sensor Data
#import <SensingKit/SKAccelerometerData.h>
#import <SensingKit/SKGyroscopeData.h>
#import <SensingKit/SKMagnetometerData.h>
#import <SensingKit/SKDeviceMotionData.h>
#import <SensingKit/SKMotionActivityData.h>
#import <SensingKit/SKPedometerData.h>
#import <SensingKit/SKAltimeterData.h>
#import <SensingKit/SKBatteryData.h>
#import <SensingKit/SKLocationData.h>
#import <SensingKit/SKHeadingData.h>
#import <SensingKit/SKProximityData.h>
#import <SensingKit/SKiBeaconDeviceData.h>
#import <SensingKit/SKEddystoneProximityData.h>
#import <SensingKit/SKMicrophoneData.h>

// Sensor Configuration
#import <SensingKit/SKAccelerometerConfiguration.h>
#import <SensingKit/SKGyroscopeConfiguration.h>
#import <SensingKit/SKMagnetometerConfiguration.h>
#import <SensingKit/SKDeviceMotionConfiguration.h>
#import <SensingKit/SKMotionActivityConfiguration.h>
#import <SensingKit/SKPedometerConfiguration.h>
#import <SensingKit/SKAltimeterConfiguration.h>
#import <SensingKit/SKBatteryConfiguration.h>
#import <SensingKit/SKLocationConfiguration.h>
#import <SensingKit/SKHeadingConfiguration.h>
#import <SensingKit/SKiBeaconProximityConfiguration.h>
#import <SensingKit/SKEddystoneProximityConfiguration.h>
#import <SensingKit/SKMicrophoneConfiguration.h>
