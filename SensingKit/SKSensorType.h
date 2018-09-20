//
//  SKSensorType.h
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

/**
 *  Total number of sensors supported by SensingKit-iOS.
 */
static NSUInteger const TOTAL_SENSORS = 13;

/**
 *  These constants indicate the type of the sensor.
 */
typedef NS_ENUM(NSUInteger, SKSensorType)
{
    /**
     *  Accelerometer is a sensor that measures the device acceleration changes in three‑dimensional space. You can use this data to detect both the current orientation of the device (relative to the ground) and any instantaneous changes to that orientation.
     */
    Accelerometer = 0,

    /**
     *  Gyroscope is a sensor that measures the device’s rate of rotation around each of the three spatial axes.
     */
    Gyroscope,
    
    /**
     *  Magnetometer (also known as Compass or Magnetic Field Sensor) is a sensor that measures the strength of the magnetic field surrounding the device.
     */
    Magnetometer,
    
    /**
     *  Device Motion sensor uses sensor fusion techniques to provide more advanced and accurate motion measurements. It measures the Attitude, Rotation Rate, Calibrated Magnetic Field, as well as a separation of User Acceleration and Gravity from the device’s acceleration.
     */
    DeviceMotion,
    
    /**
     *  Motion Activity sensor uses an embedded motion co‑processor that senses the user’s activity classified as Stationary, Walking, Running, Automotive or Cycling.
     */
    MotionActivity,
    
    /**
     *  Pedometer sensor uses an embedded motion co‑processor that captures pedestrian‑related data such as step counts, distance traveled and number of floors ascended or descended.
     */
    Pedometer,
    
    /**
     *  Altimeter sensor uses an embedded barometer sensor to capture changes to the relative altitude (not the actual). It also provides the recorded atmospheric pressure in kPa.
     */
    Altimeter,
    
    /**
     *  Battery sensor listens to changes in the battery charge state (Charging, Full, Unplugged) as well as in the battery charge level (with 1% precision).
     */
    Battery,
    
    /**
     *  Location sensor determines the current location of the device using a combination of Cellular, Wi‑Fi, Bluetooth and GPS sensors. It provides 2D geographical coordinate information (latitude, longitude), as well as the altitude of the device.
     */
    Location,
    
    /**
     *  Heading is a sensor that reports the device's orientation relative to magnetic and true north.
     */
    Heading,
    
    /**
     *  iBeacon™ Proximity sensor uses Apple's iBeacon™ technology to estimate the proximity of the current device with other iBeacons in range.
     */
    iBeaconProximity,
    
    /**
     *  Eddystone™ Proximity sensor estimates the proximity of the current device with other Eddystone™ beacons in range.
     */
    EddystoneProximity,
    
    /**
     *  Microphone sensor can be used to record audio from the environment (up to 4 hours) by converting sound into electrical signal.
     */
    Microphone
};
