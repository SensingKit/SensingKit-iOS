//
//  SKEddystoneProximityConfiguration.h
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
 *  These constants indicate the mode of the Eddystone™ Proximity sensor. At this moment, only Scan mode is supported.
 */
typedef NS_ENUM(NSUInteger, SKEddystoneProximityMode){
    /**
     *  Scan only mode ranges for other Eddystone™ beacons existing in range.
     */
    SKEddystoneProximityModeScanOnly = 0
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKEddystoneProximityConfiguration can be used to configure the Eddystone™ Proximity sensor.
 */
@interface SKEddystoneProximityConfiguration : SKConfiguration <NSCopying>

/**
 *  Mode of the Eddystone™ Proximity sensor. At this moment, only Scan mode is supported.
 */
@property (nonatomic) SKEddystoneProximityMode mode;

/**
 *  A 10-byte (80 bit) identifier that can used to group a particular set of beacons. This value should be in Hexadecimal format, with a maximum character length of 20 characters.
 */
@property (nonatomic, copy, nullable, readonly) NSString *namespaceFilter;

- (BOOL)setNamespaceFilter:(NSString * _Nullable)namespaceFilter error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
