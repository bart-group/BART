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
	
	//dataEl = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:rows andCols:cols andSlices:slices andTimesteps:timesteps];
	//for (unsigned int x = 0; x < )
	//[dataEl setVoxelValue:<#(NSNumber *)val#> atRow:<#(int)r#> col:<#(int)c#> slice:<#(int)s#> timestep:<#(int)t#>]
	
	
	//[dataEl WriteDataElementToFile:@""];
	
		dataEl = [[EDDataElementIsis alloc] initWithDatasetFile:@"../tests/BARTMainAppTests/testfiles/TestDataset01-functional.nii" ofImageDataType:IMAGE_DATA_SHORT];
}

-(void)testProperties
{
	STAssertEquals(dataEl.numberCols, (unsigned int)64, @"Incorrect number of columns.");
    STAssertEquals(dataEl.numberRows, (unsigned int)64, @"Incorrect number of rows.");
    STAssertEquals(dataEl.numberTimesteps, (unsigned int)396, @"Incorrect number of timesteps.");
    STAssertEquals(dataEl.numberSlices, (unsigned int)20, @"Incorrect number of slices.");
    STAssertEquals(dataEl.imageDataType, IMAGE_DATA_SHORT, @"Incorrect image data type.");
}

-(void)testInitWithDatatype
{
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:10 andCols:10 andSlices:10 andTimesteps:1];
	
	STAssertNotNil(elem, @"initWithDataType returns nil");
	
	//[elem setVoxelValue:[NSNumber numberWithFloat:2.0] atRow:2 col:2 slice:2 timestep:1];
	STAssertEquals([elem getFloatVoxelValueAtRow:2 col:3 slice:1 timestep:0], (float)0.0, @"set and get voxel value differs");
	
	[elem release];
}

-(void)testImageProperties
{

	//PROPID_NAME,
//    PROPID_MODALITY,
//    PROPID_DF,
//    PROPID_PATIENT,
//    PROPID_VOXEL,
//    PROPID_REPTIME,
//    PROPID_TALAIRACH,
//    PROPID_FIXPOINT,
//    PROPID_CA,
//    PROPID_CP,
//    PROPID_EXTENT,
//    PROPID_BETA,
//	PROPID_READVEC,
//	PROPID_PHASEVEC,
//	PROPID_SLICEVEC,
//	PROPID_SEQNR,
//	PROPID_VOXELSIZE, 
//	PROPID_ORIGIN
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:39 andCols:19 andSlices:2 andTimesteps:190];
	STAssertNotNil(elem, @"valid init returns nil");
	
	
	NSString *nameProp = @"MyName is bunny";
	NSString *patientProp = @"Subject";
	
	NSArray *readVec = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.765], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:123.76], [NSNumber numberWithFloat:1], nil];
	NSArray *readVec1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.865], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:123.76], [NSNumber numberWithFloat:1], nil];

	NSArray *phaseVec = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.0], [NSNumber numberWithFloat:-123.986], [NSNumber numberWithFloat:78976.654], [NSNumber numberWithFloat:99.0], nil];
	NSArray *sliceVec = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0], nil];
	NSArray *voxelSize = [NSArray arrayWithObjects:[NSNumber numberWithInt:23], [NSNumber numberWithInt:23.6], [NSNumber numberWithInt:12], [NSNumber numberWithInt:1], nil];
	NSArray *indexOrigin = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-98.0], [NSNumber numberWithFloat:12.0], [NSNumber numberWithFloat:34.9875645], [NSNumber numberWithFloat:0.951], nil];
	
	
	
	[elem setImageProperty:PROPID_NAME withValue:nameProp];
	[elem setImageProperty:PROPID_PATIENT withValue:patientProp];
	[elem setImageProperty:PROPID_READVEC withValue:readVec];
	[elem setImageProperty:PROPID_PHASEVEC withValue:phaseVec];
	[elem setImageProperty:PROPID_SLICEVEC withValue:sliceVec];
	[elem setImageProperty:PROPID_VOXELSIZE withValue:voxelSize];
	[elem setImageProperty:PROPID_ORIGIN withValue:indexOrigin];
	
	STAssertEqualObjects( [elem getImageProperty:PROPID_NAME], nameProp, @"PROPID_NAME does not match expected string");
	STAssertEqualObjects( [elem getImageProperty:PROPID_PATIENT], patientProp, @"PROPID_PATIENT does not match expected string");
	
	
	NSString *nameProp2 = @"";
	NSString *patientProp2 = @"";
	[elem setImageProperty:PROPID_NAME withValue:nameProp2];
	[elem setImageProperty:PROPID_PATIENT withValue:patientProp2];
	STAssertEqualObjects( [elem getImageProperty:PROPID_PATIENT], patientProp2, @"PROPID_PATIENT  does not match expected ");
	STAssertEqualObjects( [elem getImageProperty:PROPID_NAME], nameProp2, @"PROPID_NAME does not match expected string");
	
	
	STAssertEqualObjects( [elem getImageProperty:PROPID_READVEC], readVec, @"PROPID_READVEC  does not match expected vector");
	STAssertEqualObjects( [elem getImageProperty:PROPID_PHASEVEC], phaseVec, @"PROPID_PHASEVEC does not match expected vector");
	STAssertEqualObjects( [elem getImageProperty:PROPID_SLICEVEC], sliceVec, @"PROPID_SLICEVEC does not match expected vector");
	STAssertEqualObjects( [elem getImageProperty:PROPID_VOXELSIZE], voxelSize, @"PROPID_VOXELSIZE  does not match expected vector");
	STAssertEqualObjects( [elem getImageProperty:PROPID_ORIGIN], indexOrigin, @"PROPID_ORIGIN does not match expected vector");
	
	
	NSArray *emptyVec = [NSArray arrayWithObjects: nil];
	NSArray *zeroVec = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], nil];
	NSArray *toolongVec = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.0], [NSNumber numberWithFloat:-123.986], [NSNumber numberWithFloat:78976.654], [NSNumber numberWithFloat:99.0], [NSNumber numberWithFloat:9.0], nil];
	

	//TODO!!!!!!
//	[elem setImageProperty:PROPID_PHASEVEC withValue:emptyVec];
//	[elem setImageProperty:PROPID_SLICEVEC withValue:toolongVec];
	
	
//	STAssertEqualObjects([elem getImageProperty:PROPID_PHASEVEC], zeroVec,  @"");
	
	
	[elem release];
	
}
					
-(void)testGetSetVoxelValueAtRow
{
	int nrRows = 37;
	int nrCols = 12;
	int nrSlices = 29;
	int nrTimesteps = 2;
	
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:nrRows andCols:nrCols andSlices:nrSlices andTimesteps:nrTimesteps];
	
	NSNumber *voxel1 = [NSNumber numberWithInt:12];
	NSNumber *voxel2 = [NSNumber numberWithFloat:1.6];
	NSNumber *voxel3 = [NSNumber numberWithShort:1223];
	NSNumber *voxel4 = [NSNumber numberWithDouble:1.12312];
		
	//insert at zero and max length
	STAssertNoThrow([elem setVoxelValue:voxel1 atRow:0 col:0 slice:0 timestep:0], @"setVoxelValue throws unexpected exception 1");
	STAssertNoThrow([elem setVoxelValue:voxel2 atRow:nrRows-1 col:7 slice:28 timestep:1], @"setVoxelValue throws unexpected exception 2");
	STAssertNoThrow([elem setVoxelValue:voxel4 atRow:0 col:nrCols-1 slice:0 timestep:0], @"setVoxelValue throws unexpected exception 3");
	STAssertNoThrow([elem setVoxelValue:voxel3 atRow:0 col:0 slice:nrSlices-1 timestep:0], @"setVoxelValue throws unexpected exception 4");
	STAssertNoThrow([elem setVoxelValue:voxel2 atRow:0 col:0 slice:0 timestep:nrTimesteps-1], @"setVoxelValue throws unexpected exception 5");
	STAssertNoThrow([elem setVoxelValue:voxel1 atRow:nrRows-1 col:nrCols-1 slice:nrSlices-1 timestep:nrTimesteps-1], @"setVoxelValue throws unexpected exception 6");
	
	//get from these ones
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:0 timestep:0], [voxel1 floatValue], @"getValue does not match expected one 1.");
	STAssertEquals([elem getFloatVoxelValueAtRow:nrRows-1 col:7 slice:28 timestep:1], [voxel2 floatValue], @"getValue does not match expected one 2.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:nrCols-1 slice:0 timestep:0], [voxel4 floatValue], @"getValue does not match expected one 3.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:nrSlices-1 timestep:0], [voxel3 floatValue], @"getValue does not match expected one 4.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:0 timestep:nrTimesteps-1 ], [voxel2 floatValue], @"getValue does not match expected one 5.");
	STAssertEquals([elem getFloatVoxelValueAtRow:nrRows-1 col:nrCols-1 slice:nrSlices-1 timestep:nrTimesteps-1], [voxel1 floatValue], @"getValue does not match expected one 6.");
	
	
	
	//insert at nonpossible - nothing happens
	STAssertNoThrow([elem setVoxelValue:voxel2 atRow:-1 col:0 slice:0 timestep:0], @"setVoxelValue throws unexpected exception 7");
	STAssertNoThrow([elem setVoxelValue:voxel3 atRow:0 col:-1 slice:0 timestep:0], @"setVoxelValue throws unexpected exception 8");
	STAssertNoThrow([elem setVoxelValue:voxel4 atRow:0 col:0 slice:-1 timestep:0], @"setVoxelValue throws unexpected exception 9");
	STAssertNoThrow([elem setVoxelValue:voxel2 atRow:0 col:0 slice:0 timestep:-1], @"setVoxelValue throws unexpected exception 10");
	STAssertNoThrow([elem setVoxelValue:voxel4 atRow:nrRows col:11 slice:28 timestep:1], @"setVoxelValue throws unexpected exception 11");
	STAssertNoThrow([elem setVoxelValue:voxel2 atRow:0 col:nrCols slice:0 timestep:0], @"setVoxelValue throws unexpected exception 12");
	STAssertNoThrow([elem setVoxelValue:voxel3 atRow:0 col:0 slice:nrSlices timestep:0], @"setVoxelValue throws unexpected exception 13");
	STAssertNoThrow([elem setVoxelValue:voxel1 atRow:0 col:0 slice:0 timestep:nrTimesteps], @"setVoxelValue throws unexpected exception 14");
	
	// get from these impossible ones - should return 0
	STAssertEquals([elem getFloatVoxelValueAtRow:-1 col:0 slice:0 timestep:0], float(0.0), @"getValue does not match expected one 7.");
	STAssertEquals([elem getFloatVoxelValueAtRow:nrRows col:11 slice:28 timestep:1], float(0.0), @"getValue does not match expected one 8.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:nrCols slice:0 timestep:0], float(0.0), @"getValue does not match expected one 9.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:nrSlices timestep:0], float(0.0), @"getValue does not match expected one 10.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:0 timestep:nrTimesteps ], float(0.0), @"getValue does not match expected one 11.");
	STAssertEquals([elem getFloatVoxelValueAtRow:nrRows col:nrCols slice:nrSlices timestep:nrTimesteps], float(0.0), @"getValue does not match expected one 12.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:-1 slice:0 timestep:0], float(0.0), @"getValue does not match expected one 13.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:-1 timestep:0], float(0.0), @"getValue does not match expected one 14.");
	STAssertEquals([elem getFloatVoxelValueAtRow:0 col:0 slice:0 timestep:-1], float(0.0), @"getValue does not match expected one 15.");
	
	
	
	
	[elem release];
	
	
}


-(void)testGetDataFromSlice
{

	
	//-(short*)getDataFromSlice:(int)sliceNr atTimestep:(uint)tstep;
}

-(float*)testGetTimeseriesDataAtRow
{	

}

-(void)testGetRowDataAt
{	
	uint rows = 50;
	uint cols = 50;
	uint sl = 20;
	uint tsteps = 10;
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:rows andCols:cols andSlices:sl andTimesteps:tsteps	];
	for (uint t=0; t < tsteps; t++){
		for (uint s=0; s < sl; s++){
			for (uint c=0; c < cols; c++){
				for (uint r=0; r < rows; r++){
					[elem setVoxelValue:[NSNumber numberWithFloat:r+c+s+t] atRow:r col:c slice:s timestep:t];
				}}}}

	//float *pRowOrig = static_cast<float_t *> malloc(sizeof(cols));
	//float *pRun = pRowOrig;
	float *pRow = static_cast<float_t *> (malloc(sizeof(cols)));
	float *pRun2 = pRow;
	
	
	uint rowGet = 10;
	uint sliceGet = 10;
	uint tGet = 2;
	//for (uint r=0; r < rowGet, r++){
//		*pRun = rowGet+sliceGet+tGet-3+r;
//		pRun++;
//	}
//	
	pRow = (float*)([elem getRowDataAt:10 atSlice:10 atTimestep:2]);
	for (uint r=0; r < rowGet; r++){
		STAssertEquals(*pRun2, static_cast<float_t> (rowGet+sliceGet+tGet-3+r), @"");
		pRun2++;
	}
	
	free(pRow);
	
	//testSetRowAt
	
}

-(void)testGetColDataAt
{	


}

-(void)testSetRowAt
{	

}

-(void)testSetColAt
{	

}




-(void)testSliceIsZero
{
//	-(BOOL)sliceIsZero:(int)slice;

}


-(void)testWrite
{
}
//-(void)WriteDataElementToFile:(NSString*)path;









@end