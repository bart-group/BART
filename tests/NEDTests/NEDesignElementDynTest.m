//
//  BADesignElementDynTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementDynTest.h"
#import "../../src/NED/NEDesignElementDyn.h"
#import "../../src/CLETUS/COSystemConfig.h"

@interface NEDesignElementDynTest (MemberVariables)

	NEDesignElementDyn *designEl;
	COSystemConfig *config;
@end

@implementation NEDesignElementDynTest


- (void) setUp {
	config = [COSystemConfig getInstance];
	// TODO: remove output
	//FILE* fp = fopen("/tmp/nedTest.txt", "w");
//	fputc('\n', fp);
//	fputc('B', fp);
//	fputc(' ', fp);
//	fprintf(fp, "test: %d", designEl.mNumberRegressors);	 
//	fclose(fp);
	// END output
	
}

- (void) testProperties {
	[designEl release];
	designEl = [[BADesignElement alloc] init];
	
	STAssertTrue([designEl mNumberTimesteps] == 0, @"initial value timesteps in design not null");
	[designEl setMNumberTimesteps: 896];
	STAssertTrue([designEl mNumberTimesteps] == 896, @"set positive value not correctly");
	
	//TODO: what to do with stupid values, negative, large?!
	[designEl setMNumberTimesteps: 12233344422211233];
	
	
	STAssertTrue([designEl mNumberTimesteps] == (unsigned int)(12233344422211233), @"set value correct");
	
	STAssertTrue([designEl mNumberExplanatoryVariables] == 0, @"initial value explanatory variable is not null");
	[designEl setMNumberExplanatoryVariables:123];
	STAssertTrue([designEl mNumberExplanatoryVariables] == 123, @"set value explanatory variable is not correct");
	
	STAssertTrue([designEl mRepetitionTimeInMs] == 0, @"initial value repetition time variable is not null");
	[designEl setMRepetitionTimeInMs:234];
	STAssertTrue([designEl mRepetitionTimeInMs] == 234, @"set value repetition time variable is not correct");
	
	STAssertTrue([designEl mNumberRegressors] == 0, @"initial value regressors variable is not null");
	[designEl setMNumberRegressors: 456];
	STAssertTrue([designEl mNumberRegressors] == 456, @"set value regressors variable is not correct");
	
	STAssertTrue([designEl mNumberCovariates] == 0, @"initial value covariates variable is not null");
	[designEl setMNumberCovariates: 456];
	STAssertTrue([designEl mNumberCovariates] == 456, @"set value covariates variable is not correct");
}


-(void) testInitWithDynamic {
	
	//at the moment only values already available in edl-file can be set
	
	
	//normal case: for this test file: timeBasedRegressorNEDTest.edl
	[config fillWithContentsOfEDLFile:@"/Users/Lydi/Development/BARTProcedure/BARTApplication/trunk/tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
		
	designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	STAssertEquals(designEl.mNumberCovariates, (unsigned int)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (unsigned int)(3), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (unsigned int)100, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(unsigned int) (3), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (unsigned int) (1000), @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
	[designEl release];
	
	//config file not available	
	[config fillWithContentsOfEDLFile:@"/tmp/dunno.edl"];
	designEl = [[NEDesignElementDyn alloc] initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	STAssertEquals(designEl.mNumberCovariates, (unsigned int)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (unsigned int)(0), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (unsigned int)0, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(unsigned int) (0), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (unsigned int) (0), @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
}

-(void) testCopy
{
	[config fillWithContentsOfEDLFile:@"/Users/Lydi/Development/BARTProcedure/BARTApplication/trunk/tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
	
    NSUInteger nrTrialsInRegr1 = 18;
	
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 1, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",1, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",1, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d",(1) * 1000]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :@"20000"];
	}
	NSUInteger nrTrialsInRegr2 = 27;
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 2, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",2, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",2, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d",(2) * 1000]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :@"20000"];
	}

	[designEl generateDesign];

	
	
	NEDesignElementDyn *copyDesign = [designEl copy];
	
	// they have to be equal
	STAssertEquals(designEl.mNumberCovariates, copyDesign.mNumberCovariates, @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, copyDesign.mNumberRegressors, @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  copyDesign.mNumberTimesteps, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,copyDesign.mNumberExplanatoryVariables, @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, copyDesign.mRepetitionTimeInMs, @"Incorrect repetition time.");
    STAssertEquals(copyDesign.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
	FILE* fp = fopen("/tmp/nedTest.txt", "w");
	fputc('B', fp);
	fputc(' ', fp);
	
	for (unsigned int i = 0; i < designEl.mNumberExplanatoryVariables; i++){
		for (unsigned int t = 0; t < designEl.mNumberTimesteps; t++)
		{
			
			STAssertEquals([[designEl getValueFromExplanatoryVariable: i atTimestep: t] floatValue], [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );
		}
	}
	
	// but the copy does not contain the information to generate the design - so after generate on the copy everything should be zero
	[copyDesign generateDesign];
	for (unsigned int i = 0; i < designEl.mNumberExplanatoryVariables-1; i++){
		for (unsigned int t = 0; t < designEl.mNumberTimesteps; t++)
		{
			fprintf(fp, "%.2f\n", [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue]);	 
		
			if ( i == designEl.mNumberExplanatoryVariables ){
				STAssertEquals((float)1.0, [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );}
			else{
				STAssertEquals((float)0.00, [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );}
		}
	}
	fclose(fp);
	
	
}


-(void)testGenerateDesign
{
}

-(void)testWriteDesignFile
{

}

-(void)testGetValues
{

}


@end
