//
//  BADataElement.m
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADataElement.h"
#import "../EDNA/EDDataElementVI.h"
#import "../EDNA/EDDataElementIsis.h"


@implementation BADataElement

@synthesize imageType;
@synthesize imageSize;

 
-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    [self release];
    self = nil;
	NSFileManager *fm = [[NSFileManager alloc] init];
	if ( NO == [fm fileExistsAtPath:path]){
		NSLog(@"No file to load");
		return nil;
	}
    self = [[EDDataElementVI alloc] initWithFile:path ofImageDataType:type];
    return self;
}

//EIGENES SIZE-ELEMENT waere angebracht
-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps
{
    [self release];
    self = nil;
    self = [[EDDataElementVI alloc] initWithDataType:type andRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
    return self;
    
}

-(id)initWithDataFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType
{
	[self release];
    self = nil;
	NSFileManager *fm = [[NSFileManager alloc] init];
	if ( NO == [fm fileExistsAtPath:path]){
		NSLog(@"No file to load");
		return nil;
	}
    self = [[EDDataElementIsis alloc] initWithFile:path andSuffix:suffix andDialect:dialect ofImageType:iType];
    return self;
}

-(id)initEmptyWithSize:(ImageSize*)s  ofImageType:(enum ImageType)iType
{
	[self release];
    self = nil;
    self = [[EDDataElementIsis alloc] initEmptyWithSize:s ofImageType:(enum ImageType)iType];
    return self;
	
}



-(void)dealloc
{
    [super dealloc];
}



@end
