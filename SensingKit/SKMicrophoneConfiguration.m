//
//  SKMicrophoneConfiguration.m
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

#import "SKMicrophoneConfiguration.h"

@implementation SKMicrophoneConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        // Set default values
        _recordingFormat = SKMicrophoneRecordingFormatAAC;
        _recordingQuality = SKMicrophoneRecordingQualityMedium;
        _sampleRate = 44100.0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKMicrophoneConfiguration *configuration = [super copyWithZone:zone];
    configuration.outputDirectory = _outputDirectory;
    configuration.recordingFilename = _recordingFilename;
    configuration.recordingFormat = _recordingFormat;
    configuration.recordingQuality = _recordingQuality;
    configuration.sampleRate = _sampleRate;
    
    return configuration;
}

+ (NSString *)extensionForRecordingFormat:(SKMicrophoneRecordingFormat)recordingFormat
{
    switch (recordingFormat)
    {
        case SKMicrophoneRecordingFormatPCM:
            return @"pcm";
            
        case SKMicrophoneRecordingFormatAAC:
            return @"m4a";
            
        case SKMicrophoneRecordingFormatMP3:
            return @"mp3";
            
        default:
            NSLog(@"Unknown SKMicrophoneRecordingFormat: %lu", (unsigned long)recordingFormat);
            abort();
    }
}

- (NSURL *)recordingPath
{
    NSString *extension = [SKMicrophoneConfiguration extensionForRecordingFormat:self.recordingFormat];
    return [self.outputDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", self.recordingFilename, extension]];
}

@end
