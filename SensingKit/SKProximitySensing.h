//
//  SKiBeaconSensing.h
//  iBeaconSensing
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

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import CoreLocation;

@protocol SKProximitySensingDelegate <NSObject>

- (void)beaconFoundWithIdentifier:(NSString *)identifier;
- (void)beaconLostWithIdentifier:(NSString *)identifier;

- (void)rangingBeaconWithIdentifier:(NSString *)identifier
                           accuracy:(CLLocationAccuracy)accuracy
                          proximity:(CLProximity)proximity
                               rssi:(NSInteger)rssi;

@end

@interface SKProximitySensing : NSObject<CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) id <SKProximitySensingDelegate> delegate;

- (instancetype)initWithUUID:(NSUUID *)UUID withDeviceId:(NSUInteger)device_id;

- (BOOL)isProximitySensingAvailable;

- (void)startProximitySensing;
- (void)startProximitySensingWithPower:(NSNumber *)power;
- (void)stopProximitySensing;

@end
