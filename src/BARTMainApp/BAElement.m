//
//  BAElement.m
//  BARTCommandLine
//
//  Created by First Last on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BAElement.h"

/**************************************************
 BARTImageSize is a small class for better handling of the here mostly needed 4-value size
 **************************************************/

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

-(id)initWithRows:(size_t)r andCols:(size_t)c andSlices:(size_t)s andTimesteps:(size_t)t
{
    self = [super init];
	rows = r;
	columns = c;
	slices = s;
	timesteps = t;
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


/**************************************************
 BAElement is the base class of all elements (data, design, ...) and just implements basics
 **************************************************/
@implementation BAElement

-(id)copyWithZone:(NSZone *)zone
{
	return nil;
}


@end

