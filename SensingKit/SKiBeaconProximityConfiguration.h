//
//  SKiBeaconProximityConfiguration.h
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

/**
 *  <#Description#>
 *
 *  @param UUID <#uuid description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithUUID:(NSUUID *)UUID;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSUUID *UUID;

/**
 *  <#Description#>
 */
@property (nonatomic) SKiBeaconProximityMode mode;

/**
 *  <#Description#>
 */
@property (nonatomic) uint16_t major;

/**
 *  <#Description#>
 */
@property (nonatomic) uint16_t minor;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSNumber * _Nullable measuredPower;

@end

NS_ASSUME_NONNULL_END
