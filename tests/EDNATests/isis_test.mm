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

/* # Constants # */

const int RUNS = 20;

/* # Dataset files # */

NSString* fctFile = @"/Users/oliver/test/reg3d_test/dataset01/data_10timesteps.nii";
NSString* anaFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii"; //_visotrop.nii";
NSString* mniFile = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";

NSString* OZfun1ts = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_64x64_just1timestep.nii";

NSString* OZ00fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_128x128.nii";
NSString* OZ00ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mdeft.nii";
NSString* OZ00out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ00out.nii";

NSString* OZ01fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_64x64.nii";
NSString* OZ01ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mdeft.nii";
NSString* OZ01out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ01out.nii";

NSString* OZ02fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_coronar_64x64.nii";
NSString* OZ02ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mdeft.nii";
NSString* OZ02out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ02out.nii";

NSString* OZ03fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_sagittal_64x64.nii";
NSString* OZ03ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mdeft.nii";
NSString* OZ03out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ03out.nii";

NSString* OZ10fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_128x128.nii";
NSString* OZ10ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mprage.nii";
NSString* OZ10out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ10out.nii";

NSString* OZ11fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_axial_64x64.nii";
NSString* OZ11ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mprage.nii";
NSString* OZ11out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ11out.nii";

NSString* OZ12fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_coronar_64x64.nii";
NSString* OZ12ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mprage.nii";
NSString* OZ12out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ12out.nii";

NSString* OZ13fun = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_fun_sagittal_64x64.nii";
NSString* OZ13ana = @"/Users/oliver/test/reg3d_test_scansoliver/14265.5c_ana_mprage.nii";
NSString* OZ13out = @"/Users/oliver/test/reg3d_test_scansoliver/OZ13out.nii";



/* # Function declarations # */

void testVnormdataRegistrationWorkflowParams(NSString* funPath,
                                             NSString* anaPath,
                                             NSString* mniPath,
                                             int runs,
                                             NSString* outPath);

void testBARTRegistrationWorkflowParams(NSString* funPath,
                                        NSString* anaPath,
                                        NSString* mniPath,
                                        int runs,
                                        NSString* outPath);

void testBARTRegistrationAnaOnlyParams(NSString* funPath,
                                       NSString* anaPath,
                                       int runs,
                                       NSString* outPath);



/* # Function definitions # */

void testVnormdataRegistrationWorkflow()
{
    int runs = RUNS;
    NSString* vnormRegOut = @"/tmp/BART_vnormdata.nii";
    testVnormdataRegistrationWorkflowParams(fctFile,
                                            anaFile,
                                            mniFile,
                                            runs,
                                            vnormRegOut);
    
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ00ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ10ana, mniFile, runs, vnormRegOut);
    
    testVnormdataRegistrationWorkflowParams(OZ00fun, OZ00ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ01fun, OZ01ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ02fun, OZ02ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ03fun, OZ03ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ10fun, OZ10ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ11fun, OZ11ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ12fun, OZ12ana, mniFile, runs, vnormRegOut);
    testVnormdataRegistrationWorkflowParams(OZ13fun, OZ13ana, mniFile, runs, vnormRegOut);
}

void testVnormdataRegistrationWorkflowParams(NSString* funPath,
                                             NSString* anaPath,
                                             NSString* mniPath,
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
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // /Users/oliver/Development/BART/tests/BARTMainAppTests/testfiles
        //    NSString* imageFile = @"TestDataset01-functional.nii";
        
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
        
        aliStart = now(); // RUNTIME ANALYSIS CODE #
        
        RORegistrationMethod* method = [[RORegistrationVnormdata alloc] initFindingTransform:fctData 
                                                                                     anatomy:anaData
                                                                                   reference:mniData];
        
        aliEnd = now();   // RUNTIME ANALYSIS CODE #
        
        EDDataElement* ana2fct2mni = [method apply:fctData];
        
        appEnd = now();   // RUNTIME ANALYSIS CODE #
        diff = newTimeDiff(&aliStart, &aliEnd); // #
        alignTime += asDouble(diff);            // #
        free(diff);                             // #
        diff = newTimeDiff(&aliEnd, &appEnd);   // #
        applyTime += asDouble(diff);            // #
        free(diff);       // RUNTIME ANALYSIS CODE #
        
        [ana2fct2mni WriteDataElementToFile:outPath];
        
        [method release];
        
        [mniData release];
        [anaData release];
        [fctData release];
        
        [pool drain];
        
    }
    alignTime /= static_cast<double>(runs);
    applyTime /= static_cast<double>(runs);
    NSLog(@"Runtime BART_vnormdata for %d runs. Fun: %@ ana: %@ mni: %@ out: %@. Registration: %lf s, application: %lf s\n", 
          runs, funPath, anaPath, mniPath, outPath, alignTime, applyTime);
}

void testBARTRegistrationWorkflow()
{
    int runs = RUNS;
    NSString* bartRegOut = @"/tmp/BART_bartReg.nii";

    testBARTRegistrationWorkflowParams(fctFile, 
                                       anaFile, 
                                       mniFile, 
                                       runs, 
                                       bartRegOut);
    
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ00ana, mniFile, runs, bartRegOut);
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ10ana, mniFile, runs, bartRegOut);
    
    testBARTRegistrationWorkflowParams(OZ00fun, OZ00ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ01fun, OZ01ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ02fun, OZ02ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ03fun, OZ03ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ10fun, OZ10ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ11fun, OZ11ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ12fun, OZ12ana, mniFile, runs, bartRegOut);
    testBARTRegistrationWorkflowParams(OZ13fun, OZ13ana, mniFile, runs, bartRegOut);
}

void testBARTRegistrationWorkflowParams(NSString* funPath,
                                        NSString* anaPath,
                                        NSString* mniPath,
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
        
        aliStart = now(); // RUNTIME ANALYSIS CODE #
        
        RORegistrationMethod* method = [[RORegistrationBART alloc] initFindingTransform:fctData
                                                                                anatomy:anaData
                                                                              reference:mniData];
        
        aliEnd = now();   // RUNTIME ANALYSIS CODE #
        
        EDDataElement* fct2ana2mni = [method apply:fctData];
        
        appEnd = now();   // RUNTIME ANALYSIS CODE #
        diff = newTimeDiff(&aliStart, &aliEnd); // #
        alignTime += asDouble(diff);            // #
        free(diff);                             // #
        diff = newTimeDiff(&aliEnd, &appEnd);   // #
        applyTime += asDouble(diff);            // #
        free(diff);       // RUNTIME ANALYSIS CODE #
        
        [fct2ana2mni WriteDataElementToFile:outPath];
        
        [method release];
        
        [mniData release];
        [anaData release];
        [fctData release];
        
        [pool drain];
        
    }
    alignTime /= static_cast<double>(runs);
    applyTime /= static_cast<double>(runs);
    NSLog(@"Runtime BART_reg for %d runs. Fun: %@ ana: %@ mni: %@ out: %@. Registration: %lf s, application: %lf s\n", 
          runs, funPath, anaPath, mniPath, outPath, alignTime, applyTime);
}

void testBARTRegistrationAnaOnly()
{
    int runs = RUNS;
    NSString* bartRegAnaOnlyOut = @"/tmp/BART_bartRegAnaOnly.nii";
    
    testBARTRegistrationAnaOnlyParams(fctFile,
                                      anaFile,
                                      runs,
                                      bartRegAnaOnlyOut);
    
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ00ana, mniFile, runs, bartRegAnaOnlyOut);
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ10ana, mniFile, runs, bartRegAnaOnlyOut);
    
//    testBARTRegistrationAnaOnlyParams(OZ00fun, OZ00ana, runs, OZ00out);
//    testBARTRegistrationAnaOnlyParams(OZ01fun, OZ01ana, runs, OZ01out);
//    testBARTRegistrationAnaOnlyParams(OZ02fun, OZ02ana, runs, OZ02out);
//    testBARTRegistrationAnaOnlyParams(OZ03fun, OZ03ana, runs, OZ03out);
//    testBARTRegistrationAnaOnlyParams(OZ10fun, OZ10ana, runs, OZ10out);
//    testBARTRegistrationAnaOnlyParams(OZ11fun, OZ11ana, runs, OZ11out);
//    testBARTRegistrationAnaOnlyParams(OZ12fun, OZ12ana, runs, OZ12out);
//    testBARTRegistrationAnaOnlyParams(OZ13fun, OZ13ana, runs, OZ13out);
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
    for (int i = 0; i < RUNS; i++) {
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
    /* # Output redirection # */
//    system("rm -f /tmp/BART_regRuntime.txt");
//    freopen("/tmp/BART_regRuntime.txt", "a", stderr);
    
    /* # General Isis tests # */
//    testAdapterConversion();
//    testMemoryAdapter();
//    testPluginReadWrite();

    /* # Registration tests # */
//    testBARTRegistrationAnaOnly();
    testBARTRegistrationWorkflow();
    testVnormdataRegistrationWorkflow();
}