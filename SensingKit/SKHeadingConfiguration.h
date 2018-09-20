//
//  SKHeadingConfiguration.h
//  SensingKit
//
//  Copyright (c) 2017. Kleomenis Katevas
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

#import "SKConfiguration.h"

@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKHeadingConfiguration can be used to configure the Heading sensor.
 */
@interface SKHeadingConfiguration : SKConfiguration

/**
 *  The minimum angular change (measured in degrees) required to report new heading sensor data.
 */
@property (nonatomic) CLLocationDegrees headingFilter;

/**
 *  The physical orientation of the device, used to compute the heading values more accurately.
 */
@property (nonatomic) CLDeviceOrientation headingOrientation;

/**
 *  Allow the heading calibration alert to be displayed in the device's screen or not.
 */
@property (nonatomic) BOOL displayHeadingCalibration;

@end

NS_ASSUME_NONNULL_END
