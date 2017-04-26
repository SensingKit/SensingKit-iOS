//
//  SKHeadingData.h
//  SensingKit
//
//  Copyright (c) 2017. Queen Mary University of London
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

#import <SensingKit/SensingKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKHeadingData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                     withTimestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKHeadingData object, initialized with an instance of CLHeading.
 *
 *  @param heading A CLHeading object that contains Heading related data.
 *
 *  @return An SKHeadingData object.
 */
- (instancetype)initWithHeading:(CLHeading *)heading NS_DESIGNATED_INITIALIZER;

/** TODO
 *  A CLHeading object contains data related to the location of the device, as well as the accuracy of the measurements. More specifically it provides location coordinates, altitude and the logical floor of the building that the user is located. It also provides the instantaneous speed and the course of the device when the user is moving. For more information, please refer to Apple's Core Location documentation.
 */
@property (nonatomic, readonly, copy) CLHeading *heading;

/**
 *  A string with a CSV formatted header that describes the data of the Heading sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
