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
#import "SKModelManager.h"

@interface SensingKitTests : XCTestCase

@end

@implementation SensingKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSensingKitLib
{
    SensingKitLib *sensingKit1 = [SensingKitLib sharedSensingKitLib];
    XCTAssertNotNil(sensingKit1, @"SensingKitLib cannot be nil");
    
    SensingKitLib *sensingKit2 = [SensingKitLib sharedSensingKitLib];
    XCTAssertNotNil(sensingKit2, @"SensingKitLib cannot be nil");
    
    XCTAssertEqual(sensingKit1, sensingKit2, @"Instances should be identical");
}

- (void)testSensingKitRecordingDetails
{
    SensingKitLib *sensingKit = [SensingKitLib sharedSensingKitLib];
    
    NSArray *recordings = [sensingKit getRecordings];
    XCTAssertNotNil(recordings, @"Array of RecordingDetails cannot be nil");
    
    XCTAssertEqual(recordings.count, 0, @"Size should be 0");
    
    // Recording 1
    SKRecording *recording1 = [sensingKit newRecording];
    XCTAssertNotNil(recording1, @"SKRecording cannot be nil");
    XCTAssertEqual(recordings.count, 1, @"Array size should increase");
    
    XCTAssertEqualObjects(recording1.recordingDetails.name, @"New Recording", @"Default name should be 'New Recording'");
    
    recording1.recordingDetails.name = @"Recording 1";
    XCTAssertEqualObjects(recording1.recordingDetails.name, @"Recording 1", @"Name should change to 'Recording 1'");
    
    SKRecordingDetails *recordingDetails1 = recordings[0];
    XCTAssertEqualObjects(recordingDetails1.name, @"Recording 1", @"Names should be identical");
    
    // Recording 2
    SKRecording *recording2 = [sensingKit newRecording];
    XCTAssertNotNil(recording2, @"SKRecording cannot be nil");
    XCTAssertEqual(recordings.count, 2, @"Array size should increase");
    recording2.recordingDetails.name = @"Recording 2";
    XCTAssertEqualObjects(recording2.recordingDetails.name, @"Recording 2", @"Name should change to 'Recording 2'");
    XCTAssertEqualObjects(recording1.recordingDetails.name, @"Recording 1", @"Name should change to 'Recording 1'");
    
    // Delete Recording 1
    [sensingKit deleteRecordingWithDetails:recordingDetails1];
    XCTAssertEqual(recordings.count, 1, @"Array size should decrease");
    
    [sensingKit saveContext];
}

- (void)testModelManager
{
    SKModelManager *modelManager1 = [SKModelManager sharedModelManager];
    XCTAssertNotNil(modelManager1, @"SKModelManager cannot be nil");
    
    SKModelManager *modelManager2 = [SKModelManager sharedModelManager];
    XCTAssertNotNil(modelManager2, @"SKModelManager cannot be nil");
    
    XCTAssertEqual(modelManager1, modelManager2, @"Instances should be identical");
}

@end
