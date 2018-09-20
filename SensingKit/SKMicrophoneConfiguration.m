//
//  SKMicrophoneConfiguration.m
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

#import "SKMicrophoneConfiguration.h"

@implementation SKMicrophoneConfiguration

- (nonnull instancetype)initWithOutputDirectory:(nonnull NSURL *)outputDirectory withFilename:(nonnull NSString *)filename
{
    if (self = [super init])
    {
        _outputDirectory = outputDirectory;
        _filename = filename;
        
        // Set default values
        _recordingFormat = SKMicrophoneRecordingFormatMPEG4AAC;
        _recordingQuality = SKMicrophoneRecordingQualityMedium;
        _sampleRate = 44100.0;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SKMicrophoneConfiguration *configuration = [super copyWithZone:zone];
    configuration.outputDirectory = _outputDirectory;
    configuration.filename = _filename;
    configuration.recordingFormat = _recordingFormat;
    configuration.recordingQuality = _recordingQuality;
    configuration.sampleRate = _sampleRate;
    
    return configuration;
}

- (BOOL)isValidForSensor:(SKSensorType)sensorType
{
    return sensorType == Microphone;
}

+ (NSString *)extensionForRecordingFormat:(SKMicrophoneRecordingFormat)recordingFormat
{
    switch (recordingFormat)
    {
        case SKMicrophoneRecordingFormatLinearPCM:
            return @"caf";
            
        case SKMicrophoneRecordingFormatMPEG4AAC:
            return @"m4a";
            
        // Don't forget to break!
            
        default:
            // Internal Error. Should never happen.
            NSLog(@"Unknown SKMicrophoneRecordingFormat: %lu", (unsigned long)recordingFormat);
            abort();
    }
}

- (NSURL *)recordingPath
{
    NSString *extension = [SKMicrophoneConfiguration extensionForRecordingFormat:self.recordingFormat];
    return [self.outputDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", self.filename, extension]];
}

@end
