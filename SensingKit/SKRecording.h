//
//  SKRecording.h
//  SensingKit
//
//  Created by Minos Katevas on 09/11/2014.
//  Copyright (c) 2014 Queen Mary University of London. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKRecording : NSObject

@property (readonly, nonatomic, strong) NSArray *recordingLog;
@property (nonatomic, strong) NSString *recordingName;
@property (nonatomic, strong) NSDictionary *options;

- (void)startSensing;
- (void)stopSensing;
- (void)pauseSensing;
- (void)continueSensing;

- (void)saveSyncPoint;

@end
