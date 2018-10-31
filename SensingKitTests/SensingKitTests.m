//
//  SensingKitTests.m
//  SensingKitTests
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
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:BatteryStatus]            isEqualToString:@"BatteryStatus"],            @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Location]           isEqualToString:@"Location"],           @"Sensor name is wrong.");
    XCTAssertTrue([[NSString nonspacedStringWithSensorType:Heading]            isEqualToString:@"Heading"],           @"Sensor name is wrong.");
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
    
    XCTAssertTrue([self.sensingKit registerSensor:BatteryStatus error:NULL], @"Sensor registration should be allowed.");
    XCTAssertTrue([self.sensingKit isSensorRegistered:BatteryStatus], @"Sensor should be registered.");
    XCTAssertFalse([self.sensingKit isSensorSensing:BatteryStatus], @"Sensor should not be sensing.");
    
    // Subscribe a sensor data listener
    XCTAssertTrue([self.sensingKit subscribeToSensor:BatteryStatus
                                         withHandler:^(SKSensorType sensorType, SKSensorData *sensorData, NSError *error) {
                                            // Do nothing
                                         } error:NULL], @"Subscribe to sensor should be allowed.");
    
    XCTAssertFalse([self.sensingKit subscribeToSensor:Accelerometer
                                         withHandler:^(SKSensorType sensorType, SKSensorData *sensorData, NSError *error) {
                                             // Do nothing
                                         } error:NULL], @"Subscribe to sensor should not be allowed as sensor is not registered.");
    
    XCTAssertTrue([self.sensingKit startContinuousSensingWithSensor:BatteryStatus error:NULL], @"Start continuous sensing with a registered sensor with subscribed handler should be allowed.");
    XCTAssertTrue([self.sensingKit isSensorSensing:BatteryStatus], @"Sensor should be sensing.");
    
    XCTAssertTrue([self.sensingKit stopContinuousSensingWithSensor:BatteryStatus error:NULL], @"Stop continuous sensing with a sensor that is currently sensing should be allowed.");
    XCTAssertFalse([self.sensingKit isSensorSensing:BatteryStatus], @"Sensor should not be sensing.");
    
    // Do not unsubscribe here.. (should be automated by deregisterSensor)
    XCTAssertTrue([self.sensingKit deregisterSensor:BatteryStatus error:NULL], @"Sensor should be succesfully deregistered.");
    XCTAssertFalse([self.sensingKit isSensorRegistered:BatteryStatus], @"Sensor should not be registered.");
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
            XCTAssertTrue([self.sensingKit registerSensor:i error:NULL], @"Registration should be permitted.");
        }
        else {
            
            // error
            XCTAssertFalse([self.sensingKit registerSensor:i error:NULL], @"Registration should not be permitted.");
        }
    }
    
    // test isRegistered
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // if sensor is available
        if ([self.sensingKit isSensorAvailable:(SKSensorType)i]) {
            
            XCTAssertTrue([self.sensingKit isSensorRegistered:i], @"Sensor should be registered.");
        }
        else {
            
            XCTAssertFalse([self.sensingKit isSensorRegistered:i], @"Sensor should not be registered as registration was not permitted previously.");
        }
    }

    // test deregistration
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // if sensor is available
        if ([self.sensingKit isSensorAvailable:(SKSensorType)i]) {
            
            XCTAssertTrue([self.sensingKit deregisterSensor:i error:NULL], @"Deregistration should be permitted.");
        }
        else {
            
            XCTAssertFalse([self.sensingKit deregisterSensor:i error:NULL], @"Sensor should not be deregistered as registration was never allowed.");
        }
    }
    
    // test isRegistered again
    for (SKSensorType i = 0; i < TOTAL_SENSORS; i++) {
        
        // All sensors should now now be registered
        XCTAssertFalse([self.sensingKit isSensorRegistered:i], @"Sensor shoud not be registered.");
    }
}

- (void)testSensorConfiguration
{
    // test set configuration without being registered
    SKBatteryStatusConfiguration *batteryConfiguration = [[SKBatteryStatusConfiguration alloc] init];
    XCTAssertFalse([self.sensingKit setConfiguration:batteryConfiguration toSensor:BatteryStatus error:NULL], @"Configuration should not be set as sensor is not registered.");
    
    // test set configuration
    XCTAssertTrue([self.sensingKit registerSensor:BatteryStatus error:NULL], @"Sensor should be registered succesfully.");
    XCTAssertTrue([self.sensingKit setConfiguration:batteryConfiguration toSensor:BatteryStatus error:NULL], @"Configuration should be set.");
    
    // test with wrong type of configuration
    SKAccelerometerConfiguration *accelerometerConfiguration = [[SKAccelerometerConfiguration alloc] init];
    XCTAssertFalse([self.sensingKit setConfiguration:accelerometerConfiguration toSensor:BatteryStatus error:NULL], @"Accelerometer configuration should not be set into a Battery sensor.");
    
    // deregister sensor
    XCTAssertTrue([self.sensingKit deregisterSensor:BatteryStatus error:NULL], @"Sensor should be deregistered sucessfully.");
    
    // Test SKEddystoneProximityConfiguration
    SKEddystoneProximityConfiguration *eddystoneConfiguration = [[SKEddystoneProximityConfiguration alloc] init];
    XCTAssertTrue([eddystoneConfiguration setNamespaceFilter:@"123456" error:NULL], @"Valid namespace should be allowed.");
    XCTAssertTrue([eddystoneConfiguration setNamespaceFilter:nil error:NULL], @"Nil namespace should be allowed.");
    XCTAssertTrue([eddystoneConfiguration setNamespaceFilter:@"" error:NULL], @"Empty namespace should be allowed.");
    XCTAssertFalse([eddystoneConfiguration setNamespaceFilter:@"zzzzzzz" error:NULL], @"Invalid namespace should not be allowed.");
}

@end
