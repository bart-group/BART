/*
 *	BAHierarchyTree.m
 *	BARTApplication
 *	
 *	Created by Torsten Schlumm on 5/15/12.
 *	Copyright 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 */

#import "BAHierarchyTree.h"
#import "BASession.h"
#import "BAExperiment.h"



#pragma mark -
#pragma mark Constants
#pragma mark -
//**********************************************************************************************************
//
//	Constants
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Private Interface
#pragma mark -
//**********************************************************************************************************
//
//	Private Interface
//
//**********************************************************************************************************

#pragma mark -
#pragma mark Private Category
//**************************************************
//	Private Category
//**************************************************

@interface BAHierarchyTree()

// Make any initialization of your class.
- (id) initSingleton;

@end

#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**********************************************************************************************************
//
//	Public Interface
//
//**********************************************************************************************************

@implementation BAHierarchyTree

#pragma mark -
#pragma mark Properties
//**************************************************
//	Properties
//**************************************************

@synthesize rootElement;
@synthesize sharedTree=_default;

- (BAHierarchyTree*)getSharedTree
{
    return [BAHierarchyTree instance];
}

#pragma mark -
#pragma mark Constructors
//**************************************************
//	Constructors
//**************************************************

- (id) initSingleton
{
	if ((self = [super init]))
	{
		// Initialization code here.
        BAHierarchyElement* session = [[BASession alloc] initWithName:@"First Ever Session"];
        rootElement = session;
        
        BAHierarchyElement* experiment_01 = [[BAExperiment alloc] initWithName:@"First Ever Experiment"];
        BAHierarchyElement* experiment_02 = [[BAExperiment alloc] initWithName:@"Experiment 01"];
        BAHierarchyElement* experiment_03 = [[BAExperiment alloc] initWithName:@"Experiment 02"];
        
        [[session children] addObject:experiment_01];
        [[session children] addObject:experiment_02];
        [[session children] addObject:experiment_03];
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods
//**************************************************
//	Private Methods
//**************************************************

#pragma mark -
#pragma mark Self Public Methods
//**************************************************
//	Self Public Methods
//**************************************************

+ (BAHierarchyTree *) instance
{
	// Persistent instance.
	static BAHierarchyTree *_default = nil;
	
	// Small optimization to avoid wasting time after the
	// singleton being initialized.
	if (_default != nil)
	{
		return _default;
	}
	
#if __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ >= __MAC_10_6
	// Allocates once with Grand Central Dispatch (GCD) routine.
	// It's thread safe.
	static dispatch_once_t safer;
	dispatch_once(&safer, ^(void)
				  {
					  _default = [[BAHierarchyTree alloc] initSingleton];
				  });
#else
	// Allocates once using the old approach, it's slower.
	// It's thread safe.
	@synchronized([BAHierarchyTree class])
	{
		// The synchronized instruction will make sure,
		// that only one thread will access this point at a time.
		if (_default == nil)
		{
			_default = [[BAHierarchyTree alloc] initSingleton];
		}
	}
#endif
	return _default;
}

#pragma mark -
#pragma mark Override Public Methods
//**************************************************
//	Override Public Methods
//**************************************************

- (id) retain
{
	return self;
}

- (oneway void) release
{
	// Does nothing here.
}

- (id) autorelease
{
	return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}

@end