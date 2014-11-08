//
//  SKModel.m
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

#import "KKModel.h"
#import "GZIP.h"

@interface KKModel ()

@property (nonatomic, strong) NSMutableArray  *filenames;

@property (nonatomic) NSUInteger device_id;

@end


@implementation KKModel

- (id)init
{
    if (self = [super init])
    {
        // load filenames data from plist file
        [self loadDatabaseReferences];
    }
    return self;
}


- (void)addData:(NSData *)data withFilename:(NSString *)filename
{
    if (data.length)
    {
        // Compress the data
        data = [data gzippedData];
        
        // Save data
        if ([self saveData:data withFilename:filename])
        {
            // Add in the db
            [self addDatabaseReferenceWithFilename:filename date:[NSDate date]];
            //NSLog(@"Data saved succesfully to file '%@'.", filename);
        }
        else
        {
            // Error
            //NSLog(@"ERROR while saving the data to file '%@'.", filename);
        }
    }
    else
    {
        //NSLog(@"No need to save empty data to file '%@'.", filename);
    }
}

- (BOOL)saveData:(NSData *)data withFilename:(NSString *)filename
{
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:filename];
    
    return [data writeToFile:path atomically:YES];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)addDatabaseReferenceWithFilename:(NSString *)filename date:(NSDate *)date
{
    NSDictionary *dictionary = @{@"filename": filename,
                                 @"date": date};
    
    [self.filenames addObject:dictionary];
    [self saveDatabaseReferences];
}

- (void)loadDatabaseReferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.filenames = [[defaults objectForKey:@"DatabaseReferenses"] mutableCopy];
    
    if (!self.filenames)  // On first time
    {
        NSLog(@"DatabaseReference didn't exist. Creating a new one.");
        self.filenames = [[NSMutableArray alloc] initWithCapacity:10];
    }
    else
    {
        NSLog(@"Database with length: %lu", (unsigned long)self.filenames.count);
    }
}

- (void)saveDatabaseReferences
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.filenames forKey:@"DatabaseReferenses"];
    
    [defaults synchronize];
}

- (void)syncDataForDeviceWithId:(NSUInteger)device_id
{
    self.device_id = device_id;
    
    [self sendNext];
}

- (void)sendNext
{
    NSDictionary *entry = [self.filenames lastObject];
    
    if (entry)
    {
        NSString *filename = entry[@"filename"];
    
        NSData *data = [self getDataFromFilename:filename];
        
        if (data) {
            [self deleteFileWithInfo:entry];
        }
        else
        {
            NSLog(@"Error: Coulnd't find filename '%@'", filename);
            
            // In case file is missing..
            
            // Delete dict entry
            [self.filenames removeObject:entry];
            [self saveDatabaseReferences];
            
            // Continue
            [self sendNext];
        }
    }
    else
    {
        NSLog(@"No more data to sync.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Sent Complete"
                                                        message:@"Thank you for your participation."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}

- (NSData *)getDataFromFilename:(NSString *)filename
{
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:filename];
    
    return [NSData dataWithContentsOfFile:path];
}

- (void)deleteFileWithInfo:(NSDictionary *)filenameInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:filenameInfo[@"filename"]];
    
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:path error:&error];
    
    if (success)
    {
        // Delete dict entry
        [self.filenames removeObject:filenameInfo];
        [self saveDatabaseReferences];
    }
    else
    {
        NSLog(@"Could not delete file '%@'",[error localizedDescription]);
    }
    
    [self sendNext];
}

#pragma mark CommManagerDelegate

- (void)succeedWithFilenameInfo:(NSDictionary *)filenameInfo
{
    
}

@end
