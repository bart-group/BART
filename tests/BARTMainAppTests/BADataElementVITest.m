//
//  BADataElementVITest.m
//  BARTApplication
//
//  Created by First Last on 12/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADataElementVITest.h"
#import "BADataElementVI.h"

@interface BADataElementVITest (MemberVariables)

BADataElement *dataEl;

@end

@implementation BADataElementVITest

- (void) setUp {
    dataEl = [[BADataElementVI alloc] 
              initWithFile:@"/Users/Lydi/Development/BR5T-functional.v" 
              ofImageDataType:IMAGE_DATA_SHORT];
}

- (void) testProperties {
    STAssertEquals(dataEl.numberCols, 64, @"Incorrect number of columns.");
    STAssertEquals(dataEl.numberRows, 64, @"Incorrect number of rows.");
    STAssertEquals(dataEl.numberTimesteps, 396, @"Incorrect number of timesteps.");
    STAssertEquals(dataEl.numberSlices, 20, @"Incorrect number of slices.");
    STAssertEquals(dataEl.imageDataType, IMAGE_DATA_SHORT, @"Incorrect image data type.");
}

- (void) tearDown {
}

@end
