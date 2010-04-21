//
//  COSystemConfigTest.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/2/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
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
    [config fillWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
}

-(void)testInit
{
    BOOL success = NO;
	NSError* err = nil;
	err = [config fillWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
        
    if (err == nil) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Error(s) occured during fillWithContentsOfEDLFile!"); 
}

-(void)testGetEDLFilePath
{
    NSString* edlFilePath = [config getEDLFilePath];
    NSString* expectedEDLFilePath = @"../tests/CLETUSTests/Init_Links_1.edl";
    
    STAssertEqualObjects(edlFilePath, expectedEDLFilePath, @"EDL file path %@ does not match the expected %@", 
                         [edlFilePath cStringUsingEncoding:NSUTF8StringEncoding], 
                         [expectedEDLFilePath cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)testWriteToFile
{
    NSError* err = nil;
    err = [config writeToFile:@"/tmp/cletusTestCaseWrite.edl"];
    
    BOOL success = NO;
    if (!err) {
        success = YES;
    }
    
    err = [config writeToFile:@".-.-.-.-.-.-.blub"];
    
    if (err) {
        success = success && YES;
    }
    
    STAssertEquals(YES, success, @"Method writeToFile does not work properly!");
}

-(void)testChallengeInitError
{
    NSError* err = nil;
	err = [config fillWithContentsOfEDLFile:@"not_existing.foo"];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    [self setUp];
    
    STAssertEquals(NO, success, @"Expected reading error (XML_DOCUMENT_READ, file not existing)!");
}

-(void)testGetProp
{
    
    NSString* propertyElem = @"/rtExperiment/environment/resultImage/imageModalities/imgBase";
    NSString* valueElem = [config getProp:propertyElem];
    NSString* propertyAttr = @"/rtExperiment/environment/resultImage/imageModalities/@imgDataExtension";
    NSString* valueAttr = [config getProp:propertyAttr];
    NSString* propertyAbbr = @"$TR";
    NSString* valueAbbr = [config getProp:propertyAbbr];
    
    NSString* expectedElemValue = @"results_";
    NSString* expectedAttrValue = @".hdr";
    NSString* expectedAbbrValue = @"2000";
    
    STAssertEqualObjects(valueElem, expectedElemValue, @"Value %s does not match the expected %s!", 
                         [valueElem cStringUsingEncoding:NSUTF8StringEncoding], 
                         [expectedElemValue cStringUsingEncoding:NSUTF8StringEncoding]);
    STAssertEqualObjects(valueAttr, expectedAttrValue, @"Value %s does not match the expected %s!", 
                         [valueAttr cStringUsingEncoding:NSUTF8StringEncoding], 
                         [expectedAttrValue cStringUsingEncoding:NSUTF8StringEncoding]);
    STAssertEqualObjects(valueAbbr, expectedAbbrValue, @"Value %s does not match the expected %s!", 
                         [valueAbbr cStringUsingEncoding:NSUTF8StringEncoding], 
                         [expectedAbbrValue cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)testCountNodes
{
	NSString* query = @"/rtExperiment/experimentData/paradigm/gwDesignStruct/scanBasedRegressor/sbrDesign/scan";
	NSUInteger numberOfNodes = [config countNodes:query];
    NSString* queryWithAbbr = @"$gwDesign/scanBasedRegressor/sbrDesign/scan";
    NSUInteger numberOfNodesWithAbbr = [config countNodes:queryWithAbbr];
    
    NSUInteger expected = 12;
	
	STAssertEquals(expected, numberOfNodes, @"NumberOfNodes not as expected.");
   	STAssertEquals(expected, numberOfNodesWithAbbr, @"NumberOfNodesWithAbbr not as expected.");
}

-(void)testSetProp
{
    NSString* propertyElem = @"/rtExperiment/environment/resultImage/imageModalities/imgBase";
    NSString* valueElem = @"foobar";
    NSString* propertyAttr = @"/rtExperiment/environment/resultImage/imageModalities/@imgDataExtension";
    NSString* valueAttr = @"foobaz";
    
    [config setProp:propertyElem :valueElem];
    [config setProp:propertyAttr :valueAttr];
    
    NSString* actualElemValue = [config getProp:propertyElem];
    NSString* actualAttrValue = [config getProp:propertyAttr];
    
    STAssertEqualObjects(actualElemValue, valueElem, @"Value %s does not match the expected %s!", 
                         [actualElemValue cStringUsingEncoding:NSUTF8StringEncoding], 
                         [valueElem cStringUsingEncoding:NSUTF8StringEncoding]);
    STAssertEqualObjects(actualAttrValue, valueAttr, @"Value %s does not match the expected %s!", 
                         [actualAttrValue cStringUsingEncoding:NSUTF8StringEncoding], 
                         [valueAttr cStringUsingEncoding:NSUTF8StringEncoding]);
}

-(void)tearDown
{
}

@end
