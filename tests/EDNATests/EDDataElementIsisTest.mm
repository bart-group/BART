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
	STAssertEquals(dataEl.numberCols, 64, @"Incorrect number of columns.");
    STAssertEquals(dataEl.numberRows, 64, @"Incorrect number of rows.");
    STAssertEquals(dataEl.numberTimesteps, 396, @"Incorrect number of timesteps.");
    STAssertEquals(dataEl.numberSlices, 20, @"Incorrect number of slices.");
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
//	-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;
//	
//	-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;
//	-(void)setVoxelValue:(NSNumber*)val atRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

	int nrRows = 37;
	int nrCols = 12;
	int nrSlices = 29;
	int nrTimesteps = 2;
	
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:nrRows andCols:nrCols andSlices:nrSlices andTimesteps:nrTimesteps];
	
	NSNumber *voxel1 = [NSNumber numberWithInt:12];
	NSNumber *voxel2 = [NSNumber numberWithFloat:1.6];
	NSNumber *voxel3 = [NSNumber numberWithShort:1223];
	NSNumber *voxel4 = [NSNumber numberWithDouble:1.12312];
		
	[elem setVoxelValue:voxel1 atRow:0 col:0 slice:0 timestep:0];
	[elem setVoxelValue:voxel1 atRow:1 col:1 slice:1 timestep:1];
	[elem setVoxelValue:voxel1 atRow:2 col:1 slice:1 timestep:1];
	[elem setVoxelValue:voxel1 atRow:3 col:1 slice:1 timestep:1];
	
	
	//insert at zero and max length
	[elem setVoxelValue:voxel1 atRow:0 col:0 slice:0 timestep:0];
	[elem setVoxelValue:voxel2 atRow:36 col:11 slice:28 timestep:1];
	
	//insert at nonpossible
	//[elem setVoxelValue:voxel2 atRow:-1 col:0 slice:0 timestep:0];
//	[elem setVoxelValue:voxel2 atRow:0 col:-1 slice:0 timestep:0];
//	[elem setVoxelValue:voxel2 atRow:0 col:0 slice:-1 timestep:0];
//	[elem setVoxelValue:voxel2 atRow:0 col:0 slice:0 timestep:-1];
//	[elem setVoxelValue:voxel2 atRow:nrRows col:11 slice:28 timestep:1];
//	[elem setVoxelValue:voxel2 atRow:0 col:nrCols slice:0 timestep:0];
//	[elem setVoxelValue:voxel1 atRow:0 col:0 slice:nrSlices timestep:0];
//	[elem setVoxelValue:voxel1 atRow:0 col:0 slice:0 timestep:nrTimesteps];
	
	
	
	[elem release];
	
	
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
{
}
//-(void)WriteDataElementToFile:(NSString*)path;









@end