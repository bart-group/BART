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
	NSFileManager *fm = [NSFileManager defaultManager];
    BOOL fileExists = [fm fileExistsAtPath:@"../tests/CLETUSTests/Init_Links_1.edl"] ;
	if (YES == fileExists){
		config = [COSystemConfig getInstance];
		[config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
	}
	else {
		printf("TEST");
	}
}

-(void)testInit
{
	NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"../tests/CLETUSTests/Init_Links_1.edl"];
//    err = [config initWithContentsOfEDLFile:@"/Users/Lydi/Development/BARTProcedure/EDL_material/test.xml"];
    
    BOOL success = NO;
    if (err == nil) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Error(s) occured during initWithContentsOfEDLFile!"); 
}

-(void)testChallengeInitError
{
    NSError* err = nil;
	err = [config initWithContentsOfEDLFile:@"not_existing.xml"];
    
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
//    NSString* property = @"/person/name[1]/firstName";
    NSString* value = [config getProp:property];
    
//    FILE* fp = fopen("/Users/Lydi/Development/BARTProcedure/EDL_material/outfile_getprop.txt", "w");
//    fputs([value cStringUsingEncoding:NSUTF8StringEncoding], fp);
//    fclose(fp);
    
    NSString* expected = @"results_";
//    NSString* expected = @"John";

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

//-(void)testNSXMLDocumentClass
//{
//    NSXMLDocument* doc;
//    NSError* err;
//    NSString* file = [[NSString alloc] initWithString:@"/Users/Lydi/Development/BARTProcedure/EDL_material/test.xml"];
//    NSURL* fileURL = [NSURL fileURLWithPath:file];
//    
//    doc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL 
//                                               options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA) 
//                                                 error:&err];
//    
////    NSError* err;
////    NSString* fileContent = [NSString stringWithContentsOfFile:@"/Users/Lydi/Development/BARTProcedure/EDL_material/test.xml" 
////                                                      encoding:NSUTF8StringEncoding
////                                                         error:&err];
////    FILE* fp = fopen("/Users/Lydi/Development/BARTProcedure/EDL_material/outfile_docclass.txt", "w");
////    fputs([fileContent cStringUsingEncoding:NSUTF8StringEncoding], fp);
////    fclose(fp);
////    
////    NSXMLDocument* doc = [[NSXMLDocument alloc] initWithXMLString:fileContent
////                                                          options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
////                                                            error:&err];
////    if (doc == nil) { 
////        doc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL 
////                                                   options:NSXMLDocumentTidyXML 
////                                                     error:&err]; 
////    }
//    
//    NSXMLElement* thisUser;
//    NSArray* nodes = [doc nodesForXPath:@"/person/name[1]" error:&err];
//    if ([nodes count] > 0) {
//        thisUser = [nodes objectAtIndex:0];
////        FILE* fp = fopen("/Users/Lydi/Development/BARTProcedure/EDL_material/outfile_docclass.txt", "w");
////        fputs([[[thisUser childAtIndex:0] stringValue] cStringUsingEncoding:NSUTF8StringEncoding], fp);
////        fputs([[NSString stringWithFormat:@"%@", doc] cStringUsingEncoding:NSUTF8StringEncoding], fp);
////        fclose(fp);
//    }
//    
//    STAssertEqualObjects([[thisUser childAtIndex:0] stringValue], @"John", @"Element value missmatch!"); 
//}

-(void)tearDown
{
}

@end
