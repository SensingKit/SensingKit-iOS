//
//  SKEddystoneProximityConfiguration.m
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

#import "SKEddystoneProximityConfiguration.h"

@implementation SKEddystoneProximityConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        // Set default values
        _mode = SKEddystoneProximityModeScanOnly;
        _namespaceFilter = nil;  // All Eddystones available
    }
    return self;
}

- (BOOL)isValidForSensor:(SKSensorType)sensorType
{
    return sensorType == EddystoneProximity;
}

- (BOOL)setNamespaceFilter:(NSString *)namespaceFilter error:(NSError **)error
{
    if (![SKEddystoneProximityConfiguration isNamespaceValid:namespaceFilter])
    {
        if (error) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Eddystone Proximity Namespace filter is not valid.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Namespace should be formatted as a 10-byte hexadecimal string.", nil)
                                       };
            
            *error = [NSError errorWithDomain:SKErrorDomain
                                         code:SKConfigurationEddystoneProximityNamespaceNotValid
                                     userInfo:userInfo];
        }
        return NO;
    }
    
    if (namespaceFilter.length == 0) {
        _namespaceFilter = nil;
    }
    else {
        _namespaceFilter = namespaceFilter.lowercaseString;
    }
    
    return YES;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKEddystoneProximityConfiguration *configuration = [super copyWithZone:zone];
    configuration.mode = _mode;
    [configuration setNamespaceFilter:_namespaceFilter error:NULL];
    
    return configuration;
}

+ (BOOL)isNamespaceValid:(NSString *)string
{
    if (!string || string.length == 0)
    {
        // Nil is valid
        return YES;
    }
    if (string.length > 20)
    {
        return NO;
    }
    else
    {
        NSCharacterSet *validCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"].invertedSet;
        return ([string rangeOfCharacterFromSet:validCharacters].location == NSNotFound);
    }
}

@end
