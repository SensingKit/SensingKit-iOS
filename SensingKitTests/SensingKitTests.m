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
    XCTAssertTrue([[NSString stringWithSensorType:Accelerometer]      isEqualToString:@"Accelerometer"],      @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Gyroscope]          isEqualToString:@"Gyroscope"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Magnetometer]       isEqualToString:@"Magnetometer"],       @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:DeviceMotion]       isEqualToString:@"DeviceMotion"],       @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Activity]           isEqualToString:@"Activity"],           @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Pedometer]          isEqualToString:@"Pedometer"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Altimeter]          isEqualToString:@"Altimeter"],          @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Battery]            isEqualToString:@"Battery"],            @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:Location]           isEqualToString:@"Location"],           @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:iBeaconProximity]   isEqualToString:@"iBeaconProximity"],   @"Sensor name is wrong.");
    XCTAssertTrue([[NSString stringWithSensorType:EddystoneProximity] isEqualToString:@"EddystoneProximity"], @"Sensor name is wrong.");
}

- (void)testSensingKitLib
{
    XCTAssertNotNil(self.sensingKit, @"SensingKitLib cannot be nil.");
    
    SensingKitLib *sensingKit2 = [SensingKitLib sharedSensingKitLib];
    XCTAssertNotNil(sensingKit2, @"SensingKitLib cannot be nil.");
    XCTAssertEqual(self.sensingKit, sensingKit2, @"Instances should be identical.");
    
    [self.sensingKit registerSensor:Battery];
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
    [self.sensingKit deregisterSensor:Battery];
    XCTAssertFalse([self.sensingKit isSensorRegistered:Battery], @"Sensor should not be registered.");
}

- (void)testSensorRegistrationDeregistration
{
    // test registration
    [self.sensingKit registerSensor:Accelerometer];
    [self.sensingKit registerSensor:Gyroscope];
    [self.sensingKit registerSensor:Magnetometer];
    [self.sensingKit registerSensor:DeviceMotion];
    [self.sensingKit registerSensor:Activity];
    [self.sensingKit registerSensor:Pedometer];
    [self.sensingKit registerSensor:Altimeter];
    [self.sensingKit registerSensor:Battery];
    [self.sensingKit registerSensor:Location];
    [self.sensingKit registerSensor:iBeaconProximity];
    [self.sensingKit registerSensor:EddystoneProximity];
    
    // test deregistration
    [self.sensingKit deregisterSensor:Accelerometer];
    [self.sensingKit deregisterSensor:Gyroscope];
    [self.sensingKit deregisterSensor:Magnetometer];
    [self.sensingKit deregisterSensor:DeviceMotion];
    [self.sensingKit deregisterSensor:Activity];
    [self.sensingKit deregisterSensor:Pedometer];
    [self.sensingKit deregisterSensor:Altimeter];
    [self.sensingKit deregisterSensor:Battery];
    [self.sensingKit deregisterSensor:Location];
    [self.sensingKit deregisterSensor:iBeaconProximity];
    [self.sensingKit deregisterSensor:EddystoneProximity];
}

@end
