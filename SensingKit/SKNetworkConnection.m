//
//  SKNetworkConnection.m
//  SensingKit
//
//  Copyright (c) 2014. Kleomenis Katevas
//  Kleomenis Katevas, minos.kat@gmail.com
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

#import "SKNetworkConnection.h"
#import "SKNetworkConnectionData.h"

#include <net/if.h>
#include <ifaddrs.h>

typedef struct {
    uint64_t sent;
    uint64_t received;
} SKNetworkDataStruct;

@interface SKNetworkConnection ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger *sampleRate;

@end


@implementation SKNetworkConnection

- (instancetype)initWithConfiguration:(SKNetworkConnectionConfiguration *)configuration
{
    if (self = [super init])
    {
        self.configuration = configuration;
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    super.configuration = configuration;
    
    // Cast the configuration instance
    // SKNetworkConnectionConfiguration *networkConnectionConfiguration = (SKNetworkConnectionConfiguration *)configuration;
    
    // Make the required updates on the sensor
    //
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    // Always available
    return YES;
}

- (BOOL)startSensing:(NSError **)error
{
    if (![super startSensing:error]) {
        return NO;
    }
    
    if (![SKNetworkConnection isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Network Connection sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    SKNetworkConnectionConfiguration *networkConnectionConfiguration = (SKNetworkConnectionConfiguration *)self.configuration;
    NSTimeInterval interval = 1 / networkConnectionConfiguration.sampleRate;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        SKNetworkConnectionData *data = [self dataConsumpted];
        [self submitSensorData:data error:NULL];
    }];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    [self.timer invalidate];
    self.timer = nil;
    
    return [super stopSensing:error];
}

// thanks to:
// https://stackoverflow.com/questions/7946699/iphone-data-usage-tracking-monitoring
- (SKNetworkConnectionData *)dataConsumpted
{
    SKNetworkDataStruct wifiData = {0, 0};
    SKNetworkDataStruct cellularData = {0, 0};
    
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs) == 0)
    {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL)
        {
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                NSString *name = @(cursor->ifa_name);
                
                if ([name hasPrefix:@"en"])  // WiFi
                {
                    [self accumulateBytesForIfAddress:cursor
                                             intoSent:&wifiData.sent
                                          andReceived:&wifiData.received];
                }
                else if ([name hasPrefix:@"pdp_ip"])  // Cellular
                {
                    [self accumulateBytesForIfAddress:cursor 
                                             intoSent:&cellularData.sent
                                          andReceived:&cellularData.received];
                }
                // else not interested, ignore
            }

            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    SKNetworkConnectionData *networkConnectionData = [[SKNetworkConnectionData alloc] initWithWifiSent:wifiData.sent
                                                                                          wifiReceived:wifiData.received
                                                                                          cellularSent:cellularData.sent
                                                                                      cellularReceived:cellularData.received];

    return networkConnectionData;
}

- (void)accumulateBytesForIfAddress:(const struct ifaddrs *)ifaddrs
                           intoSent:(uint64_t *)sent
                        andReceived:(uint64_t *)received
{
    const struct if_data *ifa_data = (struct if_data *)ifaddrs->ifa_data;
    if (ifa_data != NULL)
    {
        *sent += ifa_data->ifi_obytes;
        *received += ifa_data->ifi_ibytes;
    }
}

@end
