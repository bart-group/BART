//
//  COEDLValidatorTest.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidatorTest.h"
#import "COEDLValidator.h"


@interface COEDLValidatorTest (PrivateStuff)

COEDLValidator* validator;

@end

@implementation COEDLValidatorTest

-(void)setUp
{
    validator = [[COEDLValidator alloc] initWithContentsOfEDLFile:@"../tests/CLETUSTests/main_SW_BoldModule_2ContinousTargetROIs.edl" 
                                                      andEDLRules:@"../tests/CLETUSTests/edlValidation_rules.xml"];
}

-(void)testASetUp
{
    BOOL success = NO;
    
    if (validator) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"COEDLValidator object is nil! Check paths!");
}

-(void)testIsEDLConfigCorrectAccordingToRules
{
    BOOL valid = [validator isEDLConfigCorrectAccordingToRules];
    
    STAssertEquals(YES, valid, @"Some rules are not valid!");
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
    
    NSString* attrResult    = [COEDLValidator substituteEDLValueForRef:attrRef basedOnNode:docRoot];
    NSString* contentResult = [COEDLValidator substituteEDLValueForRef:contentRef basedOnNode:docRoot];
    
    NSString* r1FalsePath1  = [COEDLValidator substituteEDLValueForRef:falsePath1 basedOnNode:docRoot];
    NSString* r2FalsePath2  = [COEDLValidator substituteEDLValueForRef:falsePath2 basedOnNode:docRoot];
    NSString* r3FalsePath3  = [COEDLValidator substituteEDLValueForRef:falsePath3 basedOnNode:docRoot];
    NSString* r4FalsePath4  = [COEDLValidator substituteEDLValueForRef:falsePath4 basedOnNode:docRoot];
    NSString* r5FalsePath5  = [COEDLValidator substituteEDLValueForRef:falsePath5 basedOnNode:docRoot];
    NSString* r6FalsePath6  = [COEDLValidator substituteEDLValueForRef:falsePath6 basedOnNode:docRoot];
    
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

-(void)tearDown
{
    [validator release];
}

@end
