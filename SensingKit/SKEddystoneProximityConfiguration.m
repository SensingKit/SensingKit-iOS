//
//  SKEddystoneProximityConfiguration.m
//  SensingKit
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

- (void)setNamespaceFilter:(NSString *)namespaceFilter
{
    if (![SKEddystoneProximityConfiguration isNamespaceValid:namespaceFilter])
    {
        NSLog(@"Warning: Identifier '%@' is not valid. Namespace should be formatted as a 10-byte hexadecimal string.", namespaceFilter);
    }

    _namespaceFilter = namespaceFilter.lowercaseString;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKEddystoneProximityConfiguration *configuration = [super copyWithZone:zone];
    configuration.mode = _mode;
    configuration.namespaceFilter = _namespaceFilter;
    
    return configuration;
}

+ (BOOL)isNamespaceValid:(NSString *)string
{
    if (!string)
    {
        // Nil are valid
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
