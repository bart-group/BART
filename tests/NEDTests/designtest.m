//
//  designtest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/4/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "designtest.h"

#import "../../src/CLETUS/COSystemConfig.h"
#import "../../tests/NEDTests/NEDesignElementReference.h"
#import "../../src/NED/NEDesignElementDyn.h"

@implementation designtest

@end


int main(void)
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	COSystemConfig *config = [COSystemConfig getInstance];
	//erDesignTest02_deriv1AllReg
	//erDesignTest03_deriv1Reg1_3
	//erDesignTest04_deriv2AllReg
	//erDesignTest05_deriv2Reg2_4
	
	
	NSError *err = [config fillWithContentsOfEDLFile:@"../../tests/NEDTests/erDesignTest02_deriv1AllReg.edl"];
	if (nil != err)
		NSLog(@"%@", err);
	
	//!! File erzeugen
	NEDesignElementReference *referenceDesign = [[NEDesignElementReference alloc] init];
	
	NEDesignElementDyn *toTestDesign = [[NEDesignElementDyn alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	
	
	for (uint ev = 0; ev < [referenceDesign mNumberExplanatoryVariables]; ev++){
		for (uint t = 0; t < [referenceDesign mNumberTimesteps]; t++){
			
			NSNumber *refValue = [referenceDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			NSNumber *toTestValue = [toTestDesign getValueFromExplanatoryVariable: ev atTimestep:t];
			
			NSLog(@"%d %d  %.4f %.4f", ev, t, [refValue floatValue], [toTestValue floatValue]);
			
			
			
		}}
	
	
	[toTestDesign writeDesignFile:@"/tmp/testDesignTest02_deriv1AllReg.v"];
	[referenceDesign writeDesignFile:@"/tmp/referenceDesignTest02_deriv1AllReg.v"];

	[pool drain];

}