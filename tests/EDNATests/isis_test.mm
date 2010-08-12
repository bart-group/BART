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
	uint rows = 99;
	uint cols = 31;
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
	//float *pRow = static_cast<float_t *> (malloc(sizeof(cols)));
	
	
	
	uint rowGet = 10;
	uint sliceGet = 10;
	uint tGet = 2;
	
	
	float *pRow = static_cast<float_t *>([elem getRowDataAt:rowGet atSlice:sliceGet atTimestep:tGet]);
	float *pRun2 = pRow;
	for (uint r=0; r < cols; r++){
		NSLog(@"%.2f\n", *pRun2);
		pRun2++;
	}
	
	free(pRow);
	[elem release];
	
	[pool drain];
}