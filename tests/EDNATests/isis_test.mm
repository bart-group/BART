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
	
	
//	float *pRow = static_cast<float_t *>([elem getRowDataAt:rowGet atSlice:sliceGet atTimestep:tGet]);
//	float *pRun2 = pRow;
//	for (uint r=0; r < cols; r++){
//		NSLog(@"%.2f\n", *pRun2);
//		pRun2++;
//	}
//	NSLog(@"\n\n");
//	free(pRow);
//	

	
	uint colGet = 21;
//	
//	float *pCol = static_cast<float_t *>([elem getColDataAt:colGet atSlice:sliceGet atTimestep:tGet]);
//	float *pRun = pCol;
//	for (uint r=0; r < rows; r++){
//		NSLog(@"%.2f\n", *pRun);
//		pRun++;
//	}
//	free(pCol);
//	
//	uint colSet = 12;
//	float *dataBuff2 = static_cast<float_t*> (malloc(sizeof(rows)));
//	for (uint i = 0; i < rows; i++){
//		dataBuff2[i] = 11+i;
//	}
	
	//[elem setColAt:colSet atSlice:sliceGet atTimestep:tGet withData:dataBuff2];
//	
	//pCol = static_cast<float_t *>([elem getColDataAt:colSet atSlice:sliceGet atTimestep:tGet]);
//	float *pRun12 = pCol;
//	for (uint r=0; r < rows; r++){
//		float val = *pRun12++;
//		std::cout << val << "\n";
//	}
//	
	
	
	uint tstart = 0;
	uint tend = 9;
	float *pTimeSeries = static_cast<float_t *>([elem getTimeseriesDataAtRow:rowGet atCol:colGet atSlice:sliceGet fromTimestep:tstart toTimestep:tend]);
	float* pRun = pTimeSeries;
	for (uint t=0; t < tend-tstart+1; t++){
		NSLog(@"%.0f\n", *pRun++);
		NSLog(@"%.0f\n", (float)rowGet+sliceGet+colGet+tstart+t);
	}
	
	//free(pCol);
//	free(dataBuff);
	//free(dataBuff2);
	
	[elem release];
	
	[pool drain];
}