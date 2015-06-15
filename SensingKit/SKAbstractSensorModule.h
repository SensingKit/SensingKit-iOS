//
//  SKAbstractSensorModule.h
//  SensingKit
//
//  Created by Minos Katevas on 13/06/2015.
//  Copyright (c) 2015 Queen Mary University of London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSensorModuleType.h"
#import "SKSensorDataListener.h"

@interface SKAbstractSensorModule : NSObject

@property (nonatomic, readonly) SKSensorModuleType moduleType;
@property (nonatomic, readonly, getter=isSensing) BOOL sensing;

- (void)subscribeSensorDataListener:(SKSensorDataHandler)handler;

- (void)unsubscribeSensorDataListener:(SKSensorDataHandler)handler;

- (void)unsubscribeAllSensorDataListeners;

- (void)startSensing;

- (void)stopSensing;

@end
