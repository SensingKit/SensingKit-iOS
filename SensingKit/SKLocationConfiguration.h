//
//  SKLocationConfiguration.h
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
 *  These constants indicate the accuracy of the Location sensor.
 */
typedef NS_ENUM(NSUInteger, SKLocationAccuracy){
    /**
     *  Highest accuracy possible, combined with other sensor data. This accuracy is ideal for Navigation applications were the device can be plagged in a power source.
     */
    SKLocationAccuracyBestForNavigation = 0,
    /**
     *  Highest accuracy possible.
     */
    SKLocationAccuracyBest,
    /**
     *  Ten meters accuracy.
     */
    SKLocationAccuracyNearestTenMeters,
    /**
     *  One hundred meters accuracy.
     */
    SKLocationAccuracyHundredMeters,
    /**
     *  One kilometer accuracy.
     */
    SKLocationAccuracyKilometer,
    /**
     *  Three kilometers accuracy.
     */
    SKLocationAccuracyThreeKilometers
};

/**
 *  These constants indicate the authorization of the Location sensor.
 */
typedef NS_ENUM(NSUInteger, SKLocationAuthorization){
    /**
     *  Location can be acquired only when the app is running in the foreground.
     */
    SKLocationAuthorizationWhenInUse,
    /**
     *  Location can be acquired even when the app is running in the background.
     */
    SKLocationAuthorizationAlways
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKLocationConfiguration can be used to configure the Location sensor.
 */
@interface SKLocationConfiguration : SKConfiguration <NSCopying>

/**
 *  Accuracy of the Location sensor, expressed as an SKLocationAccuracy enumerator.
 */
@property (nonatomic) SKLocationAccuracy locationAccuracy;

/**
 *  Authrorization of the Location sensor, expressed as an SKLocationAuthorization enumerator.
 *  Value can either be When In Use (indicating that sensor will only be active while the app runs in the foreground) or Always (allowing the sensor to be active even when the app runs in the background).
 */
@property (nonatomic) SKLocationAuthorization locationAuthorization;

/**
 *  The minimum distance in meters that the device needs to move horizontally before the SKSensorDataHandler attached with an SKLocationData object is being called.
 */
@property (nonatomic) double distanceFilter;

@end

NS_ASSUME_NONNULL_END
