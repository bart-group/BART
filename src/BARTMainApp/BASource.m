//
//  BASource.m
//  BARTCommandLine
//
//  Created by First Last on 10/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BASource.h"
#import "BASourceDatasetFile.h"


@implementation BASource



/**
 * Initialize with a file containing a part of an image dataset (e.g. the volume data from a single timestep).
 */

-(id)initWithDatasetPartFiles:(NSArray *) files
{
    [self release];
    self = nil;
    
    return self;
}


/**
 * Initialize with a file containing the complete set of image data.
 */
-(id)initWithDatasetFile:(NSString*) file ofImageType:(enum ImageType)type
{
    [self release];
    self = nil;
     
    return [[BASourceDatasetFile alloc] initWithDatasetFile:file ofImageType:type];
}


/**
 * Initialize with a pipe from a network connection.
 */
-(id)initWithPipe:(NSString*) pipeName
{
    self = [super init];
    
    return self;
}

-(BADataElement*)getData
{
    return [mElement retain];
}

@end