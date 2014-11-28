//
//  SKModelManager.m
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

#import "SKModelManager.h"

@interface SKModelManager()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (strong, nonatomic) NSMutableArray *recordingEntries;  // of NSDictionary *
@property (strong, nonatomic) NSMutableArray *recordingDetails;  // of SKRecordingDetails *

@end

@implementation SKModelManager

+ (SKModelManager *)sharedModelManager
{
    static SKModelManager *modelManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelManager = [[self alloc] init];
    });
    return modelManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveContext
{
    [self.userDefaults setObject:self.recordingEntries forKey:@"Recordings"];
    [self.userDefaults synchronize];
}

- (NSMutableArray *)recordingEntries
{
    if (!_recordingEntries)
    {
        // Get a mutable copy of all recording entries from userDefaults
        _recordingEntries = [[self.userDefaults arrayForKey:@"Recordings"] mutableCopy];
    }
    return _recordingEntries;
}

- (NSMutableArray *)recordingDetails
{
    if (!_recordingDetails)
    {
        // Prepare the SKModelRecording array
        _recordingDetails = [[NSMutableArray alloc] initWithCapacity:self.recordingEntries.count];
        
        for (NSDictionary *entryDetails in self.recordingEntries)
        {
            // Add SKModelRecordings in the array
            SKRecordingDetails *recording = [[SKRecordingDetails alloc] initWithEntryDetails:entryDetails];
            recording.delegate = self;
            
            [_recordingDetails addObject:recording];
        }
    }
    return _recordingDetails;
}

- (NSUInteger)generateRecordingId
{
    // Get the current MaxRecordingId and Increase by 1
    NSUInteger recordingId = [self.userDefaults integerForKey:@"MaxRecordingId"];
    recordingId++;
    
    // Save the new MaxRecordingId
    [self.userDefaults setObject:@(recordingId) forKey:@"MaxRecordingId"];
    [self.userDefaults synchronize];
    
    return recordingId;
}

- (NSArray *)getRecordings
{
    return self.recordingDetails;
}

- (SKRecordingDetails *)createNewRecording
{
    NSUInteger recordingId = [self generateRecordingId];
    
    NSDictionary *entryDetails = @{@"recordingId": @(recordingId),
                                   @"name": @"New Recording",
                                   @"createDate": [NSDate date],
                                   @"folderName": @"tmp"};
    
    SKRecordingDetails *recordingDetails = [[SKRecordingDetails alloc] initWithEntryDetails:entryDetails];
    recordingDetails.delegate = self;
    
    // Add to the NSMutableArrays
    [self.recordingEntries addObject:entryDetails];
    [self.recordingDetails addObject:recordingDetails];
    
    // Save entries
    [self saveContext];
    
    return recordingDetails;
}

- (NSUInteger)findIndexOfRecordingWithId:(NSUInteger)recordingId
{
    NSUInteger index = [self.recordingEntries indexOfObjectPassingTest:^BOOL(id dictionary, NSUInteger idx, BOOL *stop) {
       return [[dictionary objectForKey: @"recordingId"] isEqualToNumber:@(recordingId)];
    }];
    
    return index;
}

- (void)deleteRecordingWithDetails:(SKRecordingDetails *)recordingDetails
{
    // Delete from recordingEntries
    NSUInteger recordingId = recordingDetails.recordingId;
    NSUInteger index = [self findIndexOfRecordingWithId:recordingId];
    
    [self.recordingEntries removeObjectAtIndex:index];
    [self saveContext];
    
    // Delete from recordingDetails
    [self.recordingDetails removeObject:recordingDetails];
}


- (void)updateRecordingWithDictionaryInfo:(NSDictionary *)info
{
    NSUInteger recordingId = [info[@"recordingId"] unsignedIntegerValue];
    
    NSUInteger index = [self findIndexOfRecordingWithId:recordingId];
    
    NSAssert(index != NSNotFound, @"Objet could not be found");
    
    [self.recordingEntries replaceObjectAtIndex:index withObject:info];
    
    [self saveContext];
}

@end
