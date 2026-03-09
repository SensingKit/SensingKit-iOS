//
//  SKScreenBrightness.m
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

#import "SKScreenBrightness.h"
#import "SKScreenBrightnessData.h"


@implementation SKScreenBrightness

- (instancetype)initWithConfiguration:(SKScreenBrightnessConfiguration *)configuration
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
    // SKScreenBrightnessConfiguration *screenBrightnessConfiguration = (SKScreenBrightnessConfiguration *)configuration;
    
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
    
    if (![SKScreenBrightness isSensorAvailable])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Screen Brightness sensor is not available.", nil),
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKSensorNotAvailableError
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    // Register for screen brightness level notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(brightnessLevelChanged:)
                                                 name:UIScreenBrightnessDidChangeNotification object:nil];
    
    return YES;
}

- (BOOL)stopSensing:(NSError **)error
{
    // Unregister screen brightness level notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    return [super stopSensing:error];
}

- (CGFloat)brightnessLevel
{
    return [UIScreen mainScreen].brightness;
}

- (void)brightnessLevelChanged:(NSNotification *)notification
{
    SKScreenBrightnessData *data = [[SKScreenBrightnessData alloc] initWithLevel:[self brightnessLevel]];
    
    [self submitSensorData:data error:NULL];
}


@end
