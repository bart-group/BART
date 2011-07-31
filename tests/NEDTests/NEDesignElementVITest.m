//
//  NEDesignElementVITest.m
//  BARTApplication
//
//  Created by First Last on 12/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NEDesignElementVITest.h"
#import "NEDesignElementVI.h"


@interface NEDesignElementVITest (MemberVariables)

NEDesignElement *designEl;

@end


@implementation NEDesignElementVITest

- (void) setUp {
    designEl = [[NEDesignElementVI alloc] 
                initWithFile:@"../tests/BARTMainAppTests/testfiles/TestDataset01-design.v" 
                ofImageDataType:IMAGE_DATA_FLOAT];
}

- (void) testProperties {
    //STAssertEquals(designEl.mNumberTimesteps, 396, @"Incorrect number of timesteps.");
//	STAssertEquals(designEl.mNumberExplanatoryVariables, 5, @"Incorrect number of covariates.");
//    STAssertEquals(designEl.mRepetitionTimeInMs, 2000, @"Incorrect repetition time.");
    STAssertEquals(designEl.mImageDataType, IMAGE_DATA_FLOAT, @"Incorrect image data type.");
}

/**
 * TODO: test (more) values from a self constructed image.
 */
- (void) testGetValueFromCovariate {
    unsigned int covariateNumber = 0;
    unsigned int timestep = 42;
    BOOL success = NO;
    float expectedMax = 1.53;
    float expectedMin = 1.529;
    float value = [[designEl getValueFromExplanatoryVariable:covariateNumber atTimestep:timestep] floatValue];
    
    if (value > expectedMin && value < expectedMax) {
        success = YES;
    }
    
    STAssertTrue(success, @"Incorrect value in covariate %d at timestep %d", covariateNumber, timestep);
}

- (void) tearDown {
    free(designEl);
}

@end
