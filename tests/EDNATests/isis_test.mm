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
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:10 andCols:10 andSlices:10 andTimesteps:1];
	
	[elem setVoxelValue:[NSNumber numberWithFloat:255.0] atRow:2 col:2 slice:2 timestep:0];
	float t = [elem getFloatVoxelValueAtRow:2 col:2 slice:2 timestep:0];
	NSArray *readVec1 = [[NSArray alloc] initWithObjects: [NSNumber numberWithFloat:23.0], [NSNumber numberWithFloat:23.0], [NSNumber numberWithFloat:23.0], [NSNumber numberWithFloat:23.0], nil ];
	[elem setImageProperty:PROPID_READVEC    withValue:readVec1];
	[elem setImageProperty:PROPID_PHASEVEC    withValue:readVec1];
	[elem setImageProperty:PROPID_SLICEVEC    withValue:readVec1];
	[elem setImageProperty:PROPID_VOXELSIZE    withValue:readVec1];
	[elem setImageProperty:PROPID_ORIGIN    withValue:readVec1];
	[elem setImageProperty:PROPID_PATIENT withValue:@"whatever name"];
	[elem setImageProperty:PROPID_NAME withValue:@"another name"];

	NSArray *emptyVec = [NSArray arrayWithObjects: nil ];
	[elem setImageProperty:PROPID_PHASEVEC    withValue:emptyVec];
	
	
	NSLog(@"%@", readVec1);
	NSLog(@"%@", [elem getImageProperty:PROPID_READVEC]);
	NSLog(@"%@", [elem getImageProperty:PROPID_PHASEVEC]);
	NSLog(@"%@", [elem getImageProperty:PROPID_SLICEVEC]);
	NSLog(@"%@", [elem getImageProperty:PROPID_ORIGIN]);
	NSLog(@"%@", [elem getImageProperty:PROPID_VOXELSIZE]);
	NSString *str1 = [elem getImageProperty:PROPID_NAME] ;
	NSString *str = [elem getImageProperty:PROPID_PATIENT] ;
	NSLog(@"%@", str );
	NSLog(@"%@", str1 );
	//[elem print];
	
	
	
	
	//NSLog([NSString stringWithFormat:@"float elem %.2f", t]);
	
	[elem WriteDataElementToFile:@"/tmp/test.nii"];
	
	[elem release];
	
	[pool drain];
}