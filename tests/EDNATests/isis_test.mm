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
    TimeVal aliStart;
    TimeVal aliEnd;
    TimeVal appEnd;
    TimeDiff* diff;
    double alignTime = 0.0;
    double applyTime = 0.0;
    int runs = 1;
    for (int i = 0; i < runs; i++) {
        
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                                   andSuffix:@"" 
                                                                  andDialect:@"" 
                                                                 ofImageType:IMAGE_FCTDATA];
        
        EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                                   andSuffix:@"" 
                                                                  andDialect:@"" 
                                                                 ofImageType:IMAGE_ANADATA];
        
        
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
        
        [fct2ana WriteDataElementToFile:@"/tmp/BART_bartRegAnaOnly.nii"];
        
        [method release];
        
        [anaData release];
        [fctData release];
        
        [pool drain];
        
    }
    alignTime /= static_cast<double>(runs);
    applyTime /= static_cast<double>(runs);
    NSLog(@"Runtime BART_reg_anaonly for %d runs. Registration: %lfs, application: %lfs\n", runs, alignTime, applyTime);
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

int main(void)
{
    testBARTRegistrationAnaOnly();

//    testBARTRegistrationWorkflow();
//    testVnormdataRegistrationWorkflow();    
//    testAdapterConversion();
}