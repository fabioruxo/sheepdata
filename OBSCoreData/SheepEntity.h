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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SheepDataManager.h"

@interface SheepEntity : NSManagedObject
{}

#pragma mark -
#pragma mark Initialization
/**
	Initializes the Entity into a CoreData ManagedObjectContext.
    You should always init an OBSEntity this way!
 */
- (id) initEntity;

#pragma mark -
#pragma mark Unique Identifier
/**
    A unique Identifier could be useful
 */
+ (NSString*) uniqueID;

#pragma mark -
#pragma mark Save 
/**
	Saves the shared ManagedObjectContext's state from whichever OBSEntity
 */
+ (BOOL) saveContext;

#pragma mark -
#pragma mark Fetching
/**
	Convenience method for fetching a single entity by property/value. Use this only if you are sure a single entity will be returned.
	If more than one entity matches the property/value the first entity found will be returned.
 */
+ (id) fetchEntityWhereProperty:(NSString *)aProperty equalsValue:(id)aValue;

/**
	fetches a single entity with a given predicate. Use this only if you are sure a single entity will be returned.
	If more than one entity matches the property/value the first entity found will be returned.
 */
+ (id) fetchEntityWithPredicate:(NSPredicate*) aPredicate;

/**
	fetches all entities with a given entity description
 */
+ (NSArray*) fetchEntities;

/**
 fetches all entities with a given entity description in a given order
 */
+ (NSArray*) fetchEntitiesWithSortDescriptor:(NSSortDescriptor*)sortDescriptor;

/**
	Convenience method for fetching a list of entities by property/value.
 */
+ (NSArray*) fetchEntitiesWhereProperty:(NSString *)aProperty equalsValue:(id) aValue;

/**
	Convenience method for fetching a list of entities given a predicate
 */
+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate;

/**
	Convenience method for fetching a list of entities given a predicate and a sort descriptor
 */
+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptor:(NSSortDescriptor*) aSortDescriptor;

/**
 Convenience method for fetching a list of entities given a predicate and a sort descriptor
 */
+ (NSArray*) fetchEntitiesWithPredicate:(NSPredicate*) aPredicate andSortDescriptors:(NSArray*) sortDescriptors;

#pragma mark -
#pragma mark Deleting
/**
	removes the current entity
 */
- (void) deleteEntity;

/**
	removes an array of entities in one shot
 */
+ (void) deleteEntities: (NSArray*) entities;

#pragma mark -
#pragma mark Existence check
/**
	checks whether an entity with a given property/value already exists. Useful for entities with unique-like fields.
 */
+ (BOOL) checkIfEntityExistsWhereProperty:(NSString *)aProperty equalsValue:(id) aValue;

/**
 checks whether an entity with a given predicate already exists. Useful for entities with unique-like fields.
 */
+ (BOOL) checkIfEntityExistsWithPredicate:(NSPredicate*) aPredicate;

#pragma mark -
#pragma mark Max Value
/**
 * Fetches the entity with the max value for a given property
 */
+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key;

/**
 * Fetches the entity with the max value for a given property with a given predicate
 */
+ (id) fetchEntityWhithMaxValueForKey:(NSString*)key andPredicate:(NSPredicate*)predicate;

@end
