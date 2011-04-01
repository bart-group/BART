//
//  BAElement.m
//  BARTCommandLine
//
//  Created by First Last on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BAElement.h"

@implementation BARTImageSize

@synthesize rows;
@synthesize columns;
@synthesize slices;
@synthesize timesteps;

-(id)init
{
	self = [super init];
	rows = 1;
	columns = 1;
	slices = 1;
	timesteps = 1;
	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	BARTImageSize *newImageSize = [[BARTImageSize allocWithZone: zone] init];
	newImageSize.rows = rows;
	NSLog(@"BARTImageSize: rows: %d", rows);
	newImageSize.columns = columns;
	newImageSize.slices = slices;
	newImageSize.timesteps = timesteps;
	
	return newImageSize;
}

@end

@implementation BAElement

-(id)copyWithZone:(NSZone *)zone
{
	return nil;
}


@end

