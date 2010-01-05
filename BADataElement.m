//
//  BADataElement.m
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADataElement.h"
#import "BADataElementVI.h"


@implementation BADataElement

@synthesize numberRows;
@synthesize numberCols;
@synthesize numberSlices;
@synthesize numberTimesteps;
@synthesize imageDataType;


-(id)initWith:(NSArray*) aType
{
    self = [super init];
    
    return self;
    //if (self)
        //return [[BADataElementVI alloc] init ];
}

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    self = [super init];
    //TODO!!!!!!!
    return [[BADataElementVI alloc] initWithFile:path ofImageDataType:type];
}

//EIGENES SIZE-ELEMENT waere angebracht
-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps
{
    if (( self = [super init])) {
        
    }
    return [[BADataElementVI alloc] initWithDataType:type andRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
    
}

-(void)dealloc
{
    
    [super dealloc];
    
}



@end
