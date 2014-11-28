//
//  SKModelRecording.m
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

#import "SKRecordingDetails.h"

@implementation SKRecordingDetails

- (instancetype)initWithEntryDetails:(NSDictionary *)entryDetails
{
    if (self = [super init])
    {
        _recordingId = [entryDetails[@"recordingId"] unsignedIntegerValue];
        _createDate = entryDetails[@"createDate"];
        _name = entryDetails[@"name"];
        _folderName = entryDetails[@"folderName"];
    }
    return self;
}

- (void)saveDetails
{
    NSAssert(self.delegate, @"Error: delegate cannot be nil.");
    
    [self.delegate updateRecordingWithDictionaryInfo:[self inDictionary]];
}

- (NSDictionary *)inDictionary
{
    return @{@"recordingId": @(self.recordingId),
             @"createDate": self.createDate,
             @"name": self.name,
             @"folderName": self.folderName};
}

@end
