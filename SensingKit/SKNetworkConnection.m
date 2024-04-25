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


@interface SKNetworkConnection ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) SKNetworkDataActivity totalNetworkDataActivity;

@end


@implementation SKNetworkConnection

- (instancetype)initWithConfiguration:(SKNetworkConnectionConfiguration *)configuration
{
    if (self = [super init])
    {
        self.configuration = configuration;
        self.totalNetworkDataActivity = (SKNetworkDataActivity){0, 0, 0, 0};
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
    
    // Save offset
    SKNetworkDataActivity startSensingOffset = [self getNetworkDataSinceDeviceBoot];
    
    // Start sensor
    SKNetworkConnectionConfiguration *networkConnectionConfiguration = (SKNetworkConnectionConfiguration *)self.configuration;
    NSTimeInterval interval = 1 / networkConnectionConfiguration.sampleRate;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        // get actual data consumped (since start sensing)
        SKNetworkDataActivity currentDataActivity = [self getNetworkDataWithOffset:startSensingOffset];
        
        // accumulate data
        SKNetworkDataActivity totalNetworkDataActivity = self.totalNetworkDataActivity;
        totalNetworkDataActivity.wifiSent += currentDataActivity.wifiSent;
        totalNetworkDataActivity.wifiReceived += currentDataActivity.wifiReceived;
        totalNetworkDataActivity.cellularSent += currentDataActivity.cellularSent;
        totalNetworkDataActivity.cellularReceived += currentDataActivity.cellularReceived;
        self.totalNetworkDataActivity = totalNetworkDataActivity;
        
        SKNetworkConnectionData *data = [[SKNetworkConnectionData alloc] initWithNetworkDataActivity:totalNetworkDataActivity];
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

- (SKNetworkDataActivity)getNetworkDataWithOffset:(SKNetworkDataActivity)offset
{
    SKNetworkDataActivity networkDataActivity = [self getNetworkDataSinceDeviceBoot];
    
    // apply offset
    networkDataActivity.wifiSent -= offset.wifiSent;
    networkDataActivity.wifiReceived -= offset.wifiReceived;
    networkDataActivity.cellularSent -= offset.cellularSent;
    networkDataActivity.cellularReceived -= offset.cellularReceived;
    
    return networkDataActivity;
}

// thanks to:
// https://stackoverflow.com/questions/7946699/iphone-data-usage-tracking-monitoring
- (SKNetworkDataActivity)getNetworkDataSinceDeviceBoot
{
    SKNetworkDataActivity networkDataActivity = (SKNetworkDataActivity){0, 0, 0, 0};
    
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
                                             intoSent:&networkDataActivity.wifiSent
                                          andReceived:&networkDataActivity.wifiReceived];
                }
                else if ([name hasPrefix:@"pdp_ip"])  // Cellular
                {
                    [self accumulateBytesForIfAddress:cursor
                                             intoSent:&networkDataActivity.cellularSent
                                          andReceived:&networkDataActivity.cellularReceived];
                }
                // else, not interested. Ignore.
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return networkDataActivity;
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
