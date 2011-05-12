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

#import <SenTestingKit/SenTestingKit.h>
#import "TestEntities.h"
#import "Fixtures.h"
#import "Child.h"

@interface SheepDataTest : SenTestCase {} @end

@implementation SheepDataTest

- (void) setUp
{
	// Precreate some data
	// Father1 and Mother1 with Child1..Child4
	// Father2 and Mother2 with Child5
	[[Fixtures sharedInstance] resetData];
}

- (void) testFetching
{
	//fetch all Fathers
	NSArray* fathers = [Father fetchEntities];
	STAssertTrue([fathers count] == 2, @"Should have been two fathers");
	
	// fetch entities with predicate
	NSPredicate * p = [NSPredicate predicateWithFormat:@"name == %@", @"Child1"]; 
	NSArray * children = [Child fetchEntitiesWithPredicate:p];
	STAssertTrue ([children count] == 1, @"Should have found only one child with name:child1");
	
	// fetch single entity with predicate
	Child *c = [Child fetchEntityWhereProperty:@"name" equalsValue:@"Child1"];
	STAssertTrue(c != nil, @"Should have been fetched!");
	NSLog(@"Child: %@", c);
}

- (void) testExistenceChecks
{
	BOOL exists = [Child checkIfEntityExistsWhereProperty:@"name" equalsValue:@"Child1"];
	STAssertTrue (exists, @"Failed.... should have been true");
}

- (void) testEntityClassName
{
	[Child fetchEntityWhereProperty:@"name" equalsValue:@"Child1"];
}

- (void) testDeleteEntities
{
	NSArray* children = [Child fetchEntities];
	[Child deleteEntities:children];
	[Child saveContext];
	
	children = [Child fetchEntities];

	STAssertTrue([children count] == 0, @"Should have been 0 by now...");
}

@end
