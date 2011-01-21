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
#import "NEDesignElementReference.h"

@implementation NEDesignElementDynTest


- (void) setUp {
	
	srand(time(NULL));
}

- (void) testProperties {
	
	NEDesignElementDyn *designEl = [[BADesignElement alloc] init];
	
	STAssertTrue([designEl mNumberTimesteps] == 0, @"initial value timesteps in design not null");
	[designEl setMNumberTimesteps: 896];
	STAssertTrue([designEl mNumberTimesteps] == 896, @"set positive value not correctly");
	
	//TODO: what to do with stupid values, negative, large?!
	[designEl setMNumberTimesteps: 12233344];
	
	
	STAssertTrue([designEl mNumberTimesteps] == (unsigned int)(12233344), @"set value correct");
	
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
	[designEl release];
}


-(void) testInitWithDynamic {
	
	//normal case: for this test file: timeBasedRegressorNEDTest.edl
	COSystemConfig *config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"../tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
		
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	STAssertEquals(designEl.mNumberCovariates, (unsigned int)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (unsigned int)(3), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (unsigned int)100, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(unsigned int) (3), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (unsigned int) (1000), @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
	STAssertTrue(nil != [designEl getValueFromExplanatoryVariable: 0 atTimestep: 5] , @"return value of initalized design must not be zero" );
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
	STAssertTrue(nil == [designEl getValueFromExplanatoryVariable: 23 atTimestep: 5], @"return value of uninitalized design must be zero" );
	STAssertTrue(nil == [designEl getValueFromExplanatoryVariable: 0 atTimestep: 0] , @"return value of uninitalized design must be zero" );
	
	
	[designEl release];
}

-(void) testCopy
{
	COSystemConfig *config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"../tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
	
    NSUInteger nrTrialsInRegr1 = 18;
	
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 1, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",1, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",1, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d",rand()%500000]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :[NSString stringWithFormat:@"%d", rand()%40000]];
	}
	NSUInteger nrTrialsInRegr2 = 27;
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 2, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",2, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",2, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d",rand()%700000]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :[NSString stringWithFormat:@"%d", rand()%80000]];
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
			if ( i == designEl.mNumberExplanatoryVariables ){
				STAssertEquals((float)1.0, [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );}
			else{
				STAssertEquals((float)0.00, [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );}
		}
	}
	[designEl release];
}


-(void)testGenerateDesign
{
	COSystemConfig *config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"../tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"320"];
	
    NSUInteger nrTrialsInRegr1 = 18;
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 1, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",1, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",1, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d", rand()%800000]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :[NSString stringWithFormat:@"%d", rand()%212320]];
		

	}
	NSUInteger nrTrialsInRegr2 = 27;
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", 2, k+1];
		NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",2, k+1];
		NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",2, k+1];
		[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d", rand()%123420]];
		[config setProp:stringTrialHeight :@"1"];
		[config setProp:stringTrialDuration :[NSString stringWithFormat:@"%d", rand()%342540]];

	}
	
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"refrence and design differ in ev %d and timestep %d", ev, t]);
		}}
	
	
	[designEl release];
	[referenceDesign release];
	
}


-(void)testUsualBlockDesign
{
	//test with blockDesignTest01.edl
	COSystemConfig *config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"../tests/NEDTests/blockDesignTest01.edl"];
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testUsualBlockDesign: reference and design in differ in ev %d and timestep %d", ev, t]);
	}}
	
	[designEl release];
	[referenceDesign release];
}

-(void)testUsualERDesign
{
	//test with erDesignTest01.edl
	COSystemConfig *config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"../tests/NEDTests/erDesignTest01.edl"];
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testUsualBlockDesign: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
	
}



-(void)testUnsortedDesign
{
	
}

-(void)testDesignWithFirstDeriv
{
	
	
}


-(void)testDesignWithSecondDeriv
{
	
}




-(void)testParametricDesign
{

	
}

-(void)testLimits
{
	//no regressors
	
	//all zeros
	
	//all ones
	
	
}


-(void)testSetRegressorAndCovariate
{
	
	
}


@end
