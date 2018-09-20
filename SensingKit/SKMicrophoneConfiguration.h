//
//  SKMicrophoneConfiguration.h
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

#import <Foundation/Foundation.h>

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

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Returns an SKMicrophoneConfiguration object, initialized with the path of the directory, as well as the filename that the recording will be stored.
 *
 *  @param outputDirectory Path of the directory that the recording will be stored.
 *  @param filename        A string with the desired filename of the recording, without the extension. Extension will be provided automatically based on the recordingFormat.
 *
 *  @return A new SKMicrophoneConfiguration object.
 */
- (instancetype)initWithOutputDirectory:(NSURL *)outputDirectory withFilename:(NSString *)filename NS_DESIGNATED_INITIALIZER;

/**
 *  Path of the directory that the recording will be stored.
 */
@property (nonatomic, copy) NSURL *outputDirectory;

/**
 *  A string with the desired filename of the recording, without the extension. Extension will be provided automatically based on the recordingFormat.
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  A read-only property that returns the full path of the recording filename.
 */
@property (nonatomic, copy, readonly) NSURL *recordingPath;

/**
 *  Recording format of the Microphone sensor.
 */
@property (nonatomic) SKMicrophoneRecordingFormat recordingFormat;

/**
 *  Recording quality of the Microphone sensor.
 */
@property (nonatomic) SKMicrophoneRecordingQuality recordingQuality;

/**
 *  The audio format sampling rate in hertz.
 */
@property (nonatomic) float sampleRate;

@end

NS_ASSUME_NONNULL_END
