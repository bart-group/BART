//
//  designtest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/4/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "designtest.h"

#import "CLETUS/COExperimentContext.h"
#import "../../tests/NEDTests/NEDesignElementReference.h"
#import "NED/NEDesignElementDyn.h"

@implementation designtest

@end


int main(void)
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	COSystemConfig *config = [[COExperimentContext getInstance] systemConfig];
//	//erDesignTest02_deriv1AllReg
//	//erDesignTest03_deriv1Reg1_3
//	//erDesignTest04_deriv2AllReg
//	//erDesignTest05_deriv2Reg2_4
//	
//	
	NSError *err = [config fillWithContentsOfEDLFile:@"../../../../tests/NEDTests/blockDesignTest02_parametric.edl"];
//	if (nil != err)
//		NSLog(@"%@", err);
//	
//	//!! File erzeugen
//	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
//	
//	NEDesignElementDyn *toTestDesign = [[NEDesignElementDyn alloc] initWithDynamicData];
//	
//	
//	
//	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
//		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
//			
//			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
//			NSNumber *toTestValue = [toTestDesign getValueFromExplanatoryVariable: ev atTimestep:t];
//			
//			NSLog(@"%d %d  %.4f %.4f", ev, t, [refValue floatValue], [toTestValue floatValue]);
//			
//			
//			
//		}}
//	
//	
//	[toTestDesign writeDesignFile:@"/tmp/testblockDesignTest02_parametric.v"];
//	[referenceDesign writeDesignFile:@"/tmp/referenceblockDesignTest02_parametric.v"];
    
    NEDesignElementDyn *designEl = [[NEDesignElementDyn alloc] init];
	
    NSLog(@"0 vs %u ", [designEl mNumberTimesteps]);
	[designEl setMNumberTimesteps: 896];
    NSLog(@"896 vs %u ", [designEl mNumberTimesteps]);
	
//	//TODO: what to do with stupid values, negative, large?!
//	[designEl setMNumberTimesteps: 12233344];
//	
//	
//	STAssertTrue([designEl mNumberTimesteps] == (unsigned int)(12233344), @"set value correct");
//	
//	STAssertTrue([designEl mNumberExplanatoryVariables] == 0, @"initial value explanatory variable is not null");
//	[designEl setMNumberExplanatoryVariables:123];
//	STAssertTrue([designEl mNumberExplanatoryVariables] == 123, @"set value explanatory variable is not correct");
//	
//	STAssertTrue([designEl mRepetitionTimeInMs] == 0, @"initial value repetition time variable is not null");
//	[designEl setMRepetitionTimeInMs:234];
//	STAssertTrue([designEl mRepetitionTimeInMs] == 234, @"set value repetition time variable is not correct");
//	
//	STAssertTrue([designEl mNumberRegressors] == 0, @"initial value regressors variable is not null");
//	[designEl setMNumberRegressors: 456];
//	STAssertTrue([designEl mNumberRegressors] == 456, @"set value regressors variable is not correct");
//	
//	STAssertTrue([designEl mNumberCovariates] == 0, @"initial value covariates variable is not null");
//	[designEl setMNumberCovariates: 456];
//	STAssertTrue([designEl mNumberCovariates] == 456, @"set value covariates variable is not correct");
//	[designEl release];


	[pool drain];

}