//
//  SensingKitTests.m
//  SensingKitTests
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

#import <XCTest/XCTest.h>
#import "SensingKitLib.h"
#import "NSString+SensorType.h"

@import CoreBluetooth;


@interface SensingKitTests : XCTestCase

@property (nonatomic, strong) SensingKitLib *sensingKit;

@end

@implementation SensingKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Init SensingKitLib
    self.sensingKit = [SensingKitLib sharedSensingKitLib];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSensorStrings
{
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Accelerometer]      isEqualToString:@"Accelerometer"],      @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Gyroscope]          isEqualToString:@"Gyroscope"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Magnetometer]       isEqualToString:@"Magnetometer"],       @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:DeviceMotion]       isEqualToString:@"DeviceMotion"],       @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:MotionActivity]     isEqualToString:@"MotionActivity"],     @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Pedometer]          isEqualToString:@"Pedometer"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Altimeter]          isEqualToString:@"Altimeter"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Battery]            isEqualToString:@"Battery"],            @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Location]           isEqualToString:@"Location"],           @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:iBeaconProximity]   isEqualToString:@"iBeaconProximity"],   @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:EddystoneProximity] isEqualToString:@"EddystoneProximity"], @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Microphone]         isEqualToString:@"Microphone"],         @"Sensor name is wrong.");
}

- (void)testSensingKitLib
{
    XCTAssertNotNil(self.sensingKit, @"SensingKitLib cannot be nil.");
    
    SensingKitLib *sensingKit2 = [SensingKitLib sharedSensingKitLib];
    XCTAssertNotNil(sensingKit2, @"SensingKitLib cannot be nil.");
    XCTAssertEqual(self.sensingKit, sensingKit2, @"Instances should be identical.");
    
    [self.sensingKit registerSensor:Battery error:NULL];
    XCTAssertTrue([self.sensingKit isSensorRegistered:Battery], @"Sensor should be registered.");
    XCTAssertFalse([self.sensingKit isSensorSensing:Battery], @"Sensor should not be sensing.");
    
    // Subscribe a sensor data listener
    [self.sensingKit subscribeToSensor:Battery
                           withHandler:^(SKSensorType sensorType, SKSensorData *sensorData) {
                                                         // Do nothing
                                                     }];
    
    [self.sensingKit startContinuousSensingWithSensor:Battery];
    XCTAssertTrue([self.sensingKit isSensorSensing:Battery], @"Sensor should be sensing.");
    
    [self.sensingKit stopContinuousSensingWithSensor:Battery];
    XCTAssertFalse([self.sensingKit isSensorSensing:Battery], @"Sensor should not be sensing.");
    
    // Do not unsubscribe here.. (should be automated by deregisterSensor)
    [self.sensingKit deregisterSensor:Battery error:NULL];
    XCTAssertFalse([self.sensingKit isSensorRegistered:Battery], @"Sensor should not be registered.");
}

- (void)testSensorRegistrationDeregistration
{
    // test registration
    [self.sensingKit registerSensor:Accelerometer error:NULL];
    [self.sensingKit registerSensor:Gyroscope error:NULL];
    [self.sensingKit registerSensor:Magnetometer error:NULL];
    [self.sensingKit registerSensor:DeviceMotion error:NULL];
    [self.sensingKit registerSensor:MotionActivity error:NULL];
    [self.sensingKit registerSensor:Pedometer error:NULL];
    [self.sensingKit registerSensor:Altimeter error:NULL];
    [self.sensingKit registerSensor:Battery error:NULL];
    [self.sensingKit registerSensor:Location error:NULL];
    [self.sensingKit registerSensor:iBeaconProximity error:NULL];
    [self.sensingKit registerSensor:EddystoneProximity error:NULL];
    [self.sensingKit registerSensor:Microphone error:NULL];
    
    // test deregistration
    [self.sensingKit deregisterSensor:Accelerometer error:NULL];
    [self.sensingKit deregisterSensor:Gyroscope error:NULL];
    [self.sensingKit deregisterSensor:Magnetometer error:NULL];
    [self.sensingKit deregisterSensor:DeviceMotion error:NULL];
    [self.sensingKit deregisterSensor:MotionActivity error:NULL];
    [self.sensingKit deregisterSensor:Pedometer error:NULL];
    [self.sensingKit deregisterSensor:Altimeter error:NULL];
    [self.sensingKit deregisterSensor:Battery error:NULL];
    [self.sensingKit deregisterSensor:Location error:NULL];
    [self.sensingKit deregisterSensor:iBeaconProximity error:NULL];
    [self.sensingKit deregisterSensor:EddystoneProximity error:NULL];
    [self.sensingKit deregisterSensor:Microphone error:NULL];
}

@end
