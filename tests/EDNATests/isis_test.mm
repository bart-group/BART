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

#import "RORegistration.h"



@implementation isis_test

@end

void testVnormdataRegistrationWorkflow() {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
    //    NSString* imageFile = @"TestDataset01-functional.nii";
    NSString* fctFile = @"/Users/oliver/test/reg3d_test/dataset01/data.nii";
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:fctFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    
    NSString* anaFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii"; //_visotrop.nii";
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    NSString* mniFile = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";
    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniFile
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    
    // Registrate
    RORegistration* ana2fctReg = [[RORegistration alloc] init];
    EDDataElement* ana2fct = [ana2fctReg align:anaData 
                               beingFunctional:NO
                                 withReference:fctData];
    
    RORegistration* ana2fct2mniReg = [[RORegistration alloc] init];
    EDDataElement* ana2fct2mni = [ana2fct2mniReg align:ana2fct 
                                       beingFunctional:NO                   // YES
                                         withReference:mniData];
    
    [ana2fct WriteDataElementToFile:@"/tmp/IsisTestAna2Fct.nii"];
    [ana2fct2mni WriteDataElementToFile:@"/tmp/IsisTestAna2Fct2Mni.nii"];
    
    // Cleanup
    [mniData release];
    [anaData release];
    [fctData release];
    [ana2fct2mniReg release];
    [ana2fctReg release];
    
	[pool drain];
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
    testVnormdataRegistrationWorkflow();
//    testAdapterConversion();
}