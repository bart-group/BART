//
//  RORegistrationTest.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistrationTest.h"

#import "RORegistration.h"
#import "EDDataElement.h"
#import "EDDataElementIsis.h"

@implementation RORegistrationTest

NSString* curDir    = @"";
NSString* fileName  = @"";
// /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
NSString* imageFile = @"TestDataset01-functional.nii";

-(void) setUp
{
	curDir = [[NSBundle bundleForClass:[self class] ] resourcePath];
    fileName = [NSString stringWithFormat:@"%@/%@", curDir, imageFile];
}

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

-(void)testRegistration
{
    EDDataElementIsis* functionalData = [[EDDataElementIsis alloc] initWithFile:fileName 
                                                                      andSuffix:@"" 
                                                                     andDialect:@"" 
                                                                    ofImageType:IMAGE_FCTDATA];
//    EDDataElementIsis* functionalData = nil;
    
    RORegistration* registration = [[RORegistration alloc] init];
    STAssertEquals(1, 1, @"foo");
    EDDataElement* dataElement = [registration align:functionalData 
                                       withReference:functionalData];
    
    STAssertEquals((EDDataElement*) nil, dataElement, @"bar");
    
    [registration release];
}

@end
