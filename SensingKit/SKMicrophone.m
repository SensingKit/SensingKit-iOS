//
//  SKMicrophone.m
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

#import "SKMicrophone.h"
@import AVFoundation;


@interface SKMicrophone () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end


@implementation SKMicrophone

- (instancetype)initWithConfiguration:(SKMicrophoneConfiguration *)configuration
{
    if (self = [super initWithConfiguration:configuration])
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *error;
        [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
        
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [audioSession setActive:YES error:&error];
        
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return self;
}


#pragma mark Configuration

- (void)setConfiguration:(SKConfiguration *)configuration
{
    // Check if the correct configuration type provided
    if (configuration.class != SKMicrophoneConfiguration.class)
    {
        NSLog(@"Wrong SKConfiguration class provided (%@) for sensor Microphone.", configuration.class);
        abort();
    }
    
    if (super.configuration != configuration)
    {
        super.configuration = configuration;
        
        // Cast the configuration instance
        SKMicrophoneConfiguration *microphoneConfiguration = (SKMicrophoneConfiguration *)configuration;
        
        NSDictionary *recordSettings = @{AVEncoderAudioQualityKey: @(AVAudioQualityMedium),
                                         AVEncoderBitRateKey: @(16),
                                         AVNumberOfChannelsKey: @(2),
                                         AVSampleRateKey:@(44100.0)};
        
        NSError *error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:microphoneConfiguration.url
                                                    settings:recordSettings
                                                       error:&error];
        
        [self.recorder prepareToRecord];
    }
}


#pragma mark Sensing

+ (BOOL)isSensorAvailable
{
    // Always available
    return YES;
}

- (void)startSensing
{
    [super startSensing];
    
    //
    if (![self.recorder record])
    {
        NSLog(@"Could not be started.");
    }
}

- (void)stopSensing
{
    //
    if (self.recorder.recording)
    {
        [self.recorder stop];
    }
    
    [super stopSensing];
}

@end
