//
//  BADesignElementDynTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "BADesignElementDynTest.h"
#import "BADesignElementDyn.h"

@interface BADesignElementDynTest (MemberVariables)
	BADesignElement *designEl;
@end


@implementation BADesignElementDynTest


- (void) setUp {
    designEl = [[BADesignElementDyn alloc] 
                initWithFile:@"../tests/BARTMainAppTests/testfiles/erDesignTest01.des" 
                ofImageDataType:IMAGE_DATA_FLOAT];
}

- (void) testProperties {
    STAssertEquals(designEl.numberTimesteps, 396, @"Incorrect number of timesteps.");
    STAssertEquals(designEl.numberExplanatoryVariables, 5, @"Incorrect number of covariates.");
    STAssertEquals(designEl.repetitionTimeInMs, 2000, @"Incorrect repetition time.");
    STAssertEquals(designEl.imageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
}


-(void) testInitWithDynamic {
	//[designEl release];
	designEl = [[BADesignElementDyn alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];

}

//-(void) test2{}

@end
