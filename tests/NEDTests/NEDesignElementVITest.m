//
//  NEDesignElementVITest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 12/17/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementVITest.h"
#import "NEDesignElementVI.h"


@interface NEDesignElementVITest (MemberVariables)



@end


@implementation NEDesignElementVITest

NEDesignElement *designEl;

- (void) setUp {
    designEl = [[NEDesignElementVI alloc] 
                initWithFile:@"../../../../tests/BARTMainAppTests/testfiles/TestDataset01-design.v" ];
}

- (void) testProperties {
    //STAssertEquals(designEl.mNumberTimesteps, 396, @"Incorrect number of timesteps.");
//	STAssertEquals(designEl.mNumberExplanatoryVariables, 5, @"Incorrect number of covariates.");
//    STAssertEquals(designEl.mRepetitionTimeInMs, 2000, @"Incorrect repetition time.");
    
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
