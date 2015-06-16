//
//  SKLocationData.m
//  SensingKit
//
//  Created by Minos Katevas on 15/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import "SKLocationData.h"

@implementation SKLocationData

- (instancetype)initWithLocation:(CLLocation *)location
{
    if (self = [super initWithTimestamp:location.timestamp])
    {
        _location = location;
    }
    return self;
}

@end
