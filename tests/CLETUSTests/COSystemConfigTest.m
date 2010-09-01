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
    BOOL success = NO;
    
    // Normal write.
    err = [config writeToFile:@"/tmp/cletusTestCaseWrite.edl"];
    if (!err) {
        success = YES;
    }
    
    // Try to write invalid file.
    err = [config writeToFile:@".-.-.-.-.-.-.blub"];
    if (err) {
        success = success && YES;
    }
    
    // Update value and write...
    NSString* newTR = @"3000";
    [config setProp:@"$TR" :newTR];
    err = [config writeToFile:@"/tmp/cletusTestCaseWrite.edl"];
    if (!err) {
        success = success && YES;
    }
    
    // ... reset and read file again. Check new value.
    [self setUp];
    err = [config fillWithContentsOfEDLFile:@"/tmp/cletusTestCaseWrite.edl"];
    if (!err
        && ([[config getProp:@"$TR"] compare:newTR] == 0)) {
        success = success && YES;
    }
    
    [self setUp];
    
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



-(void)testReplacePropWithNode
{
    [config fillWithContentsOfEDLFile:@"../tests/CLETUSTests/pseudoStimulusDataBlock.edl"];
    NSXMLNode* replacementAttr = [NSXMLNode attributeWithName:@"testattr" stringValue:@"42"];
    NSXMLElement* replacementElem = [NSXMLElement elementWithName:@"testelem"];
    NSXMLElement* replacementElemChild = [NSXMLElement elementWithName:@"elemchild" stringValue:@"foo"];
    NSXMLNode* replacementElemAttr = [NSXMLNode attributeWithName:@"elemattr" stringValue:@"bar"];
    
    [replacementElem addChild:replacementElemChild];
    [replacementElem addAttribute:replacementElemAttr];
    
    NSString* attrToReplaceKey = @"/rtExperiment/stimulusData/stimEnvironment/startTrigger/@waitForInitialTrigger";
    NSString* elemToReplaceKey = @"/rtExperiment/experimentData";
    
    BOOL success = NO;
    
    NSError* err = [config replaceProp:attrToReplaceKey withNode:replacementAttr];
    if ([[config getProp:@"/rtExperiment/stimulusData/stimEnvironment/startTrigger/@testattr"] isEqualToString:[replacementAttr stringValue]]
        && err == nil) {
        success = YES;
    }
    
    STAssertTrue(success, @"Method replaceProp:withNode: does not replace attributes correctly!");
    
    success = NO;
    err = [config replaceProp:elemToReplaceKey withNode:replacementElem];
    if ([config countNodes:@"/rtExperiment/testelem"] == 1
        && [[config getProp:@"/rtExperiment/testelem/elemchild"] isEqualToString:[replacementElemChild stringValue]]
        && [[config getProp:@"/rtExperiment/testelem/@elemattr"] isEqualToString:[replacementElemAttr stringValue]]
        && err == nil) {
        success = YES;
    }
    
    STAssertTrue(success, @"Method replaceProp:withNode: does not replace elements correctly!");
}

-(void)testReplacePropWithNodeRemovalAndError
{
    NSString* toDeleteKey = @"/rtExperiment/stimulusData/stimEnvironment/screen/screenResolutionX";
    
    BOOL success = NO;
    if ([config countNodes:toDeleteKey] == 1) {
        success = YES;
    }
    
    NSError* err = [config replaceProp:toDeleteKey withNode:nil];
    
    if ([config countNodes:toDeleteKey] == 0
        && err == nil) {
        success = success && YES;
    } else {
        success = NO;
    }
	
    STAssertTrue(success, @"Method replaceProp:withNode: does not delete entries correctly!");
    
    success = NO;
    err = [config replaceProp:@"fooNotExisting" withNode:nil];
    if (err) {
        success = YES;
    }
    
    STAssertTrue(success, @"Method replaceProp:withNode: does not generate an error when requested to replace a non-existing entry!");
}

-(void)testValidateAgainstXSD
{
	[config fillWithContentsOfEDLFile:@"../tests/CLETUSTests/pseudoStimulusDataBlock.edl"];
	
    BOOL success = NO;
    NSError* error = [config validateAgainstXSD:@"../tests/CLETUSTests/rtExperiment_v14_simplified.xsd"];
    
    if (error) {
		//        FILE* fp = fopen("/tmp/validationErrors.txt", "w");
		//        fprintf(fp, [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
		//        fclose(fp);
    } else {
        success = YES;
    }
	
    STAssertTrue(success, @"Method validateAgainstXSD: does not work properly!");
    
    success = NO;
    error = [config validateAgainstXSD:nil];
    
    if (error) {
		//        FILE* fp = fopen("/tmp/validationErrors.txt", "w");
		//        fprintf(fp, [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
		//        fclose(fp);
    } else {
        success = YES;
    }
    
    STAssertTrue(success, @"Method validateAgainstXSD: does not work properly when nil is passed!");
}

-(void)testValidateAgainstXSDChallengeErrors
{
	[config fillWithContentsOfEDLFile:@"../tests/CLETUSTests/pseudoStimulusDataBlock.edl"];
	BOOL success = NO;
    NSError* error = [config validateAgainstXSD:@"../tests/CLETUSTests/rtExperiment_v14.xsd"];
    
    if (error) {
        if ([[error localizedDescription] 
             isEqualToString:@"Element 'experimentData': This element is not expected. Expected is ( environment ).\n"]) {
            success = YES;
        }
		//        FILE* fp = fopen("/tmp/validationErrors.txt", "w");
		//        fprintf(fp, [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
		//        fclose(fp);
    }
    
    STAssertTrue(success, @"Method validateAgainstXSD: does not detect all validation errors!");
    
    success = NO;
    error = [config validateAgainstXSD:@"notExisting.xsd"];
    
    if (error) {
        if ([[error localizedDescription] 
             isEqualToString:@"Failed to locate the main schema resource at 'notExisting.xsd'.\n"]) {
            success = YES;
        }
    }
    
    STAssertTrue(success, @"Method validateAgainstXSD: does not generate an error if the XSD file is not found!");
}

-(void)tearDown
{
}

@end
