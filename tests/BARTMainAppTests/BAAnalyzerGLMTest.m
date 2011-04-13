//
//  BAAnalyzerGLMTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/30/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAAnalyzerGLMTest.h"
#import "../../src/CLETUS/COSystemConfig.h"
#import "../../src/ARTIE/GLM/BAAnalyzerGLM.h"
#import "BAAnalyzerGLMReference.h"
#import "../../src/EDNA/EDDataElementVI.h"


@implementation BAAnalyzerGLMTest

-(void)setUp
{
	contrastVector = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], nil];
	srand(time(0));
}


-(void)testAnalyzeDataAkk
{

	COSystemConfig *config = [COSystemConfig getInstance];
	
	STAssertNil([config fillWithContentsOfEDLFile:@"../tests/BARTMainAppTests/ConfigTestDataset02.edl"], @"error while loading config");
	BADataElement *inputData = [[BADataElement alloc] initWithDataFile:@"../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" andSuffix:@"" andDialect:@"" ofImageType:IMAGE_FCTDATA];
	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	uint fwhm = 4;
	uint minval = 2000;
	BOOL swa = NO;
	uint sws = 40;
	uint nrTimesteps = 720;
	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
																	  andMinval:minval 
															 forSlidingAnalysis:swa 
																	   withSize:sws];
	
	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
	

	BADataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:nrTimesteps forContrastVector:contrastVector andWriteResultInto:nil];
	BADataElement* outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
	
	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d",
												s, t]);
				}
			}
			
			free(sliceAlg);
			free(sliceRef);
			
		
		}}
	
	
}

-(void)testAnalyzeDataAkkRandData
{
	
	COSystemConfig *config = [COSystemConfig getInstance];
	STAssertNil([config fillWithContentsOfEDLFile:@"../tests/BARTMainAppTests/ConfigTestDataset02.edl"], @"error while loading config");

	
	uint nrTimesteps = 39;
	uint tr = 1560;
	uint length = tr*nrTimesteps;
	NSString *strLength = [NSString stringWithFormat:@"%d", length];
	[config setProp:@"$TR" :[NSString stringWithFormat:@"%d", tr] ];
	[config setProp:@"$nrTimesteps" :[NSString stringWithFormat:@"%d", nrTimesteps] ];
	
	NSString* elemToReplaceKey = @"$gwDesign";
	NSXMLElement* elemDesign = [NSXMLElement elementWithName:@"gwDesignStruct"];
	
	
	NSUInteger nrTrialsInRegr1 = 7;
	NSXMLElement* elemRegressor1 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	NSXMLElement* tbrDesign = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"visual"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"parametricScaleFactor";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k+4)*1000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"2000"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign addChild:elemEvent];
	}
	[elemRegressor1 addChild:tbrDesign];
	[elemDesign addChild:elemRegressor1];
	
	
	/***reg 2**/
	NSUInteger nrTrialsInRegr2 = 17;
	NSXMLElement* elemRegressor2 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	
	NSXMLElement* tbrDesign2 = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg2"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"aud"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"parametricScaleFactor";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k)*3000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"2000"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign2 addChild:elemEvent];
	}
	[elemRegressor2 addChild:tbrDesign2];
	[elemDesign addChild:elemRegressor2];
	[config replaceProp:elemToReplaceKey withNode: elemDesign];	
	
	
	//TODO has to be added to edl
	// swa sws minval, fwhm
	uint fwhm = 4;
	uint minval = 2000;
	BOOL swa = NO;
	uint sws = 40;
	
	//randomized input data
	uint rows = 32;
	uint cols = 17;
	uint slices = 10;
	uint tsteps = 21;
	BARTImageSize *imSize = [[BARTImageSize alloc] initWithRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
	//BADataElement *inputData = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
//															   andRows:rows andCols:cols 
//															 andSlices:slices andTimesteps:tsteps];
	
	BADataElement *inputData = [[BADataElement alloc] initEmptyWithSize:imSize ofImageType:IMAGE_FCTDATA];

	for (uint t = 0; t < tsteps; t++){
		for (uint s = 0; s < slices; s++){
			for (uint c = 0; c < cols; c++){
				for (uint r = 0; r < rows; r++){
					float val = rand()%32000;
					[inputData setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
				}
			}
		}
	}
						
	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	
	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
																			  andMinval:minval 
																	 forSlidingAnalysis:swa 
																			   withSize:sws];
	
	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
	BADataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:nrTimesteps forContrastVector:contrastVector andWriteResultInto:nil];
	BADataElement* outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
	
	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d", s, t]);
				}
			}
			free(sliceAlg);
			free(sliceRef);
			
			
		}}
	
	
}

-(void)testAnalyzeDataAkkVFiles
{
	//
//	COSystemConfig *config = [COSystemConfig getInstance];
//	
//	STAssertNil([config fillWithContentsOfEDLFile:@"../tests/BARTMainAppTests/ConfigTestDataset02.edl"], @"error while loading config");
//	BADataElement *inputData = [[BADataElement alloc] initWithDatasetFile:@"../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" ofImageDataType:IMAGE_DATA_FLOAT];
//	BADataElement *inputDataRef = [[EDDataElementVI alloc] initWithFile:@"../tests/BARTMainAppTests/testfiles/TestDataset02-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
//	
//	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
//	
//	uint fwhm = 4;
//	uint minval = 2000;
//	BOOL swa = NO;
//	uint sws = 40;
//	uint nrTimesteps = 720;
//	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
//																			  andMinval:minval 
//																	 forSlidingAnalysis:swa 
//																			   withSize:sws];
//	
//	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
//	BADataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputRef = [glmReference anaylzeTheData:inputDataRef withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	
//	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
//	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
//	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
//	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
//	
//	
//	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
//		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
//			
//			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
//			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
//			float *pRef = sliceRef;
//			float *pAlg = sliceAlg;
//			float compAccuracy = 0.00001;
//			
//			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
//				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
//					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
//											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d",
//												s, t]);
//				}
//			}
//			
//			free(sliceAlg);
//			free(sliceRef);
//			
//			
//		}}
//	
	
}


-(void)testAnalyzeDataWithSlidingWindow{
	
	COSystemConfig *config = [COSystemConfig getInstance];
	STAssertNil([config fillWithContentsOfEDLFile:@"../tests/BARTMainAppTests/ConfigTestDataset02.edl"], @"error while loading config");
	
	uint nrTimesteps = 220;
	uint tr = 1500;
	uint length = tr*nrTimesteps;
	NSString *strLength = [NSString stringWithFormat:@"%d", length];
	[config setProp:@"$TR" :[NSString stringWithFormat:@"%d", tr] ];
	[config setProp:@"$nrTimesteps" :[NSString stringWithFormat:@"%d", nrTimesteps] ];
	
	NSString* elemToReplaceKey = @"$gwDesign";
	NSXMLElement* elemDesign = [NSXMLElement elementWithName:@"gwDesignStruct"];
	
	
	NSUInteger nrTrialsInRegr1 = 93;
	NSXMLElement* elemRegressor1 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	NSXMLElement* tbrDesign = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"visual"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"parametricScaleFactor";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k+4)*10000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"1200"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign addChild:elemEvent];
	}
	[elemRegressor1 addChild:tbrDesign];
	[elemDesign addChild:elemRegressor1];
	
	
	/***reg 2**/
	NSUInteger nrTrialsInRegr2 = 34;
	NSXMLElement* elemRegressor2 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	
	NSXMLElement* tbrDesign2 = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg2"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"aud"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"parametricScaleFactor";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k)*3000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"3420"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign2 addChild:elemEvent];
	}
	[elemRegressor2 addChild:tbrDesign2];
	[elemDesign addChild:elemRegressor2];
	[config replaceProp:elemToReplaceKey withNode: elemDesign];	
	
	
	//TODO has to be added to edl
	// swa sws minval, fwhm
	uint fwhm = 4;
	uint minval = 2000;
	BOOL swa = YES;
	uint sws = 40;
	
	//randomized input data
	uint rows = 22;
	uint cols = 7;
	uint slices = 32;
	uint tsteps = 220;
//	BADataElement *inputData = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
//															   andRows:rows andCols:cols 
//															 andSlices:slices andTimesteps:tsteps];
	BARTImageSize *imSize = [[BARTImageSize alloc] initWithRows:rows andCols:cols andSlices:slices andTimesteps:tsteps];
	BADataElement *inputData = [[BADataElement alloc] initEmptyWithSize:imSize ofImageType:IMAGE_FCTDATA];
	
	for (uint t = 0; t < tsteps; t++){
		for (uint s = 0; s < slices; s++){
			for (uint c = 0; c < cols; c++){
				for (uint r = 0; r < rows; r++){
					float val = rand()%32000;
					[inputData setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
				}
			}
		}
	}
	
	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	
	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
																			  andMinval:minval 
																	 forSlidingAnalysis:swa 
																			   withSize:sws];
	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
	
	//TODO: will be changed with config
	glmAlg.slidingWindowSize = sws;
	glmAlg.mSlidingWindowAnalysis = YES;
	glmAlg.mMinval = minval;
	
	
	uint slidingWinAtTimestep = sws;
	
	BADataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:slidingWinAtTimestep forContrastVector:contrastVector andWriteResultInto:nil];
	BADataElement* outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:slidingWinAtTimestep];
	
	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d", s, t]);
				}
			}
			free(sliceAlg);
			free(sliceRef);
			
			
		}}

	
	slidingWinAtTimestep = sws+67;
	
	outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:slidingWinAtTimestep forContrastVector:contrastVector andWriteResultInto:nil];
	outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:slidingWinAtTimestep];
	
	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d", s, t]);
				}
			}
			free(sliceAlg);
			free(sliceRef);
			
			
		}}
		
	slidingWinAtTimestep = nrTimesteps-1;
	
	outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign atCurrentTimestep:slidingWinAtTimestep forContrastVector:contrastVector andWriteResultInto:nil];
	outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:slidingWinAtTimestep];
	
	STAssertEquals([outputAlg getImageSize].columns,      [outputRef getImageSize].columns, @"output number cols differ");
	STAssertEquals([outputAlg getImageSize].rows,      [outputRef getImageSize].rows, @"output number rows differ");
	STAssertEquals([outputAlg getImageSize].timesteps, [outputRef getImageSize].timesteps, @"output number timesteps differ");
	STAssertEquals([outputAlg getImageSize].slices,    [outputRef getImageSize].slices, @"output number slices differ");
	
	
	for (uint t = 0; t < [outputAlg getImageSize].timesteps; t++){
		for (uint s = 0; s < [outputAlg getImageSize].slices; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg getImageSize].columns; c++){
				for (uint r = 0; r < [outputAlg getImageSize].rows; r++){
					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d", s, t]);
				}
			}
			free(sliceAlg);
			free(sliceRef);
			
			
		}}
	
	
	
}


-(void)testAnalyzeDataLimits
{
	
	//COSystemConfig *config = [COSystemConfig getInstance];
//	STAssertNil([config fillWithContentsOfEDLFile:@"../tests/BARTMainAppTests/ConfigTestDataset02.edl"], @"error while loading config");
//	
//	
//	uint nrTimesteps = 39;
//	uint tr = 1560;
//	uint length = tr*nrTimesteps;
//	NSString *strLength = [NSString stringWithFormat:@"%d", length];
//	[config setProp:@"$TR" :[NSString stringWithFormat:@"%d", tr] ];
//	[config setProp:@"$nrTimesteps" :[NSString stringWithFormat:@"%d", nrTimesteps] ];
//	
//	NSString* elemToReplaceKey = @"$gwDesign";
//	NSXMLElement* elemDesign = [NSXMLElement elementWithName:@"gwDesignStruct"];
//	
//	
//	NSUInteger nrTrialsInRegr1 = 7;
//	NSXMLElement* elemRegressor1 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
//	NSXMLElement* tbrDesign = [NSXMLElement elementWithName:@"tbrDesign"];
//	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
//	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
//	
//	
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg1"]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"visual"]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
//	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
//	
//	
//	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
//	{
//		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
//		NSString *stringTrialTime = @"time";
//		NSString *stringTrialDuration = @"duration";
//		NSString *stringTrialHeight = @"parametricScaleFactor";
//		
//		NSString *strTime = [NSString stringWithFormat:@"%d", (k+4)*1000];
//		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
//		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"1210"];
//		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
//		
//		[elemEvent addAttribute:attrTrialTime];
//		[elemEvent addAttribute:attrTrialDuration];
//		[elemEvent addAttribute:attrTrialHeight];
//		[tbrDesign addChild:elemEvent];
//	}
//	[elemRegressor1 addChild:tbrDesign];
//	[elemDesign addChild:elemRegressor1];
//	
//	
//	/***reg 2**/
//	NSUInteger nrTrialsInRegr2 = 17;
//	NSXMLElement* elemRegressor2 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
//	
//	NSXMLElement* tbrDesign2 = [NSXMLElement elementWithName:@"tbrDesign"];
//	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
//	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
//	
//	
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg2"]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"aud"]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
//	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
//	
//	
//	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
//	{
//		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
//		NSString *stringTrialTime = @"time";
//		NSString *stringTrialDuration = @"duration";
//		NSString *stringTrialHeight = @"parametricScaleFactor";
//		
//		NSString *strTime = [NSString stringWithFormat:@"%d", (k)*3000];
//		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
//		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"7540"];
//		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
//		
//		[elemEvent addAttribute:attrTrialTime];
//		[elemEvent addAttribute:attrTrialDuration];
//		[elemEvent addAttribute:attrTrialHeight];
//		[tbrDesign2 addChild:elemEvent];
//	}
//	[elemRegressor2 addChild:tbrDesign2];
//	[elemDesign addChild:elemRegressor2];
//	[config replaceProp:elemToReplaceKey withNode: elemDesign];	
//	
//	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
//	
//	uint rows = 52;
//	uint cols = 87;
//	uint slices = 10;
//	uint tsteps = 121;
//	
//	//just 1 timestep
////	BADataElement *inputData1TS = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
////															   andRows:rows andCols:cols 
////															 andSlices:slices andTimesteps:1];
//	BARTImageSize *imSize = [[BARTImageSize alloc] initWithRows:rows andCols:cols andSlices:slices andTimesteps:1];
//	BADataElement *inputData1TS = [[BADataElement alloc] initEmptyWithSize:imSize ofImageType:IMAGE_FCTDATA];
//	
//	for (uint t = 0; t < 1; t++){
//		for (uint s = 0; s < slices; s++){
//			for (uint c = 0; c < cols; c++){
//				for (uint r = 0; r < rows; r++){
//					float val = rand()%32000;
//					[inputData1TS setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
//				}}}}
//	
//	//just 1 row
//	//BADataElement *inputData1R = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
////																  andRows:1 andCols:cols 
////																andSlices:slices andTimesteps:slices];
//	BARTImageSize *imSize2 = [[BARTImageSize alloc] initWithRows:1 andCols:cols andSlices:slices andTimesteps:tsteps];
//	BADataElement *inputData1R = [[BADataElement alloc] initEmptyWithSize:imSize2 ofImageType:IMAGE_FCTDATA];
//
//	for (uint t = 0; t < tsteps; t++){
//		for (uint s = 0; s < slices; s++){
//			for (uint c = 0; c < cols; c++){
//				for (uint r = 0; r < 1; r++){
//					float val = rand()%32000;
//					[inputData1R setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
//				}}}}
//	
//	//just 1 column
//	//BADataElement *inputData1C = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
////																  andRows:rows andCols:1 
////																andSlices:slices andTimesteps:slices];
//	BARTImageSize *imSize3 = [[BARTImageSize alloc] initWithRows:rows andCols:1 andSlices:slices andTimesteps:tsteps];
//	BADataElement *inputData1C = [[BADataElement alloc] initEmptyWithSize:imSize3 ofImageType:IMAGE_FCTDATA];
//
//	for (uint t = 0; t < tsteps; t++){
//		for (uint s = 0; s < slices; s++){
//			for (uint c = 0; c < 1; c++){
//				for (uint r = 0; r < rows; r++){
//					float val = rand()%32000;
//					[inputData1C setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
//				}}}}
//	
//	//just 1 slice
//	//BADataElement *inputData1S = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
////																  andRows:rows andCols:cols 
////																andSlices:1 andTimesteps:1];
//	BARTImageSize *imSize4 = [[BARTImageSize alloc] initWithRows:rows andCols:cols andSlices:1 andTimesteps:tsteps];
//	BADataElement *inputData1S = [[BADataElement alloc] initEmptyWithSize:imSize4 ofImageType:IMAGE_FCTDATA];
//
//	for (uint t = 0; t < tsteps; t++){
//		for (uint s = 0; s < 1; s++){
//			for (uint c = 0; c < cols; c++){
//				for (uint r = 0; r < rows; r++){
//					float val = rand()%32000;
//					[inputData1S setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
//				}}}}
//	
//	
//		
//	
//	
//	
//	
//	
//	
//	//TODO has to be added to edl
//	// swa sws minval, fwhm
//	uint fwhm = 8;
//	uint minval = 1000;
//	BOOL swa = NO;
//	uint sws = 60;
//		
//	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
//																			  andMinval:minval 
//																	 forSlidingAnalysis:swa 
//																			   withSize:sws];
//	
//	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
//	
//	
//	BADataElement* outputAlg1TS = [glmAlg anaylzeTheData:inputData1TS withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputAlg1S = [glmAlg anaylzeTheData:inputData1S withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputAlg1R = [glmAlg anaylzeTheData:inputData1R withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputAlg1C = [glmAlg anaylzeTheData:inputData1C withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	
//	BADataElement* outputRef1TS = [glmReference anaylzeTheData:inputData1TS withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputRef1S = [glmReference anaylzeTheData:inputData1S withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputRef1R = [glmReference anaylzeTheData:inputData1R withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	BADataElement* outputRef1C = [glmReference anaylzeTheData:inputData1C withDesign:inputDesign andCurrentTimestep:nrTimesteps];
//	
//	STAssertEquals([outputAlg1TS getImageSize].columns,      [outputRef1TS getImageSize].columns, @"output number cols differ");
//	STAssertEquals([outputAlg1TS getImageSize].rows,      [outputRef1TS getImageSize].rows, @"output number rows differ");
//	STAssertEquals([outputAlg1TS getImageSize].timesteps, [outputRef1TS getImageSize].timesteps, @"output number timesteps differ");
//	STAssertEquals([outputAlg1TS getImageSize].slices,    [outputRef1TS getImageSize].slices, @"output number slices differ");
//	STAssertEquals([outputAlg1S getImageSize].columns,      [outputRef1S getImageSize].columns, @"output number cols differ");
//	STAssertEquals([outputAlg1S getImageSize].rows,      [outputRef1S getImageSize].rows, @"output number rows differ");
//	STAssertEquals([outputAlg1S getImageSize].timesteps, [outputRef1S getImageSize].timesteps, @"output number timesteps differ");
//	STAssertEquals([outputAlg1S getImageSize].slices,    [outputRef1S getImageSize].slices, @"output number slices differ");
//	STAssertEquals([outputAlg1R getImageSize].columns,      [outputRef1R getImageSize].columns, @"output number cols differ");
//	STAssertEquals([outputAlg1R getImageSize].rows,      [outputRef1R getImageSize].rows, @"output number rows differ");
//	STAssertEquals([outputAlg1R getImageSize].timesteps, [outputRef1R getImageSize].timesteps, @"output number timesteps differ");
//	STAssertEquals([outputAlg1R getImageSize].slices,    [outputRef1R getImageSize].slices, @"output number slices differ");
//	STAssertEquals([outputAlg1C getImageSize].columns,      [outputRef1C getImageSize].columns, @"output number cols differ");
//	STAssertEquals([outputAlg1C getImageSize].rows,      [outputRef1C getImageSize].rows, @"output number rows differ");
//	STAssertEquals([outputAlg1C getImageSize].timesteps, [outputRef1C getImageSize].timesteps, @"output number timesteps differ");
//	STAssertEquals([outputAlg1C getImageSize].slices,    [outputRef1C getImageSize].slices, @"output number slices differ");
//	
//	
//	
//	for (uint t = 0; t < [outputAlg1TS getImageSize].timesteps; t++){
//		for (uint s = 0; s < [outputAlg1TS getImageSize].slices; s++){
//			
//			float* sliceAlg1TS = [outputAlg1TS getSliceData:s atTimestep:t];
//			float* sliceRef1TS = [outputRef1TS getSliceData:s atTimestep:t];
//			float *pRef = sliceRef1TS;
//			float *pAlg = sliceAlg1TS;
//			float compAccuracy = 0.00001;
//			
//			for (uint c = 0; c < [outputAlg1TS getImageSize].columns; c++){
//				for (uint r = 0; r < [outputAlg1TS getImageSize].rows; r++){
//					STAssertEqualsWithAccuracy(*pRef++, *pAlg++, compAccuracy,
//											   [NSString stringWithFormat:@"ref and alg differ in slice %d and timestep %d", s, t]);
//				}
//			}
//			free(sliceAlg1TS);
//			free(sliceRef1TS);
//			
//			
//		}}
	
	
  //just 1 timestep
	
  //just 1 row
	
  //just 1 column
	
  //just 1 slice

	
  // sliding window size stupid
	
  // timestep as parameter bigger than contained timesteps
	
  // empty/invalid DataElement or DesignElement
}

@end
