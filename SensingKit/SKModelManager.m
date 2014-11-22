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
@property (nonatomic) NSInteger maxId;

@end

@implementation SKModelManager

- (id)init
{
    if (self = [super init])
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        [self loadRecordings];
    }
    return self;
}

- (void)save
{
    [self.userDefaults setInteger:self.maxId forKey:@"MaxId"];
    [self.userDefaults setObject:self.recordings forKey:@"Recordings"];
    [self.userDefaults synchronize];
}

- (void)loadRecordings
{
    _maxId = [self.userDefaults integerForKey:@"MaxId"];
    _recordings = [[self.userDefaults arrayForKey:@"Recordings"] mutableCopy];
    
    if (!_recordings)
    {
        _recordings = [[NSMutableArray alloc] init];
        _maxId = 0;
    }
}

- (NSDictionary *)createRecordingWithName:(NSString *)name
{
    if (!name) name = @"New Recording";
    
    NSDictionary *recording = @{@"id": [NSNumber numberWithInteger:self.maxId],
                                @"name": name,
                                @"create_date": [NSDate date]};
    
    [_recordings addObject:recording];
    [self save];
    
    return recording;
}

- (void)deleteRecording:(NSDictionary *)recording
{
    [_recordings removeObject:recording];
    [self save];
}

@end
