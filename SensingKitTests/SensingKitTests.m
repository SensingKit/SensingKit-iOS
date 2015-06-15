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

- (void)testSensingKitLib
{
    XCTAssertNotNil(self.sensingKit, @"SensingKitLib cannot be nil.");
    
    SensingKitLib *sensingKit2 = [SensingKitLib sharedSensingKitLib];
    XCTAssertNotNil(sensingKit2, @"SensingKitLib cannot be nil.");
    XCTAssertEqual(self.sensingKit, sensingKit2, @"Instances should be identical.");
    
    [self.sensingKit registerSensorModule:Battery];
    XCTAssertTrue([self.sensingKit isSensorModuleRegistered:Battery], @"SensorModule should be registered.");
    XCTAssertFalse([self.sensingKit isSensorModuleSensing:Battery], @"SensorModule should not be sensing.");
    
    // Subscribe a sensor data listener
    [self.sensingKit subscribeSensorDataListenerToSensor:Battery
                                             withHandler:^(SKSensorModuleType moduleType, SKSensorData *sensorData) {
                                                         // Do nothing
                                                     }];
    
    [self.sensingKit startContinuousSensingWithSensor:Battery];
    XCTAssertTrue([self.sensingKit isSensorModuleSensing:Battery], @"SensorModule should be sensing.");
    
    [self.sensingKit stopContinuousSensingWithSensor:Battery];
    XCTAssertFalse([self.sensingKit isSensorModuleSensing:Battery], @"SensorModule should not be sensing.");
    
    // Do not unsubscribe here.. (should be automated by deregisterSensorModule)
    [self.sensingKit deregisterSensorModule:Battery];
    XCTAssertFalse([self.sensingKit isSensorModuleRegistered:Battery], @"SensorModule should not be registered.");
}

@end
