//
//  SKErrors.h
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

static NSString *const SKErrorDomain = @"org.sensingkit.SensingKit-iOS.ErrorDomain";


/**
 NSError codes in SKErrorDomain.
 */
typedef NS_ENUM(NSInteger, SKSensorError) {
    
/** Sensor Availibility */
    
    /**
     * Sensor is not available.
     */
    SKSensorNotAvailableError = 0,
    
    
    
/** Sensor Registration */
    
    /**
     * Sensor is already registered.
     */
    SKSensorAlreadyRegisteredError = 10,
    
    /**
     * Sensor is not registered.
     */
    SKSensorNotRegisteredError = 11,
    
    
    
/** Sensor Sensing */
    
    /**
     * Sensor is currently sensing.
     */
    SKSensorCurrentlySensingError = 20,
    
    /**
     * Sensor is currently not sensing.
     */
    SKSensorCurrentlyNotSensingError = 21,
    
    
    
/** Sensor Data Handlers */
    
    /**
     * Sensor Data Handler is already registered.
     */
    SKDataHandlerAlreadyRegistered = 30,
    
    /**
     * Sensor Data Handler is not registered
     */
    SKDataHandlerNotRegistered = 31,
    
    
    
/** Sensor Configuration */
    
    /**
     * Configuration is not compatible with the registered sensor.
     */
    SKConfigurationNotValid = 40,
    
    /**
     * Eddystone Proximity Namespace is not valid.
     */
    SKConfigurationEddystoneProximityNamespaceNotValid = 41,
    
    
};
