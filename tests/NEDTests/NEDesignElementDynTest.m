//
//  BADesignElementDynTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementDynTest.h"
#import "NEDesignElementDyn.h"

@interface NEDesignElementDynTest (MemberVariables)
	BADesignElement *designEl;
@end

@implementation NEDesignElementDynTest


- (void) setUp {
    designEl = [[NEDesignElementDyn alloc]
                initWithFile:@"../tests/BARTMainAppTests/testfiles/erDesignTest01.des" 
                ofImageDataType:IMAGE_DATA_FLOAT];
}

- (void) testProperties {
   // STAssertEquals(designEl.mNumberTimesteps, 396, @"Incorrect number of timesteps.");
//    STAssertEquals(designEl.mNumberExplanatoryVariables, 5, @"Incorrect number of covariates.");
//    STAssertEquals(designEl.mRepetitionTimeInMs, 2000, @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
}


-(void) testInitWithDynamic {
	//[designEl release];
	//designEl = [[BADesignElementDyn alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];

}

//-(void) test2{}

@end
