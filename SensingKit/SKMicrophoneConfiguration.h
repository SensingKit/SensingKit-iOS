//
//  SKMicrophoneConfiguration.h
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

#import "SKConfiguration.h"

/**
 *  These constants indicate the recording format of the Microphone sensor.
 */
typedef NS_ENUM(NSUInteger, SKMicrophoneRecordingFormat){
    /**
     *  Linear PCM is an uncompressed audio data format.
     */
    SKMicrophoneRecordingFormatLinearPCM = 0,
    /**
     *  MPEG-4 AAC audio data format.
     */
    SKMicrophoneRecordingFormatMPEG4AAC
};

/**
 *  These constants indicate the recording quality of the Microphone sensor.
 */
typedef NS_ENUM(NSUInteger, SKMicrophoneRecordingQuality){
    /**
     *  Minimum recording quality
     */
    SKMicrophoneRecordingQualityMin = 0,
    /**
     *  Low recording quality
     */
    SKMicrophoneRecordingQualityLow,
    /**
     *  Medium recording quality
     */
    SKMicrophoneRecordingQualityMedium,
    /**
     *  High recording quality
     */
    SKMicrophoneRecordingQualityHigh,
    /**
     *  Maximum recording quality
     */
    SKMicrophoneRecordingQualityMax
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  An instance of SKMicrophoneConfiguration can be used to configure the Microphone sensor.
 */
@interface SKMicrophoneConfiguration : SKConfiguration <NSCopying>

/**
 *  <#Description#>
 *
 *  @param outputDirectory <#outputDirectory description#>
 *  @param filename        <#filename description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithOutputDirectory:(NSURL *)outputDirectory withFilename:(NSString *)filename;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSURL *outputDirectory;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  <#Description#>
 */
@property (nonatomic, copy, readonly) NSURL *recordingPath;

/**
 *  <#Description#>
 */
@property (nonatomic) SKMicrophoneRecordingFormat recordingFormat;

/**
 *  <#Description#>
 */
@property (nonatomic) SKMicrophoneRecordingQuality recordingQuality;

/**
 *  The audio format sampling rate in hertz.
 */
@property (nonatomic) float sampleRate;

@end

NS_ASSUME_NONNULL_END
