//
//  SKProximityData.m
//  SensingKit
//
//  Created by Minos Katevas on 17/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import "SKProximityData.h"

@implementation SKProximityData

- (instancetype)initWithIdentifier:(NSString *)identifier
                      withAccuracy:(CLLocationAccuracy)accuracy
                     withProximity:(CLProximity)proximity
                          withRssi:(NSInteger)rssi
{
    if (self = [super init])
    {
        _identifier = identifier;
        _accuracy = accuracy;
        _proximity = proximity;
        _rssi = rssi;
    }
    return self;
}

@end
