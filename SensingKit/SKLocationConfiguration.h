//
//  SKLocationConfiguration.h
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
     *  This mode indicates that there is no authorization for acquiring the location of the device. Location sensor cannot be started with this authorization.
     */
    SKLocationAuthorizationNone = 0,
    /**
     *  Location can be acquired only when the app is running in the foreground.
     */
    SKLocationAuthorizationWhenInUse,
    /**
     *  Location can be acquired even when the app is running in the background.
     */
    SKLocationAuthorizationAlways
};


/**
 *  An instance of SKLocationConfiguration can be used to configure the Location sensor.
 */
@interface SKLocationConfiguration : SKConfiguration <NSCopying>

/**
 *  <#Description#>
 */
@property (nonatomic) SKLocationAccuracy locationAccuracy;

/**
 *  <#Description#>
 */
@property (nonatomic) SKLocationAuthorization locationAuthorization;

/**
 *  <#Description#>
 */
@property (nonatomic) double distanceFilter;

@end
