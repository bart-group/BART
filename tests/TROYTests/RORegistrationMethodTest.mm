//
//  RORegistrationTest.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 8/23/11.
//  Copyright (c) 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RORegistrationMethodTest.h"

#import "RORegistrationMethod.h"
#import "RORegistrationVnormdata.h"
#import "RORegistrationBART.h"
#import "RORegistrationBARTAnaOnly.h"

#import "EDDataElement.h"
#import "EDDataElementIsis.h"

#include <boost/filesystem.hpp>

@implementation RORegistrationTest

NSString* curDir    = @"";
NSString* fileName  = @"";
// /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
NSString* imageFile = @"TestDataset01-functional.nii";

NSString* DIFF_FILE = @"/tmp/RORegistrationMethodTest_DiffFile.txt";


NSString* DATA_DIR      = @"/Users/olli/test/reg3d_test/";
NSString* REFERENCE_DIR = @"/Users/olli/test/reg3d_references/";

NSString* FUN_FILE = @"dataset01/data_10timesteps.nii";
NSString* ANA_FILE = @"dataset01/ana.nii";
NSString* MNI_FILE = @"mni_lipsia.nii";
NSString* REFERENCE_FILE = @"BART_vnormdata_11ts.nii";


// ###
// # Utility functions
// ###

NSString* makeDiffCmd(NSString* fileA,
                      NSString* fileB,
                      NSString* diffFile)
{
    return [NSString stringWithFormat:@"diff %@ %@ > %@", fileA, fileB, diffFile];
}

uint64_t getFileSize(NSString* file)
{
    return boost::filesystem::file_size([file UTF8String]);
}

// ###
// # Setup
// ###

-(void) setUp
{
	curDir = [[NSBundle bundleForClass:[self class] ] resourcePath];
    fileName = [NSString stringWithFormat:@"%@/%@", curDir, imageFile];
}

// ###
// # Unit tests
// ###

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

-(void)testRegistrationVnormdata
{
    NSString* funPath = [DATA_DIR stringByAppendingString:FUN_FILE];
    NSString* anaPath = [DATA_DIR stringByAppendingString:ANA_FILE];
    NSString* mniPath = [DATA_DIR stringByAppendingString:MNI_FILE];
    
    NSString* refPath = [REFERENCE_DIR stringByAppendingString:REFERENCE_FILE];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_FCTDATA];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElement* reference   = [[EDDataElementIsis alloc] initWithFile:refPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_FCTDATA];
    
    RORegistrationMethod* method = [[RORegistrationVnormdata alloc] initFindingTransform:fctData
                                                                                 anatomy:anaData
                                                                               reference:mniData];
    
    EDDataElement* ana2fct2mni = [method apply:fctData];
    
    // Compare image sizes first
    BARTImageSize* resultSize = [ana2fct2mni getImageSize];
    BARTImageSize* referenceSize = [reference getImageSize];
    STAssertEquals(resultSize.rows     , referenceSize.rows     , @"Rows missmatch");
    STAssertEquals(resultSize.columns  , referenceSize.columns  , @"Columns missmatch");
    STAssertEquals(resultSize.slices   , referenceSize.slices   , @"Slices missmatch");
    STAssertEquals(resultSize.timesteps, referenceSize.timesteps, @"Timesteps missmatch");
    
    // TODO: compare ana2fct2mni and reference here
//    STAssertEquals(1, 2, @"testRegistrationVnormdata: 1 != 2. Surprise!");
    
    [method release];
    
    [reference release];
    [mniData release];
    [anaData release];
    [fctData release];
    
    [pool drain];
}

//-(void)testRegistrationVnormdata
//{
//    NSString* funPath = @"/Users/oliver/test/reg3d_test/dataset01/data_10timesteps.nii";
//    NSString* anaPath = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii";
//    NSString* mniPath = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_FCTDATA];
//    
//    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ANADATA];
//    
//    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ANADATA];
//    
//    RORegistrationMethod* method = [[RORegistrationVnormdata alloc] initFindingTransform:fctData 
//                                                                                 anatomy:anaData
//                                                                               reference:mniData];
//    
//    EDDataElement* ana2fct2mni = [method apply:fctData];
//    
//    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_vnormdata.nii";
//    [ana2fct2mni WriteDataElementToFile:outPath];
//    
//    NSString* refPath = @"/Users/oliver/test/reg3d_references/BART_vnormdata_11ts.nii";
//
//    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
//    system([diffCmd UTF8String]);
//    uint64_t size = getFileSize(DIFF_FILE);
//    
//    STAssertTrue(size == 0, @"Vnormdata: ana2fct2mni and reference differ! Expected an empty diff file!");
//    
//    [method release];
//    
//    [mniData release];
//    [anaData release];
//    [fctData release];
//    
//    [pool drain];
//
//}
//
//-(void)testRegistrationBART
//{
//    NSString* funPath = @"/Users/oliver/test/reg3d_test/dataset01/data_10timesteps.nii";
//    NSString* anaPath = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii";
//    NSString* mniPath = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";
//    
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_FCTDATA];
//    
//    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ANADATA];
//    
//    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ANADATA];
//    
//    RORegistrationMethod* method = [[RORegistrationBART alloc] initFindingTransform:fctData
//                                                                            anatomy:anaData
//                                                                          reference:mniData];
//    
//    EDDataElement* fct2ana2mni = [method apply:fctData];
//    
//    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_bartReg.nii";
//    [fct2ana2mni WriteDataElementToFile:outPath];
//    
//    NSString* refPath = @"/Users/oliver/test/reg3d_references/BART_bartReg.nii";
//    
//    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
//    system([diffCmd UTF8String]);
//    uint64_t size = getFileSize(DIFF_FILE);
//    
//    STAssertTrue(size == 0, @"BartReg: fct2ana2mni and reference differ! Expected an empty diff file!");
//    
//    [method release];
//    
//    [mniData release];
//    [anaData release];
//    [fctData release];
//    
//    [pool drain];
//
//}
//
//-(void)testRegistrationBARTAnaOnly
//{
//    NSString* funPath = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_64x64.nii";
//    NSString* anaPath = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mprage.nii";
//    NSString* mapPath = @"/Users/oliver/test/reg3d_test_scansoliver/zmap01_10timesteps.nii";
//    
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//    
//    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_FCTDATA];
//    
//    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ANADATA];
//    
//    EDDataElementIsis* mapData = [[EDDataElementIsis alloc] initWithFile:mapPath 
//                                                               andSuffix:@"" 
//                                                              andDialect:@"" 
//                                                             ofImageType:IMAGE_ZMAP];
//    
//    RORegistrationMethod* method = [[RORegistrationBARTAnaOnly alloc] initFindingTransform:fctData
//                                                                                   anatomy:anaData
//                                                                                 reference:nil];
//    
//    EDDataElement* map2ana = [method apply:mapData];
//    
//    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_bartRegAnaOnly.nii";
//    [map2ana WriteDataElementToFile:outPath];
//    
//    NSString* refPath = @"/Users/oliver/test/reg3d_test_scansoliver/alignedZmapAxial64x64_zmap01.nii";
////    EDDataElement* map2anaRef = [[EDDataElementIsis alloc] initWithFile:refPath
////                                                              andSuffix:@"" 
////                                                             andDialect:@"" 
////                                                            ofImageType:IMAGE_ANADATA];
//
//    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
//    system([diffCmd UTF8String]);
//    uint64_t size = getFileSize(DIFF_FILE);
//    
//    STAssertTrue(size == 0, @"BartRegAnaOnly: map2ana and reference differ! Expected an empty diff file!");
//    
//    
////    [map2anaRef release];
//    
//    [method release];
//    
//    [mapData release];
//    [anaData release];
//    [fctData release];
//    
//    [pool drain];
//}

@end
