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

#import "ROTestUtil.h"

#import "EDDataElement.h"
#import "EDDataElementIsis.h"

#include <boost/filesystem.hpp>

@implementation RORegistrationTest

NSString* curDir    = @"";
NSString* fileName  = @"";
// /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
NSString* imageFile = @"TestDataset01-functional.nii";

NSString* DIFF_FILE = @"/tmp/RORegistrationMethodTest_DiffFile.txt";



NSString* TESTDATA_DIR      = @"/Users/olli/BART_testdata/TROY/";
NSString* DATA_FILE_FUN     = @"14265.5c_fun_axial_64x64.nii";
NSString* DATA_FILE_ANA     = @"14265.5c_ana_mdeft.nii";
NSString* REF_FILE_ANA_ONLY = @"ref_OZ01_BARTRegAnaOnly_ITK4_2_1_TROYTest_debug.nii";



// ###
// # Utility functions
// ###g

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

// ####################
// # Setup & teardown #
// ####################

+(void)setUp
{
    [super setUp];
    
	curDir = [[NSBundle bundleForClass:[self class] ] resourcePath];
    fileName = [NSString stringWithFormat:@"%@/%@", curDir, imageFile];
    
    ROTestUtil* util = [[ROTestUtil alloc] init];
    [util redirect:stderr to:@"/tmp/BART_RORegistrationMethodTest.log" using:@"w"];
    [util release];
}

+(void)tearDown
{
    // Custom teardown goes here
    
    [super tearDown];
}

// ## Per test setup & teardown ##

-(void)setUp
{
    [super setUp];
}

-(void)tearDown
{
    [super tearDown];
}

// ##############
// # Unit tests #
// ##############

-(void)testRegistrationAnaOnly
{
    NSString* funPath = [TESTDATA_DIR stringByAppendingString:DATA_FILE_FUN];
    NSString* anaPath = [TESTDATA_DIR stringByAppendingString:DATA_FILE_ANA];
    NSString* refPath = [TESTDATA_DIR stringByAppendingString:REF_FILE_ANA_ONLY];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_FCTDATA];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElement* reference   = [[EDDataElementIsis alloc] initWithFile:refPath
                                                               andSuffix:@""
                                                              andDialect:@""
                                                             ofImageType:IMAGE_FCTDATA];
    
    RORegistrationMethod* method = [[RORegistrationBARTAnaOnly alloc] initFindingTransform:fctData
                                                                                   anatomy:anaData
                                                                                 reference:nil];
    
    EDDataElement* result = [method apply:fctData];
    
    // Compare image sizes first
    BARTImageSize* resultSize    = [result getImageSize];
    BARTImageSize* referenceSize = [reference getImageSize];
    STAssertEquals(resultSize.rows     , referenceSize.rows     , @"Rows missmatch");
    STAssertEquals(resultSize.columns  , referenceSize.columns  , @"Columns missmatch");
    STAssertEquals(resultSize.slices   , referenceSize.slices   , @"Slices missmatch");
    STAssertEquals(resultSize.timesteps, referenceSize.timesteps, @"Timesteps missmatch");
    
    // Compare data
    int failures = 0;
    int maxFailures = 20;
    float precision = 5.0f;
    
    for (size_t ts = 0; ts < referenceSize.timesteps; ts++) {
        for (size_t slice = 0; slice < referenceSize.slices; slice++) {
            for (size_t row = 0; row < referenceSize.rows; row++) {
                for (size_t col = 0; col < referenceSize.columns; col++) {
                    float resVal = [result    getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                    float refVal = [reference getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                    
                    if ((resVal < (refVal - precision) or resVal > (refVal + precision)) and failures < maxFailures) {
                        STAssertEqualsWithAccuracy(resVal,
                                                   refVal,
                                                   precision,
                                                   [NSString stringWithFormat:@"Pos(ts:%ld, slice:%ld, row:%ld, col:%ld) voxel value missmatch .",
                                                    ts,
                                                    slice,
                                                    row,
                                                    col]);
                        failures++;
                    }
                }
            }
        }
    }
    
    STAssertEquals(failures, 0, [NSString stringWithFormat:@"Some voxel values did not match. If failures is equal to %d then probably more than %d voxels did not match (cut errors to avoid spam).", maxFailures, maxFailures]);
    
    [method release];
    
    [reference release];
    [anaData release];
    [fctData release];
    
    [pool drain];
}

-(void)testRuntime
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    ROTestUtil* util = [[ROTestUtil alloc] init];

    RORegistrationMethod* method = [RORegistrationBARTAnaOnly alloc];
    NSArray* times = [util measureRegistrationRuntime:[TESTDATA_DIR stringByAppendingString:DATA_FILE_FUN]
                                              anatomy:[TESTDATA_DIR stringByAppendingString:DATA_FILE_ANA]
                                                  mni:nil
                                                  out:@"/tmp/BART_RORegistrationMethodTest_runtime.nii"
                                         registration:method
                                                 runs:1];
    
    NSLog(@"Runtime tuple: (%@, %@)", [times objectAtIndex:0], [times objectAtIndex:1]);
    
    [method release];
    [util release];
    
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
