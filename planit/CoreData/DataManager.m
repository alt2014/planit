	//
//  DataManager.m
//  planit
//
//  Created by Peter Phan on 6/1/14.
//  Copyright (c) 2014 Anh Truong. All rights reserved.
//

#import "DataManager.h"
#import "PITrip+Model.h"

@implementation DataManager

static UIManagedDocument *managedDocument;
static NSManagedObjectContext *managedObjectContext;

+ (NSManagedObjectContext*)getManagedObjectContext {
    return managedObjectContext;
}

- (void)documentIsReady:(void (^) (BOOL success, NSArray *trips))block success:(BOOL)success {
    if (success) {
        managedObjectContext = managedDocument.managedObjectContext;
        NSArray *trips = [PITrip fetchTripsInContext:managedObjectContext];
        if (!trips) {
            block(NO, nil);
        } else {
            block(success, trips);
        }
    } else {
        block(success, nil);
    }
}

- (void)loadTrips:(void (^) (BOOL success, NSArray *trips))block {
    if (!managedObjectContext) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *directory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *documentName = @"TripDoc";
        NSURL *url = [directory URLByAppendingPathComponent:documentName];
        managedDocument = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Check if file exists at path
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [managedDocument openWithCompletionHandler:^(BOOL success) {
                if (success && managedDocument.documentState == UIDocumentStateNormal) {
                    [self documentIsReady:block success:YES];
                } else {
                    [self documentIsReady:block success:NO];
                    NSLog(@"Couldn't open document at %@", url);
                }
            }];
        } else {
            // create file
            [managedDocument saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if (success && managedDocument.documentState == UIDocumentStateNormal) {
                    [self documentIsReady:block success:YES];
                } else {
                    [self documentIsReady:block success:NO];
                    NSLog(@"Couldn't create document at %@", url);
                }
            }];
        }
    }
}

+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

@end
