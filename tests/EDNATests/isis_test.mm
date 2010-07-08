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
	int nrRows = 64;
	int nrCols = 64;
	int nrSlices = 10;
	int nrTs = 10;
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:nrRows andCols:nrCols andSlices:nrSlices andTimesteps:nrTs];
	
	
	[elem setVoxelValue:[NSNumber numberWithFloat:255.0] atRow:2 col:2 slice:2 timestep:0];
	[elem setVoxelValue:[NSNumber numberWithFloat:255.0] atRow:0 col:0 slice:0 timestep:0];
	
	for (int r = 0; r < nrRows; r++){
		for (int c = 0; c < nrCols; c++){
			for (int  s = 0; s < nrSlices; s++){
				for (int t = 0; t < nrTs; t++){
					NSNumber *v = [NSNumber numberWithFloat:s*c + t];
					[elem setVoxelValue:v atRow:r col:c slice:s timestep:t];}}}}
	
	NSLog(@"Voxel value: %.2f", [elem getFloatVoxelValueAtRow:-1 col:0 slice:0 timestep:0]);
	
	//NSLog([NSString stringWithFormat:@"float elem %.2f", t]);
	
	[elem WriteDataElementToFile:@"/tmp/test.nii"];
//	
	[elem release];
	
	[pool drain];
}