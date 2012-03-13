//
//  isis_test.mm
//  BARTApplication
//
//  Created by Lydia Hellrung on 6/24/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "isis_test.h"
#import "EDNA/EDDataElementIsis.h"
#import "CoreUtils/common.hpp"

#import "RORegistrationVnormdata.h"
#import "RORegistrationBART.h"
#import "RORegistrationBARTAnaOnly.h"

#import "TimeUtil.h"



@implementation isis_test

@end

NSString* fctFile = @"/Users/oliver/test/reg3d_test/dataset01/data_10timesteps.nii";
NSString* anaFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii"; //_visotrop.nii";
NSString* mniFile = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";

/* # Function declarations # */

void testBARTRegistrationAnaOnlyParams(NSString* funPath,
                                       NSString* anaPath,
                                       int runs,
                                       NSString* outPath);

/* # Function definitions # */

void testVnormdataRegistrationWorkflow() 
{          
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
    //    NSString* imageFile = @"TestDataset01-functional.nii";
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    
    RORegistrationMethod* method = [[RORegistrationVnormdata alloc] initFindingTransform:fctData 
                                                                                 anatomy:anaData
                                                                               reference:mniData];
    
    EDDataElement* ana2fct2mni = [method apply:fctData];
    
    
    [ana2fct2mni WriteDataElementToFile:@"/tmp/BART_vnormdata.nii"];
    
    [method release];
    
    [mniData release];
    [anaData release];
    [fctData release];
    
    [pool drain];
}

void testBARTRegistrationWorkflow() 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    RORegistrationMethod* method = [[RORegistrationBART alloc] initFindingTransform:fctData
                                                                            anatomy:anaData
                                                                          reference:mniData];
    
    EDDataElement* fct2ana2mni = [method apply:fctData];
    
    [fct2ana2mni WriteDataElementToFile:@"/tmp/BART_bartReg.nii"];
    
    [method release];
    
    [mniData release];
    [anaData release];
    [fctData release];
    
    [pool drain];
}

void testBARTRegistrationAnaOnly()
{
    testBARTRegistrationAnaOnlyParams(fctFile,
                                      anaFile,
                                      1,
                                      @"/tmp/BART_bartRegAnaOnly.nii");
}

void testBARTRegistrationAnaOnlyParams(NSString* funPath,
                                       NSString* anaPath,
                                       int runs,
                                       NSString* outPath) 
{
    TimeVal aliStart;
    TimeVal aliEnd;
    TimeVal appEnd;
    TimeDiff* diff;
    double alignTime = 0.0;
    double applyTime = 0.0;
    for (int i = 0; i < runs; i++) {
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
                                                                   andSuffix:@"" 
                                                                  andDialect:@"" 
                                                                 ofImageType:IMAGE_FCTDATA];
        NSArray* forceMemoryLoad = [fctData getMinMaxOfDataElement];
        
        EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
                                                                   andSuffix:@"" 
                                                                  andDialect:@"" 
                                                                 ofImageType:IMAGE_ANADATA];
        forceMemoryLoad = [anaData getMinMaxOfDataElement];
        
        
        aliStart = now(); // RUNTIME ANALYSIS CODE #
        
        RORegistrationMethod* method = [[RORegistrationBARTAnaOnly alloc] initFindingTransform:fctData
                                                                                       anatomy:anaData
                                                                                     reference:nil];
        aliEnd = now();   // RUNTIME ANALYSIS CODE #
        
        EDDataElement* fct2ana = [method apply:fctData];
        
        appEnd = now();   // RUNTIME ANALYSIS CODE #
        diff = newTimeDiff(&aliStart, &aliEnd); // #
        alignTime += asDouble(diff);            // #
        free(diff);                             // #
        diff = newTimeDiff(&aliEnd, &appEnd);   // #
        applyTime += asDouble(diff);            // #
        free(diff);       // RUNTIME ANALYSIS CODE #
        
        [fct2ana WriteDataElementToFile:outPath];
        
        [method release];
        
        [anaData release];
        [fctData release];
        
        [pool drain];
        
    }
    alignTime /= static_cast<double>(runs);
    applyTime /= static_cast<double>(runs);
    NSLog(@"Runtime BART_reg_anaonly for %d runs. Fun: %@ ana: %@ out: %@. Registration: %lf s, application: %lf s\n", 
          runs, funPath, anaPath, outPath, alignTime, applyTime);
}

void testAdapterConversion() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Functional data
    NSString* fctFile = @"/Users/oliver/test/reg3d_test/dataset01/data.nii";
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    
    ITKImage4D::Pointer fctITK = [fctData asITKImage4D];
    EDDataElement* fctDataConverted = [fctData convertFromITKImage4D:fctITK];
    
    [fctData WriteDataElementToFile:@"/tmp/adapter_fct.nii"];
    [fctDataConverted WriteDataElementToFile:@"/tmp/adapter_fct_converted.nii"];
    
    [fctData release];
    
    
    // Anatomical data
    NSString* anaFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii"; //_visotrop.nii";
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    ITKImage::Pointer anaITK = [anaData asITKImage];
    EDDataElement* anaDataConverted = [anaData convertFromITKImage:anaITK];
    
    [anaData WriteDataElementToFile:@"/tmp/adapter_ana.nii"];
    [anaDataConverted WriteDataElementToFile:@"/tmp/adapter_ana_converted.nii"];
    
    [anaData release];
    
	[pool drain];
}

void testMemoryAdapter()
{
    int runs = 50;
    for (int i = 0; i < runs; i++) {
        testAdapterConversion();
        
//        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
//        EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
//                                                                   andSuffix:@"" 
//                                                                  andDialect:@"" 
//                                                                 ofImageType:IMAGE_FCTDATA];
//        ITKImage4D::Pointer fctITK = [fctData asITKImage4D];
//        EDDataElement* fctDataConverted = [fctData convertFromITKImage4D:fctITK];
//        
//        [fctData WriteDataElementToFile:@"/tmp/adapter_fct.nii"];
//        [fctDataConverted WriteDataElementToFile:@"/tmp/adapter_fct_converted.nii"];
//        
//        [fctData release];
//        [pool drain];
    }
}

void testPluginReadWrite()
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];

    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    [fctData WriteDataElementToFile:@"/tmp/BART_plugintest_fct.nii"];
    [anaData WriteDataElementToFile:@"/tmp/BART_plugintest_ana.nii"];
    
    [anaData release];
    [fctData release];
    
    [pool drain];
}

int main(void)
{
    /* # General Isis tests # */
//    testAdapterConversion();
//    testMemoryAdapter();
//    testPluginReadWrite();

    /* # Registration tests # */
    testBARTRegistrationAnaOnly();
//    testBARTRegistrationWorkflow();
//    testVnormdataRegistrationWorkflow();
}