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
              ofImageDataType:IMAGE_DATA_INT16];
}

- (void) testProperties {
	BARTImageSize *imSize = [dataEl mImageSize];
    STAssertEquals(imSize.columns, (size_t) 64, @"Incorrect number of columns.");
    STAssertEquals(imSize.rows, (size_t) 64, @"Incorrect number of rows.");
    STAssertEquals(imSize.timesteps, (size_t) 396, @"Incorrect number of timesteps.");
    STAssertEquals(imSize.slices, (size_t) 20, @"Incorrect number of slices.");
    STAssertEquals([dataEl getImageDataType], IMAGE_DATA_INT16, @"Incorrect image data type.");
}

- (void) tearDown {
}



@end
