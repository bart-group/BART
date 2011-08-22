//
//  isis_test.mm
//  BARTApplication
//
//  Created by Lydia Hellrung on 6/24/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test.h"
#import "EDDataElementIsisRealTime.h"
#import "EDNA/EDDataElementIsis.h"
#import "CoreUtils/common.hpp"



@implementation isis_test

@end

int main(void)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::util::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	
    
    BARTImageSize *imSize = [[BARTImageSize alloc] initWithRows:39 andCols:19 andSlices:2 andTimesteps:190];
	EDDataElementIsis *elem = [[EDDataElementIsis alloc] initEmptyWithSize:imSize ofImageType:IMAGE_UNKNOWN];
	BARTImageSize *imSizeDest = [[BARTImageSize alloc] initWithRows:19 andCols:29 andSlices:1 andTimesteps:90];
	EDDataElementIsis *elemDest = [[EDDataElementIsis alloc] initEmptyWithSize:imSizeDest ofImageType:IMAGE_UNKNOWN];
//	STAssertNotNil(elem, @"valid init returns nil");
//	STAssertNotNil(elemDest, @"valid init returns nil");
//	
	// get empty list
	NSArray *propListi = [NSArray arrayWithObjects:nil];
	//STAssertEquals([[elem getProps:propListi] count], (NSUInteger) 0, @"empty list for getProps not returning zero size dict");
	//STAssertNoThrow([elem setProps:nil], @"empty dict for setProps throws exception");
	
	//strings
	NSString *s1 = @"MyName is bunny";
	NSString *s2 = @"Subject";
    
	
	NSArray *propList = [NSArray arrayWithObjects:@"prop1",@"prop2", nil];
	NSDictionary *propDictSet = [NSDictionary dictionaryWithObjectsAndKeys:s1, @"prop1", s2, @"prop2", nil];
	[elem setProps:propDictSet];
	NSDictionary *propDictGet = [elem getProps:propList];
	for (NSString* str in [propDictGet allKeys]){
		NSLog(@"%@ %@\n",[propDictSet valueForKey:str], [propDictGet valueForKey:str]);
    }

//    
//    
//    BARTImageSize *imSize = [[BARTImageSize alloc] init];
//	imSize.rows = 13;
//	imSize.columns = 12;
//	imSize.slices = 10;
//	imSize.timesteps = 7;
//	EDDataElement *elem = [[EDDataElement alloc] initEmptyWithSize:imSize ofImageType:IMAGE_TMAP];
//	for (uint t=0; t < imSize.timesteps; t++){
//		for (uint s=0; s < imSize.slices; s++){
//			for (uint c=0; c < imSize.columns; c++){
//				for (uint r=0; r < imSize.rows; r++){
//					[elem setVoxelValue:[NSNumber numberWithFloat:r+c+s+t] atRow:r col:c slice:s timestep:t];
//				}}}}
//	
//	//normal case
//	uint sliceGet = 3;
//	uint tGet = 2;
//	float *pSlice = [elem getSliceData:sliceGet	atTimestep:tGet ];
//	float* pRun = pSlice;
//	for (uint i = 0; i < imSize.rows; i++){
//		for (uint j = 0; j < imSize.columns; j++){
//			NSLog(@"normal Slice value not as expected %.2f %.2f\n", (float)*pRun++, (float)sliceGet+tGet+i+j);
//		}
//	}
//	free(pSlice);
//	
//	//first slice
//	sliceGet = 0;
//	tGet = 6;
//	pSlice = [elem getSliceData:sliceGet atTimestep:tGet ];
//	pRun = pSlice;
//	for (uint i = 0; i < imSize.rows; i++){
//		for (uint j = 0; j < imSize.columns; j++){
//			NSLog(@"first Slice value not as expected %.2f %.2f\n", (float)*pRun++, (float)sliceGet+tGet+i+j);
//		}
//	}
//	free(pSlice);
//	
//	//last slice
//	sliceGet = 9;
//	tGet = 6;
//	pSlice = [elem getSliceData:sliceGet atTimestep:tGet ];
//	pRun = pSlice;
//	for (uint i = 0; i < imSize.rows; i++){
//		for (uint j = 0; j < imSize.columns; j++){
//			NSLog(@"first Slice value not as expected %.2f %.2f\n", (float)*pRun++, (float)sliceGet+tGet+i+j);
//		}
//	}
//	free(pSlice);
//    //		
////	//out of size
////	sliceGet = 10;
////	tGet = 1;
////	pSlice = [elem getSliceData:sliceGet atTimestep:tGet ];
////	STAssertEquals(pSlice, (float*)NULL, @"Slice pointer on slice out of size not returning NULL");
////	
////	sliceGet = 2;
////	tGet = 8;
////	pSlice = [elem getSliceData:sliceGet atTimestep:tGet ];
////	STAssertEquals(pSlice, (float*)NULL, @"Slice pointer on timestep out of size not returning NULL");
////    
    [elem release];
	[pool drain];
}