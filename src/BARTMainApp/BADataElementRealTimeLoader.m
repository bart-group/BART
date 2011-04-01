//
//  BADataElementRealTimeLoader.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/25/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BADataElementRealTimeLoader.h"
#import "../EDNA/EDDataElementRealTimeLoader.h"


@implementation BADataElementRealTimeLoader


-(id)init
{
	//[self release];
	self = nil;
	self = [[EDDataElementRealTimeLoader alloc] init];
	return self;
}
@end
