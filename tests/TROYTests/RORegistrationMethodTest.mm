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

NSString* testfilePath = @"/Users/Lydi/RealTimeProject/data/Testdata_Registration/TROYTests/";

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
    NSString* funPath = [testfilePath stringByAppendingPathComponent:@"data_10timesteps.nii"];
    NSString* anaPath = [testfilePath stringByAppendingPathComponent:@"ana.nii"];
    NSString* mniPath = [testfilePath stringByAppendingPathComponent:@"mni_lipsia.nii"];
    
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
    
    RORegistrationMethod* method = [[RORegistrationVnormdata alloc] initFindingTransform:fctData 
                                                                                 anatomy:anaData
                                                                               reference:mniData];
    
    EDDataElement* ana2fct2mni = [method apply:fctData];
    
    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_vnormdata.nii";
    [ana2fct2mni WriteDataElementToFile:outPath];
    
    NSString* refPath = [testfilePath stringByAppendingPathComponent:@"BART_vnormdata_11ts.nii"];

    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
    system([diffCmd UTF8String]);
    uint64_t size = getFileSize(DIFF_FILE);
    
    STAssertTrue(size == 0, @"Vnormdata: ana2fct2mni and reference differ! Expected an empty diff file!");
    
    [method release];
    
    [mniData release];
    [anaData release];
    [fctData release];
    
    [pool drain];

}

-(void)testRegistrationBART
{
    NSString* funPath = [testfilePath stringByAppendingPathComponent:@"data_10timesteps.nii"];
    NSString* anaPath = [testfilePath stringByAppendingPathComponent:@"ana.nii"];
    NSString* mniPath = [testfilePath stringByAppendingPathComponent:@"mni_lipsia.nii"];
    
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
    
    RORegistrationMethod* method = [[RORegistrationBART alloc] initFindingTransform:fctData
                                                                            anatomy:anaData
                                                                          reference:mniData];
    
    EDDataElement* fct2ana2mni = [method apply:fctData];
    
    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_bartReg.nii";
    [fct2ana2mni WriteDataElementToFile:outPath];
    
    NSString* refPath = [testfilePath stringByAppendingPathComponent:@"BART_bartReg.nii"];
    
    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
    system([diffCmd UTF8String]);
    uint64_t size = getFileSize(DIFF_FILE);
    
    STAssertTrue(size == 0, @"BartReg: fct2ana2mni and reference differ! Expected an empty diff file!");
    
    [method release];
    
    [mniData release];
    [anaData release];
    [fctData release];
    
    [pool drain];

}

-(void)testRegistrationBARTAnaOnly
{
    NSString* funPath = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_64x64.nii"];
    NSString* anaPath = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mprage.nii"];
    NSString* mapPath = [testfilePath stringByAppendingPathComponent:@"zmap01_10timesteps.nii"];
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElementIsis* mapData = [[EDDataElementIsis alloc] initWithFile:mapPath 
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ZMAP];
    
    RORegistrationMethod* method = [[RORegistrationBARTAnaOnly alloc] initFindingTransform:fctData
                                                                                   anatomy:anaData
                                                                                 reference:nil];
    
    EDDataElement* map2ana = [method apply:mapData];
    
    NSString* outPath = @"/tmp/RORegistrationMethodTest_out_bartRegAnaOnly.nii";
    [map2ana WriteDataElementToFile:outPath];
    
    NSString* refPath = [testfilePath stringByAppendingPathComponent:@"alignedZmapAxial64x64_zmap01.nii"];
//    EDDataElement* map2anaRef = [[EDDataElementIsis alloc] initWithFile:refPath
//                                                              andSuffix:@"" 
//                                                             andDialect:@"" 
//                                                            ofImageType:IMAGE_ANADATA];

    NSString* diffCmd = makeDiffCmd(outPath, refPath, DIFF_FILE);
    system([diffCmd UTF8String]);
    uint64_t size = getFileSize(DIFF_FILE);
    
    STAssertTrue(size == 0, @"BartRegAnaOnly: map2ana and reference differ! Expected an empty diff file!");
    
    
//    [map2anaRef release];
    
    [method release];
    
    [mapData release];
    [anaData release];
    [fctData release];
    
    [pool drain];
}

@end
