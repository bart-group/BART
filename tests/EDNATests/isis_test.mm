//
//  isis_test.mm
//  BARTApplication
//
//  Created by Lydia Hellrung on 6/24/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test.h"
#import "/Users/Lydi/Development/isis/lib/CoreUtils/propmap.hpp"


@implementation isis_test

@end

int main(void)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	
	uint rows = 13;
	uint cols = 12;
	uint sl = 10;
	uint tsteps = 7;
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:rows andCols:cols andSlices:sl andTimesteps:tsteps	];
	for (uint t=0; t < tsteps; t++){
		for (uint s=0; s < sl; s++){
			for (uint c=0; c < cols; c++){
				for (uint r=0; r < rows; r++){
					[elem setVoxelValue:[NSNumber numberWithFloat:r+c+s+t] atRow:r col:c slice:s timestep:t];
				}}}}
	
	//normal case
	uint sliceGet = 3;
	uint tGet = 2;
	float *pSlice = [elem getSliceData:sliceGet	atTimestep:tGet ];
	float* pRun = pSlice;
	for (uint i = 0; i < rows; i++){
		for (uint j = 0; j < cols; j++){
			NSLog(@"%.2f", (float)*pRun++);
			NSLog(@"%.2f", (float)sliceGet+tGet+i+j);		}
	}
	free(pSlice);
	
	
	//[elem WriteDataElementToFile:@"/tmp/firstwrittentestfile.nii"];
	NSArray* propList = [NSArray arrayWithObjects:@"prop1", @"prop2", @"prop3", nil];
	[elem copyProps:propList fromDataElement:elem];
	
	[elem release];
	
	[pool drain];
}