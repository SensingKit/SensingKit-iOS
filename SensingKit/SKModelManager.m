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

@property (nonatomic, strong) NSMutableArray *recordings;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

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

- (void)save
{
    [self.userDefaults setObject:self.recordings forKey:@"Recordings"];
    [self.userDefaults synchronize];
}

- (NSMutableArray *)recordings
{
    if (!_recordings)
    {
        _recordings = [[self.userDefaults arrayForKey:@"Recordings"] mutableCopy];
    
        if (!_recordings)
        {
            _recordings = [[NSMutableArray alloc] init];
        }
    }
    return _recordings;
}

- (NSNumber *)generateRecordingId
{
    NSNumber *recordingId;
    
    // Get the MaxRecordingId and Increase by 1
    NSInteger maxRecordingId = [self.userDefaults integerForKey:@"MaxRecordingId"];
    recordingId = @(maxRecordingId++);
    
    // Save the new MaxRecordingId
    [self.userDefaults setObject:recordingId forKey:@"MaxRecordingId"];
    
    return recordingId;
}

- (NSArray *)getRecordings
{
    return self.recordings;
}

- (NSMutableDictionary *)createRecording
{
    NSMutableDictionary *recording = [@{@"id": [self generateRecordingId],
                                        @"name": @"New Recording",
                                        @"create_date": [NSDate date]} mutableCopy];
    
    [self.recordings addObject:recording];
    
    [self save];
    
    return recording;
}

- (void)deleteRecording:(NSDictionary *)recording
{
    [self.recordings removeObject:recording];
    [self save];
}

@end
