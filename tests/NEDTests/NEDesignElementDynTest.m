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

	BADesignElement *designEl;
	COSystemConfig *config;
@end

@implementation NEDesignElementDynTest


- (void) setUp {
	config = [COSystemConfig getInstance];
	[config fillWithContentsOfEDLFile:@"/Users/Lydi/Development/BARTProcedure/BARTApplication/trunk/tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	
}

- (void) testProperties {
	[designEl release];
	designEl = [[BADesignElement alloc] init];
	
	//STAssertEquals();
	//STAssertTrue 
	STAssertTrue([designEl mNumberTimesteps] == 0, @"initial value in design not null");
	[designEl setMNumberTimesteps: 896];
	STAssertTrue([designEl mNumberTimesteps] == 896, @"set positive value not correctly");
	[designEl setMNumberTimesteps: -896];
	
	FILE* fp = fopen("/tmp/nedTest.txt", "w");
	fputc('\n', fp);
	fputc('B', fp);
	fputc(' ', fp);
	fprintf(fp, "test: %d", designEl.mNumberTimesteps);	 
	fclose(fp);
	
	STAssertTrue([designEl mNumberTimesteps] == (-896), @"set value correct");
	
	
}


-(void) testInitWithDynamic {
	
	[config setProp:@"$nrTimesteps" :@"100"]; 
	[config setProp:@"$TR" :@"1000"];
	unsigned int numberEvents = 2;
	
    for (unsigned int i = 0; i < numberEvents; i++)
	{
		NSString *stringTrialsInReg = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent", i+1, i+1];
		NSUInteger nrTrialsInRegr = 10;
		
		for (unsigned int k = 0; k < nrTrialsInRegr; k++)
		{
			NSString *stringTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", i+1, k+1];
			NSString *stringTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration",i+1, k+1];
			NSString *stringTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@height",i+1, k+1];
			[config setProp:stringTrialTime :[NSString stringWithFormat:@"%d",(i+1) * 1000]];
			[config setProp:stringTrialHeight :@"1"];
			[config setProp:stringTrialDuration :@"20000"];
		}
	}
	
	
	designEl = [[BADesignElement alloc]
                initWithDynamicDataOfImageDataType: IMAGE_DATA_FLOAT];
	// TODO: remove output
	FILE* fp = fopen("/tmp/nedTest.txt", "w");
	fputc('\n', fp);
	fputc('B', fp);
	fputc(' ', fp);
	fprintf(fp, "test: %d", designEl.mNumberRegressors);	 
	fclose(fp);
	// END output
	
	STAssertEquals(designEl.mNumberCovariates, (unsigned int)(0), @"Incorrect number of covariates.");
	STAssertEquals(designEl.mNumberRegressors, (unsigned int)(3), @"Incorrect number of regressors.");
	STAssertEquals(designEl.mNumberTimesteps,  (unsigned int)100, @"Incorrect number of timesteps.");
	STAssertEquals(designEl.mNumberExplanatoryVariables,(unsigned int) (3), @"Incorrect number of explanatory variables.");
    STAssertEquals(designEl.mRepetitionTimeInMs, (unsigned int) (1000), @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
	
	
}

-(void) testCopy
{

}

-(void)testInitWithFile
{

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
