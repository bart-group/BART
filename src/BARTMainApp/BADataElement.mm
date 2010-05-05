//
//  BADataElement.m
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADataElement.h"
#import "BADataElementVI.h"
#import "../EDNA/EDDataElementIsis.h"


@implementation BADataElement

@synthesize numberRows;
@synthesize numberCols;
@synthesize numberSlices;
@synthesize numberTimesteps;
@synthesize imageDataType;
 

-(id)initWith:(NSArray*) aType
{
    if (self = [super init]) {
    
    }
    
    return self;
    //if (self)
        //return [[BADataElementVI alloc] init ];
}

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    [self release];
    self = nil;
    //TODO!!!!!!!
    self = [[EDDataElementIsis alloc] initWithFile:path ofImageDataType:type];
    return self;
}

//EIGENES SIZE-ELEMENT waere angebracht
-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps
{
    [self release];
    self = nil;
    self = [[BADataElementVI alloc] initWithDataType:type andRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
    return self;
    
}

-(void)dealloc
{
    [super dealloc];
}



@end
