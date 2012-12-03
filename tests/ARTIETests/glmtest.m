//
//  glmtest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 9/1/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "glmtest.h"

#import "CLETUS/COExperimentContext.h"
#import "ARTIE/ARAnalyzerGLM.h"
#import "ARAnalyzerGLMReference.h"
//#import "EDNA/EDDataElementVI.h"
	




int main()
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	COSystemConfig *config = [[COSystemConfig alloc] init];
	NSError *err = [config fillWithContentsOfEDLFile:@"../../tests/ARTIETests/ConfigTestDataset02.edl"];
	if (nil != err)
		NSLog(@"%@", err);
	
	
	EDDataElement *inputData = [[EDDataElement alloc] initWithDataFile:@"../../tests/ARTIETests/testfiles/TestDataset02-functional.nii" andSuffix:@"" andDialect:@"" ofImageType:IMAGE_FCTDATA];
	NEDesignElement *inputDesign = [[NEDesignElement alloc] initWithDynamicDataFromConfig:config];
	
	uint fwhm = 4;
	uint minval = 2000;
	BOOL swa = NO;
	uint sws = 40;
	uint nrTimesteps = 720;
	ARAnalyzerGLMReference *glmReference = [[ARAnalyzerGLMReference alloc] initWithFwhm:fwhm 
																			  andMinval:minval 
																	 forSlidingAnalysis:swa 
																			   withSize:sws];
	
	ARAnalyzerGLM *glmAlg = [[ARAnalyzerGLM alloc] init];
	NSArray* contrastVector = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:1.0],
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.0], nil];
	
 	EDDataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:nrTimesteps forContrastVector:contrastVector andWriteResultInto:nil];
	EDDataElement* outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
	
	NSLog(@"%ld %ld", [outputAlg getImageSize].columns,      [outputRef getImageSize].columns);
	NSLog(@"%ld %ld", [outputAlg getImageSize].rows,      [outputRef getImageSize].rows);
	NSLog(@"%ld %ld", [outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps);
	NSLog(@"%ld %ld", [outputAlg getImageSize].slices,    [outputRef getImageSize].slices);
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					NSLog(@"%.2f %.2f", *pRef++, *pAlg++);
				}
			}
			
			free(sliceAlg);
			free(sliceRef);
			
			
		}}
	
	[pool drain];

	
	
}

