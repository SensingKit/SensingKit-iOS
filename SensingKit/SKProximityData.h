//
//  SKProximityData.h
//  SensingKit
//
//  Created by Minos Katevas on 17/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSensorData.h"
@import CoreLocation;

@interface SKProximityData : SKSensorData

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, readonly) CLLocationAccuracy accuracy;
@property (nonatomic, readonly) CLProximity proximity;
@property (nonatomic, readonly) NSInteger rssi;

- (instancetype)initWithIdentifier:(NSString *)identifier
                      withAccuracy:(CLLocationAccuracy)accuracy
                     withProximity:(CLProximity)proximity
                          withRssi:(NSInteger)rssi;

@end
