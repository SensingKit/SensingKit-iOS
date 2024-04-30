//
//  SKNetworkConnectionData.h
//  SensingKit
//
//  Copyright (c) 2014. Kleomenis Katevas
//  Kleomenis Katevas, minos.kat@gmail.com
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

#import <UIKit/UIDevice.h>
#import <Foundation/Foundation.h>

#import <SensingKit/SKSensorData.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    
    // WiFi
    uint64_t wifiSent;
    uint64_t wifiReceived;
    
    // Cellular
    uint64_t cellularSent;
    uint64_t cellularReceived;
    
} SKNetworkDataActivity;


/**
 *  An instance of SKNetworkConnectionData encapsulates measurements related to the Network Connection sensor.
 */
@interface SKNetworkConnectionData : SKSensorData

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSensorType:(SKSensorType)sensorType
                         timestamp:(SKSensorTimestamp *)timestamp NS_UNAVAILABLE;

/**
 *  Returns an SKNetworkConnectionData object, initialized with measurements related to the network connection and data activity.
 *
 *  @param networkDataActivity TODO: .
 *  @return An SKNetworkConnectionData object.
 */
- (instancetype)initWithNetworkDataActivity:(SKNetworkDataActivity)networkDataActivity NS_DESIGNATED_INITIALIZER;

/**
 *  A float number that indicates the current screen brightness level. Value ranges from 0.0 (minimum brightness) to 1.0 (maximum brightness).
 */
@property (nonatomic, readonly) UInt64 wifiSent;

/**
 *  A float number that indicates the current screen brightness level. Value ranges from 0.0 (minimum brightness) to 1.0 (maximum brightness).
 */
@property (nonatomic, readonly) UInt64 wifiReceived;

/**
 *  A float number that indicates the current screen brightness level. Value ranges from 0.0 (minimum brightness) to 1.0 (maximum brightness).
 */
@property (nonatomic, readonly) UInt64 cellularSent;

/**
 *  A float number that indicates the current screen brightness level. Value ranges from 0.0 (minimum brightness) to 1.0 (maximum brightness).
 */
@property (nonatomic, readonly) UInt64 cellularReceived;

/**
 *  A string with a CSV formatted header that describes the data of the Network Connection sensor. This method is useful in combination with the csvString instance method of an SKSensorData object.
 *
 *  @return A string with a CSV header.
 */
+ (NSString *)csvHeader;

@end

NS_ASSUME_NONNULL_END
