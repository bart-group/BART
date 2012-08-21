//
//  NEDesignElementDynTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementDynTest.h"
#import "NED/NEDesignElementDyn.h"
#import "CLETUS/COExperimentContext.h"
#import "NEDesignElementReference.h"

@implementation NEDesignElementDynTest

NSString *curDir;

- (void) setUp {
    
	curDir = [[NSBundle bundleForClass:[self class] ] resourcePath];
	srand(time(NULL));
}

- (void) testProperties {
	
	NEDesignElement *designEl = [[NEDesignElement alloc] init];
	
    STAssertTrue([designEl numberTimesteps] == (unsigned int)(0), @"initial value timesteps in design not null");
	[designEl setNumberTimesteps: 896];
	STAssertTrue([designEl numberTimesteps] == (unsigned int)(896), @"set positive value not correctly ");
	
	//TODO: what to do with stupid values, negative, large?!
	[designEl setNumberTimesteps: 12233344];
	
	
	STAssertTrue([designEl numberTimesteps] == (unsigned int)(12233344), @"set value correct");
	
	STAssertTrue([designEl numberExplanatoryVariables] == 0, @"initial value explanatory variable is not null");
	[designEl setNumberExplanatoryVariables:123];
	STAssertTrue([designEl numberExplanatoryVariables] == 123, @"set value explanatory variable is not correct");
	
	STAssertTrue([designEl repetitionTimeMS] == 0, @"initial value repetition time variable is not null");
	[designEl setRepetitionTime:234];
	STAssertTrue([designEl repetitionTimeMS] == 234, @"set value repetition time variable is not correct");
	
	STAssertTrue([designEl numberRegressors] == 0, @"initial value regressors variable is not null");
	[designEl setNumberRegressors: 456];
	STAssertTrue([designEl numberRegressors] == 456, @"set value regressors variable is not correct");
	
	STAssertTrue([designEl numberCovariates] == 0, @"initial value covariates variable is not null");
	[designEl setNumberCovariates: 456];
	STAssertTrue([designEl numberCovariates] == 456, @"set value covariates variable is not correct");
	[designEl release];
}


-(void) testInitWithDynamic {
	
	//normal case: for this test file: timeBasedRegressorNEDTest.edl
	
     NSString *fileName = [NSString stringWithFormat:@"%@/timeBasedRegressorNEDTest.edl", curDir ];
    COSystemConfig *config = [[COSystemConfig alloc] init ];
  	[config fillWithContentsOfEDLFile:fileName];
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
		
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataFromConfig:config];
	STAssertEquals(designEl.mNumberCovariates, (NSUInteger)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (NSUInteger)(3), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (NSUInteger)100, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(NSUInteger) (3), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (NSUInteger) (1000), @"Incorrect repetition time.");
    STAssertTrue(nil != [designEl getValueFromExplanatoryVariable: 0 atTimestep: 5] , @"return value of initalized design must not be zero" );
	[designEl release];
	
	//config file not available	
	[config fillWithContentsOfEDLFile:@"/tmp/dunno.edl"];
	designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	STAssertEquals(designEl.mNumberCovariates, (NSUInteger)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (NSUInteger)(0), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (NSUInteger)0, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(NSUInteger) (0), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (NSUInteger) (0), @"Incorrect repetition time.");
    
	STAssertTrue(nil == [designEl getValueFromExplanatoryVariable: 23 atTimestep: 5], @"return value of uninitalized design must be zero" );
	STAssertTrue(nil == [designEl getValueFromExplanatoryVariable: 0 atTimestep: 0] , @"return value of uninitalized design must be zero" );
	
	
	[designEl release];
}

-(void) testCopy
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/timeBasedRegressorNEDTest.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];

	
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc]
                initWithDynamicDataFromConfig:config];
	
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

	[designEl updateDesign];

	
	
	NEDesignElementDyn *copyDesign = [designEl copy];
	
	// they have to be equal
	STAssertEquals(designEl.mNumberCovariates, copyDesign.mNumberCovariates, @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, copyDesign.mNumberRegressors, @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  copyDesign.mNumberTimesteps, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,copyDesign.mNumberExplanatoryVariables, @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, copyDesign.mRepetitionTimeInMs, @"Incorrect repetition time.");
    
	for (unsigned int i = 0; i < designEl.mNumberExplanatoryVariables; i++){
		for (unsigned int t = 0; t < designEl.mNumberTimesteps; t++)
		{
			
			STAssertEquals([[designEl getValueFromExplanatoryVariable: i atTimestep: t] floatValue], [[copyDesign getValueFromExplanatoryVariable: i atTimestep: t] floatValue], @"copied values not equal" );
		}
	}
	
	// but the copy does not contain the information to generate the design - so after generate on the copy everything should be zero
	[copyDesign updateDesign];
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
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/timeBasedRegressorNEDTest.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];

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
                initWithDynamicDataFromConfig:config];
	
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
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/blockDesignTest01.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
    NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
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
	COSystemConfig *config = [[COSystemConfig alloc] init ];
	NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest01.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
    NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
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



-(void)testDesignAllWithFirstDeriv
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest02_deriv1AllReg.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
  	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testDesignAllWithFirstDeriv: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
	
}

-(void)testDesignSomeWithFirstDeriv
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest03_deriv1Reg1_3.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
  	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testDesignSomeWithFirstDeriv: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
	
}


-(void)testDesignAllWithSecondDeriv
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest04_deriv2AllReg.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
 	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testDesignAllWithSecondDeriv: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
}

-(void)testDesignSomeWithSecondDeriv
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];;
    NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest05_deriv2Reg2_4.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
  	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testDesignSomeWithSecondDeriv: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
}



-(void)testParametricDesignER
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/erDesignTest06_parametric.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testParametricDesignER: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
	
}

-(void)testParametricDesignBlock
{
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/blockDesignTest02_parametric.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
   NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	float compAccuracy = 0.00001;
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertEqualsWithAccuracy([refValue floatValue], [toTestValue floatValue], compAccuracy,
									   [NSString stringWithFormat:@"testParametricDesignBlock: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	[referenceDesign release];
	
}


-(void)testLimits
{
	//TODO: ERROR MESSAGES
	
	//all zeros
	
	COSystemConfig *config = [[COSystemConfig alloc] init ];
    NSString *fileName = [NSString stringWithFormat:@"%@/allZeroRegressor.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
  	NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
			
	for (uint ev = 0; ev < [designEl numberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [designEl numberTimesteps]; t++){
			
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertNil(toTestValue, @"testLimits all Regressors Zero: Design Element not nil");
			STAssertEquals( [toTestValue floatValue], 0.0,
									   [NSString stringWithFormat:@"testLimits all Regressors Zero: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	
	//no regressors
    fileName = [NSString stringWithFormat:@"%@/noRegressor.edl", curDir ];
  	[config fillWithContentsOfEDLFile:fileName];
    designEl = [[NEDesignElementDyn alloc] initWithDynamicDataFromConfig:config];
	
	
	for (uint ev = 0; ev < [designEl numberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [designEl numberTimesteps]; t++){
			
			NSNumber *toTestValue = [designEl getValueFromExplanatoryVariable: ev atTimestep:t];
			STAssertNil(toTestValue, @"testLimits no Regressors: Design Element not nil");
			STAssertEquals( [toTestValue floatValue], 0.0,
						   [NSString stringWithFormat:@"testLimits no Regressors: reference and design in differ in ev %d and timestep %d", ev, t]);
		}}
	
	[designEl release];
	
}


-(void)testSetRegressorAndCovariate
{
	
	
}


@end
