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
#import "../EDNA/EDDataElementIsisRealTime.h"


@implementation BADataElement

@synthesize mImageType;
@synthesize mImageSize;
@synthesize justatest;


-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    //[self release];
    self = [super init];
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
    //[self release];
    self = [super init];
    self = [[EDDataElementVI alloc] initWithDataType:type andRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
    return self;
    
}

-(id)initWithDataFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType
{
	//[self release];
    self = [super init];
	NSFileManager *fm = [[NSFileManager alloc] init];
	if ( NO == [fm fileExistsAtPath:path]){
		NSLog(@"No file to load");
		return nil;
	}
	
    self = [[EDDataElementIsis alloc] initWithFile:path andSuffix:suffix andDialect:dialect ofImageType:iType];
    return self;
}

-(id)initEmptyWithSize:(BARTImageSize*)s  ofImageType:(enum ImageType)iType
{
	//[self release];
    self = [super init];
	
    self = [[EDDataElementIsis alloc] initEmptyWithSize:s ofImageType:(enum ImageType)iType];
    return self;
	
}

-(id)initForRealTimeTCPIPWithSize:(BARTImageSize*)s ofImageType:(enum ImageType)iType
{
	//[self release];
    self = [super init];
	
    self = [[EDDataElementIsisRealTime alloc] initEmptyWithSize:s ofImageType:(enum ImageType)iType];
    return self;
	
}

-(void)dealloc
{
    [super dealloc];
}

-(BARTImageSize*)getImageSize
{
	NSLog(@"%@", mImageSize);
	return mImageSize;
}

@end
