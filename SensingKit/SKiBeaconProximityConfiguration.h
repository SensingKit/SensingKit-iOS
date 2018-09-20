//
//  SKiBeaconProximityConfiguration.h
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

#import <Foundation/Foundation.h>

#import "SKConfiguration.h"

/**
 *  These constants indicate the mode of the iBeacon™ Proximity sensor.
 */
typedef NS_ENUM(NSUInteger, SKiBeaconProximityMode){
    /**
     *  Scan only mode ranges for other iBeacons registered to the same UUID that exist in range.
     */
    SKiBeaconProximityModeScanOnly = 0,
    /**
     *  Broadcast only mode broadcasts an iBeacon™ signal to nearby devices.
     */
    SKiBeaconProximityModeBroadcastOnly,
    /**
     *  This mode both ranges and broadcasts an iBeacon™ signal at the same time.
     */
    SKiBeaconProximityModeScanAndBroadcast
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKiBeaconProximityConfiguration can be used to configure the iBeacon™ Proximity sensor.
 */
@interface SKiBeaconProximityConfiguration : SKConfiguration <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns an SKiBeaconProximityConfiguration object, initialized with the UUID .
 *
 *  @param UUID The Universally Unique Identifiers (UUID) that will be used to distinguish the iBeacon™ devices of this application with other devices. Only iBeacons with the same UUID will be identified.
 *
 *  @return A new SKiBeaconProximityConfiguration object.
 */
- (instancetype)initWithUUID:(NSUUID *)UUID NS_DESIGNATED_INITIALIZER;

/**
 *  The Universally Unique Identifiers (UUID) that will be used to distinguish the iBeacon™ devices of this application with other devices. Only iBeacons with the same UUID will be identified.
 */
@property (nonatomic, copy) NSUUID *UUID;

/**
 *  Mode of the iBeacon™ Proximity sensor. It can Scan for other iBeacon™ devices in range, Broadcast an iBeacon™ signal to other devices, or both Scan and Broadcast simultaneously.
 */
@property (nonatomic) SKiBeaconProximityMode mode;

/**
 *  A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535. This identifier can be used in combination with the minor identifier.
 */
@property (nonatomic) uint16_t major;

/**
 *  A 16-bit unsigned integer identifier used to identify each device uniquelly. It ranges between 0 and 65535. This identifier can be used in combination with the major identifier.
 */
@property (nonatomic) uint16_t minor;

/**
 *  The strength of the signal measured at a distance of 1 meter.
 */
@property (nonatomic, copy) NSNumber * _Nullable measuredPower;

@end

NS_ASSUME_NONNULL_END
