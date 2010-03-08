//
//  COSystemConfigTest.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 Max-Planck-Gesellschaft. All rights reserved.
//

#import "COSystemConfigTest.h"
#import "COSystemConfig.h"


@interface COSystemConfigTest (PrivateStuff)

COSystemConfig* config;

@end



@implementation COSystemConfigTest

-(void)setUp
{
	config = [COSystemConfig getInstance];
    [config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
}

-(void)testInit
{
	NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Error(s) occured during initWithContentsOfEDLFile!"); 
}

-(void)testChallengeInitError
{
    NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"not_existing.foo"];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    [self setUp];
    
    STAssertEquals(NO, success, @"Expected reading error (XML_DOCUMENT_READ, file not existing)!");
}

-(void)testGetProp
{
    
    NSString* property = @"/rtExperiment/environment/resultImage/imageModalities/imgBase";
    NSString* value = [config getProp:property];
    
    NSString* expected = @"results_";
    
    STAssertEqualObjects(value, expected, @"Value %s does not match the expected %s!", [value cStringUsingEncoding:NSUTF8StringEncoding], [expected cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)testSetProp
{
    NSString* property = @"/rtExperiment/environment/resultImage/imageModalities/imgBase";
    NSString* value = @"foobar";
    
    [config setProp:property :value];
    
    NSString* actualValue = [config getProp:property];
    
    STAssertEqualObjects(actualValue, value, @"Value %s does not match the expected %s!", [actualValue cStringUsingEncoding:NSUTF8StringEncoding], [value cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)tearDown
{
}

@end
