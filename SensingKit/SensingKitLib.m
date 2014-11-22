//
//  SensingKitLib.m
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

#import "SensingKitLib.h"
#import "SKModelManager.h"

@interface SensingKitLib()

@property (nonatomic, strong) SKModelManager* modelManager;

@end

@implementation SensingKitLib

+ (id)sharedSensingKitLib
{
    static SensingKitLib *sensingKitLib;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sensingKitLib = [[self alloc] init];
    });
    return sensingKitLib;
}


- (id)init
{
    if (self = [super init])
    {
        // init Model Manager and assign to recordings array
        self.modelManager = [[SKModelManager alloc] init];
        _recordings = self.modelManager.recordings;
    }
    return self;
}

- (SKRecording *)newRecording
{
    SKRecording *recording = [[SKRecording alloc] init];
    
    [self.modelManager createRecordingWithName:nil];
    
    return recording;
}

- (void)deleteRecordingWithDetails:(NSDictionary *)recordingDetails
{
    [self.modelManager deleteRecording:recordingDetails];
}

@end
