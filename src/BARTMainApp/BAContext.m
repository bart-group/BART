//
//  BAContext.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/26/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAContext.h"

#import <dispatch/once.h>


@implementation BAContext

+ (id)sharedBAContext {
	static dispatch_once_t predicate;
	static BAContext *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (id) retain {
	return self;
}

- (oneway void) release {
	// Do nothing here.
}

- (id) autorelease {
	return self;
}

- (NSUInteger) retainCount {
    return INT32_MAX;
}

@end
