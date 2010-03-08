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
    [config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl" andEDLRules:nil];
}

-(void)testInit
{
	NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl" andEDLRules:nil];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Error(s) occured during initWithContentsOfEDLFile!"); 
}

-(void)testChallengeInitError
{
    NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"not_existing.foo" andEDLRules:nil];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    [self setUp];
    
    STAssertEquals(NO, success, @"Expected reading error (XML_DOCUMENT_READ, file not existing)!");
}

-(void)testSubstituteEDLValueForRef
{
    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithXMLString:@"<?xml version=\"1.0\"?><!-- far --><rules><rule><param value=\"foo\"></param></rule><rule><param>bar</param></rule></rules><!-- boo -->" 
                                                          options:NSXMLDocumentTidyXML 
                                                            error:nil];
    
    NSString* attrRef    = @"rules.rule.param.ATTRIBUTE.value";
    NSString* contentRef = @"rules.rule{2}.param.CONTENT";
    
    NSString* falsePath1  = @"rules.rule{3}.param.CONTENT";
    NSString* falsePath2  = @"rules.rand.param.CONTENT";
    NSString* falsePath3  = @"rules.rule.param.ATTRIBUTE.not";
    NSString* falsePath4  = @"rules.rule.param.ATTRIBUT.value";
    NSString* falsePath5  = @"rules.rule{2}.param.CONTEN";
    NSString* falsePath6  = @"rules";
    
    
    NSString* attrRefExpectedValue    = @"foo";
    NSString* contentRefExpectedValue = @"bar";
    
    NSXMLNode* docRoot = [[doc rootElement] parent];
    
    NSString* attrResult    = [config substituteEDLValueForRef:attrRef basedOnNode:docRoot];
    NSString* contentResult = [config substituteEDLValueForRef:contentRef basedOnNode:docRoot];
    
    NSString* r1FalsePath1  = [config substituteEDLValueForRef:falsePath1 basedOnNode:docRoot];
    NSString* r2FalsePath2  = [config substituteEDLValueForRef:falsePath2 basedOnNode:docRoot];
    NSString* r3FalsePath3  = [config substituteEDLValueForRef:falsePath3 basedOnNode:docRoot];
    NSString* r4FalsePath4  = [config substituteEDLValueForRef:falsePath4 basedOnNode:docRoot];
    NSString* r5FalsePath5  = [config substituteEDLValueForRef:falsePath5 basedOnNode:docRoot];
    NSString* r6FalsePath6  = [config substituteEDLValueForRef:falsePath6 basedOnNode:docRoot];
    
    BOOL success = NO;
    
    if ([attrResult compare:attrRefExpectedValue] == 0
        && [contentResult compare:contentRefExpectedValue] == 0) {
        success = YES;
    }
    
    if (r1FalsePath1 != nil
        || r2FalsePath2 != nil
        || r3FalsePath3 != nil
        || r4FalsePath4 != nil
        || r5FalsePath5 != nil
        || r6FalsePath6 != nil) {
        success = NO;
    }
    
    STAssertEquals(YES, success, @"References were not successfully resolved!");
    
    [doc release];
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
