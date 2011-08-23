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

@implementation RORegistrationTest

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

-(void)testRegistration
{
    RORegistration* registration = [[RORegistration alloc] init];
    STAssertEquals(1, 1, @"foo");
    EDDataElement* dataElement = [registration align:nil withReference:nil];
    STAssertEquals((EDDataElement*) nil, dataElement, @"bar");
    [registration release];
}

@end
