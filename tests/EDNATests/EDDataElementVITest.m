//
//  EDDataElementTestVI.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 4/20/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EDDataElementVITest.h"
#import "EDDataElementVI.h"

@interface EDDataElementVITest (MemberVariables)

	EDDataElementVI *dataEl;

@end

@implementation EDDataElementVITest


- (void) setUp {
    dataEl = [[EDDataElementVI alloc] 
              initWithFile:@"../tests/BARTMainAppTests/testfiles/TestDataset01-functional.v" 
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
