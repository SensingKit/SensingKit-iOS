//
//  SKSensorDataBuffer.m
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

#import "KKSensorDataBuffer.h"

@interface KKSensorDataBuffer ()

@property (nonatomic, strong) NSMutableArray *buffer;
@property (nonatomic) NSUInteger capacity;

@end

@implementation KKSensorDataBuffer

- (id)initWithLabel:(NSString *)label withCapacity:(NSUInteger)capacity
{
    if (self = [super init])
    {
        _label = label;
        _capacity = capacity;
        
        [self initBuffer];
    }
    return self;
}

- (void)initBuffer
{
    self.buffer = [[NSMutableArray alloc] initWithCapacity:self.capacity];
}

- (void)addData:(id)data
{
    [self.buffer addObject:data];
}

- (void)flush
{
    // keep a pointer to the flushing buffer
    NSArray *buffer = self.buffer;
    
    // create new buffer
    [self initBuffer];
    
    // extract the data now
    NSData *data = [self extractDataFromBuffer:buffer];
    
    // call the delegate method
    [self.delegate flushedBuffer:self.label withData:data];
}

- (NSData *)extractDataFromBuffer:(NSArray *)buffer
{
    // Join all strings with new line as separator
    NSString *string = [buffer componentsJoinedByString:@"\n"];
    
    // ASCII should be enough for this kind of data. Use NSUTF8StringEncoding for unicode
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding];
    
    // return
    return data;
}

@end
