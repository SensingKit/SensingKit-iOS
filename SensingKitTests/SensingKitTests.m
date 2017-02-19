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

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import <SensingKit/SensingKit.h>


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
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:ScreenStatus]       isEqualToString:@"ScreenStatus"],       @"Sensor name is wrong.");
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
                           withHandler:^(SKSensorType sensorType, SKSensorData *sensorData, NSError *error) {
                               // Do nothing
                           } error:NULL];
    
    [self.sensingKit startContinuousSensingWithSensor:Battery error:NULL];
    XCTAssertTrue([self.sensingKit isSensorSensing:Battery], @"Sensor should be sensing.");
    
    [self.sensingKit stopContinuousSensingWithSensor:Battery error:NULL];
    XCTAssertFalse([self.sensingKit isSensorSensing:Battery], @"Sensor should not be sensing.");
    
    // Do not unsubscribe here.. (should be automated by deregisterSensor)
    [self.sensingKit deregisterSensor:Battery error:NULL];
    XCTAssertFalse([self.sensingKit isSensorRegistered:Battery], @"Sensor should not be registered.");
}

- (void)testSensorAvailibility
{
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        // No need for XCTAssert here, it just needs to pass without crashing (abort())
        [self.sensingKit isSensorAvailable:i];
    }
}

- (void)testSensorRegistrationDeregistration
{
    // test registration
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // if sensor is available
        if ([self.sensingKit isSensorAvailable:(SKSensorType)i]) {
            
            // registration should be permitted
            XCTAssertTrue([self.sensingKit registerSensor:i error:NULL]);
        }
        else {
            
            // error
            XCTAssertFalse([self.sensingKit registerSensor:i error:NULL]);
        }
    }
    
    // test isRegistered
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // if sensor is available
        if ([self.sensingKit isSensorAvailable:(SKSensorType)i]) {
            
            // Sensor should now be registered
            XCTAssertTrue([self.sensingKit isSensorRegistered:i]);
        }
        else {
            
            // Sensor should not be registered as registration was not permitted previously
            XCTAssertFalse([self.sensingKit isSensorRegistered:i]);
        }
    }

    // test deregistration
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // if sensor is available
        if ([self.sensingKit isSensorAvailable:(SKSensorType)i]) {
            
            // deregistration should be permitted
            XCTAssertTrue([self.sensingKit deregisterSensor:i error:NULL]);
        }
        else
        {
            
            // error
            XCTAssertFalse([self.sensingKit deregisterSensor:i error:NULL]);
        }
    }
    
    // test isRegistered again
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // All sensors should now now be registered
        XCTAssertFalse([self.sensingKit isSensorRegistered:i]);
    }
}

@end
