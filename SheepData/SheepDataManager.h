/* *****************************************************************
 *                     SheepData        
 * -----------------------------------------------------------------
 
 Copyright (c) 2010, Fabio Russo
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of ObjectiveSheep CoreData nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL FABIO RUSSO BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 * ****************************************************************/

/*
 *   "The only way to make sense out of change is to plunge into it, move with it, and join the dance."
 *                                                                                   (Alan Watts)
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// DEFAULT IS SQL lite
#define YOUR_STORE_TYPE NSSQLiteStoreType // NSBinaryStoreType, NSXMLStoreType, NSSQLiteStoreType

// The Core data filename
#define CORE_DATA_FILENAME @"data" 

/**
 CoreData manager class. Encapsulates the persistence store as well as the managed object model and context in one singleton.
 Only to be used if a single context is shared throughout the whole application. 
 UPDATE: You can now use multiple contexts creating new ones (children) whenever you like. Use the main moc as parent.
 */
@interface SheepDataManager : NSObject 
{
	NSString *coreDataFolder;
	NSString *coreDataFilename;
	
	NSString *externalRecordExtension;
	NSString * managedObjectModelName;
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *secondaryObjectContext;
@property (strong, readwrite) NSString *coreDataFolder;
@property (strong, readwrite) NSString *coreDataFilename;
@property (strong, readwrite) NSString *externalRecordExtension;
@property (strong, readwrite) NSString *managedObjectModelName;

/**
 * If nothing is done some assumptions are made:
 * 1) the name of your coredata folder will be the name of your current target
 * 2) the name of your coredata model (if in test mode) will be the name of your current target
 * 3) the name of your coredata file will simply be "data.sqlite" if sqlite store is used or otherwise just "data"
 */
+ (SheepDataManager *)sharedInstance;

/*
 Used to create a test sqlite db.
 */
- (void) setTestMode:(NSString*)testedAppName;

/*
 To create a child context from managedObjectContext (secondary thread operations)
 */
- (NSManagedObjectContext *) newManagedObjectContext;

@end
