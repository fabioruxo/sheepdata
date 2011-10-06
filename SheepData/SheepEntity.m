/* *****************************************************************
 *                     ObjectiveSheep CoreData        
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

#import "SheepEntity.h"

@interface SheepEntity(Private)
void ShowError(NSString* action, NSError* error); 
@end

@implementation SheepEntity : NSManagedObject

#pragma mark -
#pragma mark Initialization
- (id) initEntity 
{
    self = [self initEntityInContext:[SheepDataManager sharedInstance].managedObjectContext];
    return self;
}

- (id) initEntityInContext:(NSManagedObjectContext*)aContext
{
    NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) 
											   inManagedObjectContext:aContext];
	self = [self initWithEntity:entity insertIntoManagedObjectContext:aContext];
	return self;
}

- (id) initNonEnitity
{
    NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) 
											   inManagedObjectContext:nil];
	self = [self initWithEntity:entity insertIntoManagedObjectContext:nil];
	return self;
}

#pragma mark -
#pragma mark Fetching
+ (id) fetchEntityWhereProperty:(NSString *)aProperty equalsValue:(id)aValue
{
    return [self fetchEntityWhereProperty:aProperty equalsValue:aValue inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (id) fetchEntityWhereProperty:(NSString *)aProperty equalsValue:(id)aValue inContext:(NSManagedObjectContext*) aContext
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %@", aProperty, aValue];
    return [self fetchEntityWithPredicate:predicate inContext:aContext];
}

+ (id) fetchEntityWithPredicate:(NSPredicate*) aPredicate
{
    return [self fetchEntityWithPredicate:aPredicate inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (id) fetchEntityWithPredicate:(NSPredicate*) aPredicate inContext:(NSManagedObjectContext*) aContext
{
    NSString *entityName = [[self class] description];
	
	NSEntityDescription * tmpEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:aContext];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:tmpEntity];
	[request setFetchLimit:1];
	[request setPredicate:aPredicate];
	
	NSError *error;
	NSArray *results = [aContext executeFetchRequest:request error:&error];
    [request release];
    
	if ([results count] > 0)
	{
		return [results objectAtIndex:0];
	}
    
	return nil;
}

+ (NSArray*) fetchEntities
{
	return [self fetchEntitiesWithSortDescriptor:nil];
}

+ (NSArray*) fetchEntitiesInContext:(NSManagedObjectContext*) aContext
{
    return [self fetchEntitiesWithSortDescriptor:nil inContext:aContext];
}

+ (NSArray*) fetchEntitiesWithSortDescriptor:(NSSortDescriptor*) sortDescriptor
{
    return [self fetchEntitiesWithSortDescriptor:sortDescriptor inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWithSortDescriptor:(NSSortDescriptor*) sortDescriptor inContext:(NSManagedObjectContext*)aContext
{
	NSString *entityName = [[self class] description];
	NSEntityDescription * tmpEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:aContext];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:tmpEntity];
    
    if (sortDescriptor) [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSError *error;
	NSArray *results = [aContext executeFetchRequest:request error:&error];
	[request release];
	
	return results;
}

+ (NSArray*) fetchEntitiesWhereProperty:(NSString *)aProperty equalsValue:(id) aValue
{
    return [self fetchEntitiesWhereProperty:aProperty equalsValue:aValue inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWhereProperty:(NSString *)aProperty equalsValue:(id) aValue inContext:(NSManagedObjectContext*) aContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"%K == %@", aProperty, aValue];
    return [self fetchEntitiesWithPredicate:predicate inContext:aContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate
{
	return [self fetchEntitiesWithPredicate:aPredicate inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate inContext:(NSManagedObjectContext*)aContext
{
    return [self fetchEntitiesWithPredicate:aPredicate andSortDescriptors:nil inContext:aContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptor:(NSSortDescriptor*) aSortDescriptor
{
    return [self fetchEntitiesWithPredicate: aPredicate andSortDescriptor:aSortDescriptor inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptor:(NSSortDescriptor*) aSortDescriptor inContext:(NSManagedObjectContext*)aContext
{
    return [self fetchEntitiesWithPredicate:aPredicate andSortDescriptors:[NSArray arrayWithObject:aSortDescriptor] inContext:aContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptors:(NSArray*) sortDescriptors
{
    return [self fetchEntitiesWithPredicate:aPredicate andSortDescriptors:sortDescriptors inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptors:(NSArray*) sortDescriptors inContext:(NSManagedObjectContext*) aContext
{
    return [self fetchEntitiesWithPredicate:aPredicate andSortDescriptors:sortDescriptors andLimit:0 inContext:aContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate *)aPredicate andSortDescriptors:(NSArray*) sortDescriptors andLimit:(NSInteger) aLimit
{
    return [self fetchEntitiesWithPredicate:aPredicate andSortDescriptors:sortDescriptors andLimit:aLimit inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate *)aPredicate andSortDescriptors:(NSArray*) sortDescriptors andLimit:(NSInteger) aLimit inContext:(NSManagedObjectContext*)aContext
{
    NSString *entityName = [[self class] description];
	NSEntityDescription * tmpEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:aContext];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:tmpEntity];
    if (aLimit >0) [request setFetchLimit:aLimit];
	
	[request setPredicate:aPredicate];
	if (sortDescriptors) [request setSortDescriptors:sortDescriptors];
	
	NSError *error;
	NSArray *results = [aContext executeFetchRequest:request error:&error];
    [request release];
	return results;	
}

#pragma mark -
#pragma mark Saving
+ (BOOL) saveContext
{
    return [self saveContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (BOOL) saveContext:(NSManagedObjectContext*) aContext
{
	NSError *saveErrorTask = nil;
	BOOL success = [aContext save:&saveErrorTask];
	if (!success) 
	{
		ShowError(@"Error in saveContext:", saveErrorTask);
	}
	return success;
}

#pragma mark -
#pragma mark Deleting
- (void) deleteEntity
{
	[self deleteEntityInContext:[SheepDataManager sharedInstance].managedObjectContext];
}

- (void) deleteEntityInContext:(NSManagedObjectContext*)aContext
{
    [aContext deleteObject:self];
}

+ (void) deleteEntities: (NSArray*) entities;
{
	[self deleteEntities:entities inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (void) deleteEntities: (NSArray*) entities inContext:(NSManagedObjectContext*) aContext
{
    for (id tmp in entities)
	{
		[aContext deleteObject:tmp];
	}
}

#pragma mark -
#pragma mark Unique ID generator
+ (NSString*) uniqueID;
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *newUUID = (NSString*) CFMakeCollectable(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return [newUUID autorelease];
}

#pragma mark -
#pragma mark Existence Check
+ (BOOL) checkIfEntityExistsWhereProperty:(NSString *)aProperty equalsValue:(id) aValue
{
	if([[self fetchEntitiesWhereProperty:aProperty equalsValue:aValue] count]>0) return true;
	else return false;
}

+ (BOOL) checkIfEntityExistsWhereProperty:(NSString *)aProperty equalsValue:(id) aValue inContext:(NSManagedObjectContext*)aContext
{
    if([[self fetchEntitiesWhereProperty:aProperty equalsValue:aValue inContext:aContext] count]>0) return true;
	else return false;
}

+ (BOOL) checkIfEntityExistsWithPredicate:(NSPredicate*) aPredicate
{
	if([[self fetchEntitiesWithPredicate:aPredicate] count]>0) return true;
	else return false;
}

+ (BOOL) checkIfEntityExistsWithPredicate:(NSPredicate*) aPredicate inContext:(NSManagedObjectContext*)aContext
{
	if([[self fetchEntitiesWithPredicate:aPredicate inContext:aContext] count]>0) return true;
	else return false;
}

#pragma mark -
#pragma mark Max Value
+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key
{
    return [self fetchEntityWhithMaxValueForKey:key andPredicate:nil inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key inContext:(NSManagedObjectContext*)aContext
{
    return [self fetchEntityWhithMaxValueForKey:key andPredicate:nil inContext:aContext];
}

+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key andPredicate:(NSPredicate*)predicate
{
    return [self fetchEntityWhithMaxValueForKey:key andPredicate:predicate inContext:[SheepDataManager sharedInstance].managedObjectContext];
}

+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key andPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)aContext
{
    NSString *entityName = [[self class] description];
	NSEntityDescription * tmpEntity = [NSEntityDescription entityForName:entityName inManagedObjectContext:aContext];	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:tmpEntity];
    if (predicate) [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [aContext executeFetchRequest:request error:&error];
    [request release];
    if (results == nil) 
    {
        ShowError(@"Error in fetchEntityWhithMaxValueForKey:andPredicate:\n", error);
    }
    return [results objectAtIndex:0];
}

#pragma mark -
#pragma mark Other
void ShowError(NSString* action, NSError* error)
{
    if (!error)
        return;
    
    NSLog(@"Failed to %@: %@", action, [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors && [detailedErrors count] > 0) 
	{
        for(NSError* detailedError in detailedErrors) 
		{
            NSLog(@"Detailed Error: %@", [detailedError userInfo]);
        }
    }
    else 
	{
        NSLog(@"%@", [error userInfo]);
    }
}
@end