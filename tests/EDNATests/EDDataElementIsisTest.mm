//
//  EDDataElementIsisTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/19/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EDDataElementIsisTest.h"
#import "EDDataElementIsis.h"


@interface EDDataElementIsisTest (MemberVariables)

	EDDataElementIsis *dataEl;

@end

@implementation EDDataElementIsisTest


-(void) setUp
{
	unsigned int rows = 10;
	unsigned int cols = 21;
	unsigned int slices = 17;
	unsigned int timesteps = 29;
	
	dataEl = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:rows andCols:cols andSlices:slices andTimesteps:timesteps];
	//for (unsigned int x = 0; x < )
	//[dataEl setVoxelValue:<#(NSNumber *)val#> atRow:<#(int)r#> col:<#(int)c#> slice:<#(int)s#> timestep:<#(int)t#>]
	
	
	[dataEl WriteDataElementToFile:@""]
	
		dataEl = [[EDDataElementIsis alloc] initWithDatasetFile:@"../tests/BARTMainAppTests/testfiles/TestDataset01-functional.nii" ofImageDataType:IMAGE_DATA_SHORT];
}

-(void)testProperties
{
	STAssertEquals(dataEl.numberCols, 64, @"Incorrect number of columns.");
    STAssertEquals(dataEl.numberRows, 64, @"Incorrect number of rows.");
    STAssertEquals(dataEl.numberTimesteps, 396, @"Incorrect number of timesteps.");
    STAssertEquals(dataEl.numberSlices, 20, @"Incorrect number of slices.");
    STAssertEquals(dataEl.imageDataType, IMAGE_DATA_SHORT, @"Incorrect image data type.");
}

-(void)testInitWithDatatype
{
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:10 andCols:10 andSlices:10 andTimesteps:0];
	
	STAssertNotNil(elem, @"initWithDataType returns nil");
	
	//[elem setVoxelValue:[NSNumber numberWithFloat:2.0] atRow:2 col:2 slice:2 timestep:1];
	STAssertEquals([elem getFloatVoxelValueAtRow:2 col:3 slice:1 timestep:0], (float)0.0, @"set and get voxel value differs");
	
	[elem release];
}

-(void)testSetProperties
{

}
					
-(void)testGetSetVoxelValueAtRow
{
//	-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;
//	
//	-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;
//	-(void)setVoxelValue:(NSNumber*)val atRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

	
}


-(void)testGetSetImageProperty
{
	//-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value;
	
//	-(id)getImageProperty:(enum ImagePropertyID)key;
}

-(void)testGetDataFromSlice
{
//-(short*)getDataFromSlice:(int)sliceNr atTimestep:(uint)tstep;
}


-(void)testSliceIsZero
{
//	-(BOOL)sliceIsZero:(int)slice;

}


-(void)testWrite
//-(void)WriteDataElementToFile:(NSString*)path;









@end