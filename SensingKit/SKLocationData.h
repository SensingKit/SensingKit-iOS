//
//  SKLocationData.h
//  SensingKit
//
//  Created by Minos Katevas on 15/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSensorData.h"
@import CoreLocation;

@interface SKLocationData : SKSensorData

@property (nonatomic, strong, readonly) CLLocation *location;

- (instancetype)initWithLocation:(CLLocation *)location;

@end
