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

#import "SheepDataManager.h"

@interface SheepDataManager(PrivateMethods)
@end

@implementation SheepDataManager

@synthesize coreDataFolder;
@synthesize coreDataFilename;
@synthesize externalRecordExtension;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize managedObjectModelName;

#pragma mark -
#pragma mark Init/Dealloc

static SheepDataManager *sharedSingleton;

+ (SheepDataManager *) sharedInstance
{	
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[SheepDataManager alloc] init];
		
            // The default folder will have the name of your Bundle and be in the user's application support library
            NSArray * bundleStringParts = [[[NSBundle bundleForClass:[self class]] bundleIdentifier] componentsSeparatedByString: @"."];
			int last = (int)[bundleStringParts count] - 1 ;
			NSString *targetString = [bundleStringParts objectAtIndex:last];
			sharedSingleton.coreDataFolder = targetString;
            
			sharedSingleton.coreDataFilename = CORE_DATA_FILENAME;
			sharedSingleton.managedObjectModelName = targetString;
		}
	}
	return sharedSingleton;
}

- (void) setTestMode:(NSString*) testedAppName
{
    NSString *targetString = testedAppName;
    sharedSingleton.coreDataFolder = targetString;
    
    sharedSingleton.coreDataFilename = @"test_data";
    sharedSingleton.managedObjectModelName = targetString;
}

#pragma mark -
#pragma mark Application dir / ext. records

/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This will be either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */
- (NSString *) applicationSupportDirectory // OS X
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:coreDataFolder];
}

// Returns the URL to the application's Documents directory. // IOS
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
/**
 Returns the external records directory for the application.
 This code uses a directory named like the current target for the content, 
 either in the ~/Library/Caches/Metadata/CoreData location or (if the
 former cannot be found), the system's temporary directory.
 */
- (NSString *) externalRecordsDirectory 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
	basePath = [basePath stringByAppendingPathComponent:@"Metadata/CoreData/"];
	basePath = [basePath stringByAppendingPathComponent:coreDataFolder];
	return basePath;
}

#pragma mark -
#pragma mark Core Data specific MOM/Store/Context

- (NSManagedObjectModel *) managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:managedObjectModelName ofType:@"momd"];

    if([path length] > 0)
    {
        NSURL *momURL = [NSURL fileURLWithPath:path];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    }
    else
    {
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator 
{
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
	
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) 
	{
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:No model to generate a store from", [self class]);
        return nil;
    }
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    #if TARGET_OS_IPHONE
    NSString *applicationSupportDirectory = [[self applicationDocumentsDirectory] path];
    #else
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    #endif
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) 
    {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
	
    NSString *externalRecordsDirectory = [self externalRecordsDirectory];
    if ( ![fileManager fileExistsAtPath:externalRecordsDirectory isDirectory:NULL] ) 
	{
        if (![fileManager createDirectoryAtPath:externalRecordsDirectory withIntermediateDirectories:YES attributes:nil error:&error]) 
		{
            NSLog(@"Error creating external records directory at %@ : %@",externalRecordsDirectory,error);
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create external records directory %@ : %@", externalRecordsDirectory,error]));
            NSLog(@"Error creating external records directory at %@ : %@",externalRecordsDirectory,error);
            return nil;
        };
    }
	
	if (YOUR_STORE_TYPE == NSSQLiteStoreType)
		coreDataFilename = [coreDataFilename stringByAppendingString:@".sqlite"];
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: coreDataFilename]];
    
    // set store options to enable spotlight indexing
    NSMutableDictionary *storeOptions = [NSMutableDictionary dictionary];

	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:YOUR_STORE_TYPE 
												  configuration:nil 
															URL:url 
														options:storeOptions 
														  error:&error]){
		NSLog(@"CoreDataManager Error: %@", error);
        persistentStoreCoordinator = nil;
        return nil;
    }    
	
    return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *) managedObjectContext 
{
    if (managedObjectContext) return managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) 
	{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        //[[NSApplication sharedApplication] presentError:error];
		NSLog(@"CoreDataManager Error: %@", error);
        return nil;
    }
     managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
	
    NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    [undoManager setLevelsOfUndo:999];
    [managedObjectContext setUndoManager:undoManager];
    [managedObjectContext setMergePolicy:NSOverwriteMergePolicy];
    return managedObjectContext;
}

- (NSManagedObjectContext *) newManagedObjectContext 
{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) 
	{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"OBJECTIVESHEEP" code:0001 userInfo:dict];
        //[[NSApplication sharedApplication] presentError:error];
		NSLog(@"CoreDataManager error: %@", error);
        return nil;
    }
    NSManagedObjectContext * newContext = [[NSManagedObjectContext alloc] init];
    [newContext setPersistentStoreCoordinator: coordinator];
    [newContext setMergePolicy:NSOverwriteMergePolicy];
	
    return newContext;
}
@end
