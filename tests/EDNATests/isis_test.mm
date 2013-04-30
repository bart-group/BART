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
#import "ROTestUtil.h"



@implementation isis_test

@end

/* # Constants # */

const int RUNS = 1;

/* # Dataset files # */

NSString* BART_REG = @"BART_bartReg";
NSString* BART_REG_ANAONLY = @"BART_bartRegAnaOnly";
NSString* BART_VNORMDATA = @"BART_vnormdata";

NSString* T1_SUFFIX = @"_t1";
NSString* LIPSIA_MNI_SUFFIX = @"_lipsia-mni";

NSString* DS01 = @"_dataset01";

NSString* MDEFT = @"_mdeft";
NSString* MPRAGE = @"_mprage";

NSString* ONE_TS_MDEFT  = @"_1ts_mdeft";
NSString* ONE_TS_MPRAGE = @"_1ts_mprage";

NSString* OZ00 = @"_OZ00";
NSString* OZ01 = @"_OZ01";
NSString* OZ02 = @"_OZ02";
NSString* OZ03 = @"_OZ03";
NSString* OZ10 = @"_OZ10";
NSString* OZ11 = @"_OZ11";
NSString* OZ12 = @"_OZ12";
NSString* OZ13 = @"_OZ13";

NSString* ZMAP_BASE_DS01 = @"dataset01_zmap"; 
NSString* ZMAP_BASE = @"alignedZmapAxial64x64";
NSString* ZMAP01 = @"_zmap01";
NSString* ZMAP02 = @"_zmap02";
NSString* ZMAP03 = @"_zmap03";

NSString* NII_EXT = @".nii";

NSString* T1_OUT_DIR = @"/Users/oliver/test/reg3d_test_t1out/";
NSString* MNI_LIPSIA_OUT_DIR = @"/Users/oliver/test/reg3d_test_Lipsia-MNI_out/";



NSString* fctFile = @"/Users/oliver/test/reg3d_test/dataset01/data_10timesteps.nii";
NSString* anaFile = @"/Users/oliver/test/reg3d_test/dataset01/ana.nii"; //_visotrop.nii";

NSString* mniFile = @"/Users/oliver/test/reg3d_test/mni_lipsia.nii";
NSString* t1File  = @"/Users/oliver/test/reg3d_test/T1.nii";

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

/* ### Zmaps ### */
NSString* dataset01zmap = @"/Users/oliver/test/reg3d_test/dataset01/zmap02_11timesteps.nii";
NSString* OZzmap01 = @"/Users/oliver/test/reg3d_test_scansoliver/zmap01_10timesteps.nii";
NSString* OZzmap02 = @"/Users/oliver/test/reg3d_test_scansoliver/zmap02_10timesteps.nii";
NSString* OZzmap03 = @"/Users/oliver/test/reg3d_test_scansoliver/zmap03_10timesteps.nii";



/* # Function declarations # */

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset);

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset,
                      NSString* mni);

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset,
                      NSString* mni,
                      NSString* ext);

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

void testZmapsParams(NSString* funPath,
                     NSString* anaPath,
                     NSString* mapPath,
                     int runs,
                     NSString* outPath);

void testITK4RegistrationExample3Params(NSString* funPath,
                                        NSString* anaPath,
                                        NSString* mniPath,
                                        int runs,
                                        NSString* outPath);

void testRegistrationITK4Params(NSString* funPath,
                                NSString* anaPath,
                                NSString* mniPath,
                                int runs,
                                NSString* outPath);

enum RegistrationMethod {
    VNORMDATA_MNI = 0,
    VNORMDATA_T1,
    BART_MNI,
    BART_T1,
    BART_ANAONLY
};

void testITK4RuntimeParams(NSString* funPath,
                           NSString* anaPath,
                           NSString* mniPath,
                           NSString* outPath,
                           enum RegistrationMethod method,
                           int runs);



/* # Function definitions # */

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset)
{
    return [NSString stringWithFormat:@"%@%@%@%@", baseDir, method, dataset, NII_EXT];
}

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset,
                      NSString* mni)
{
    return [NSString stringWithFormat:@"%@%@%@%@%@", baseDir, method, dataset, mni, NII_EXT];
}

NSString* outFileName(NSString* baseDir,
                      NSString* method,
                      NSString* dataset,
                      NSString* mni,
                      NSString* ext)
{
    return [NSString stringWithFormat:@"%@%@%@%@%@", baseDir, method, dataset, mni, ext];
}

void testVnormdataRegistrationWorkflow()
{
    int runs = RUNS;
    NSString* dir = @"/tmp/"; // [NSString stringWithFormat:@"%@%@", MNI_LIPSIA_OUT_DIR, @"itk4/"];
    NSString* mni = t1File;
    
    testVnormdataRegistrationWorkflowParams(fctFile,
                                            anaFile,
                                            mni,
                                            runs,
                                            outFileName(dir, BART_VNORMDATA, DS01));
    
//    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ00ana, mni, runs, outFileName(dir, BART_VNORMDATA, ONE_TS_MDEFT));
//    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ10ana, mni, runs, outFileName(dir, BART_VNORMDATA, ONE_TS_MPRAGE));
//    
//    testVnormdataRegistrationWorkflowParams(OZ00fun, OZ00ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ00));
//    testVnormdataRegistrationWorkflowParams(OZ01fun, OZ01ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ01));
//    testVnormdataRegistrationWorkflowParams(OZ02fun, OZ02ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ02));
//    testVnormdataRegistrationWorkflowParams(OZ03fun, OZ03ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ03));
//    testVnormdataRegistrationWorkflowParams(OZ10fun, OZ10ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ10));
//    testVnormdataRegistrationWorkflowParams(OZ11fun, OZ11ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ11));
//    testVnormdataRegistrationWorkflowParams(OZ12fun, OZ12ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ12));
//    testVnormdataRegistrationWorkflowParams(OZ13fun, OZ13ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ13));
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
    NSString* dir = T1_OUT_DIR;
    NSString* mni = t1File;

    testBARTRegistrationWorkflowParams(fctFile, 
                                       anaFile, 
                                       mni, 
                                       runs, 
                                       outFileName(dir, BART_REG, DS01));
    
    testBARTRegistrationWorkflowParams(OZfun1ts, OZ00ana, mni, runs, outFileName(dir, BART_REG, ONE_TS_MDEFT));
    testBARTRegistrationWorkflowParams(OZfun1ts, OZ10ana, mni, runs, outFileName(dir, BART_REG, ONE_TS_MPRAGE));
    
    testBARTRegistrationWorkflowParams(OZ00fun, OZ00ana, mni, runs, outFileName(dir, BART_REG, OZ00));
    testBARTRegistrationWorkflowParams(OZ01fun, OZ01ana, mni, runs, outFileName(dir, BART_REG, OZ01));
    testBARTRegistrationWorkflowParams(OZ02fun, OZ02ana, mni, runs, outFileName(dir, BART_REG, OZ02));
    testBARTRegistrationWorkflowParams(OZ03fun, OZ03ana, mni, runs, outFileName(dir, BART_REG, OZ03));
    testBARTRegistrationWorkflowParams(OZ10fun, OZ10ana, mni, runs, outFileName(dir, BART_REG, OZ10));
    testBARTRegistrationWorkflowParams(OZ11fun, OZ11ana, mni, runs, outFileName(dir, BART_REG, OZ11));
    testBARTRegistrationWorkflowParams(OZ12fun, OZ12ana, mni, runs, outFileName(dir, BART_REG, OZ12));
    testBARTRegistrationWorkflowParams(OZ13fun, OZ13ana, mni, runs, outFileName(dir, BART_REG, OZ13));
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
    
//    testBARTRegistrationAnaOnlyParams(OZfun1ts, OZ00ana, runs, bartRegAnaOnlyOut);
//    testBARTRegistrationAnaOnlyParams(OZfun1ts, OZ10ana, runs, bartRegAnaOnlyOut);
//    
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

void testZmaps()
{
//    axial64x64
//    beide anatomie
//    dataset01    
    int runs = RUNS;
    
    testZmapsParams(fctFile, anaFile, dataset01zmap, runs, outFileName(@"/Users/oliver/test/reg3d_test/dataset01/",
                                                                       ZMAP_BASE_DS01,
                                                                       @""));

    testZmapsParams(OZ01fun, OZ01ana, OZzmap01, runs, outFileName(@"/Users/oliver/test/reg3d_test_scansoliver/", ZMAP_BASE, ZMAP01));
    testZmapsParams(OZ11fun, OZ11ana, OZzmap01, runs, outFileName(@"/Users/oliver/test/reg3d_test_scansoliver/", ZMAP_BASE, ZMAP01));
    
    testZmapsParams(OZ01fun, OZ01ana, OZzmap03, runs, outFileName(@"/Users/oliver/test/reg3d_test_scansoliver/", ZMAP_BASE, ZMAP03));
    testZmapsParams(OZ11fun, OZ11ana, OZzmap03, runs, outFileName(@"/Users/oliver/test/reg3d_test_scansoliver/", ZMAP_BASE, ZMAP03));
    
}

void testZmapsParams(NSString* funPath,
                     NSString* anaPath,
                     NSString* mapPath,
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
        
        EDDataElementIsis* mapData = [[EDDataElementIsis alloc] initWithFile:mapPath 
                                                                   andSuffix:@"" 
                                                                  andDialect:@"" 
                                                                 ofImageType:IMAGE_ZMAP];
        forceMemoryLoad = [mapData getMinMaxOfDataElement];
        
        aliStart = now(); // RUNTIME ANALYSIS CODE #
        
        RORegistrationMethod* method = [[RORegistrationBARTAnaOnly alloc] initFindingTransform:fctData
                                                                                       anatomy:anaData
                                                                                     reference:nil];
        aliEnd = now();   // RUNTIME ANALYSIS CODE #
        
        EDDataElement* map2ana = [method apply:mapData];
        
        appEnd = now();   // RUNTIME ANALYSIS CODE #
        diff = newTimeDiff(&aliStart, &aliEnd); // #
        alignTime += asDouble(diff);            // #
        free(diff);                             // #
        diff = newTimeDiff(&aliEnd, &appEnd);   // #
        applyTime += asDouble(diff);            // #
        free(diff);       // RUNTIME ANALYSIS CODE #
        
        [map2ana WriteDataElementToFile:outPath];
        
        [method release];
        
        [mapData release];
        [anaData release];
        [fctData release];
        
        [pool drain];
        
    }
    alignTime /= static_cast<double>(runs);
    applyTime /= static_cast<double>(runs);
    NSLog(@"Runtime BART_zmap for %d runs. Fun: %@ ana: %@ out: %@. Registration: %lf s, application: %lf s\n", 
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

void testITK4RegistrationExample3()
{
    int runs = 1;
    NSString* mni = t1File;
    
//    NSLog(anaFile);
//    NSLog(mni);

    testITK4RegistrationExample3Params(fctFile,
                                       anaFile,
                                       mni,
                                       runs,
                                       @"/tmp/itk4_regtest_out.nii");
}

void testITK4RegistrationExample3Params(NSString* funPath,
                                        NSString* anaPath,
                                        NSString* mniPath,
                                        int runs,
                                        NSString* outPath)
{
    // ImageRegistration3.cxx
    
    EDDataElementIsis* fctData = [[EDDataElementIsis alloc] initWithFile:funPath
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_FCTDATA];
    ITKImage::Pointer fctDataITK = [fctData asITKImage];
    
    EDDataElementIsis* anaData = [[EDDataElementIsis alloc] initWithFile:anaPath
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    ITKImage::Pointer anaDataITK = [anaData asITKImage];
    
    EDDataElementIsis* mniData = [[EDDataElementIsis alloc] initWithFile:mniPath
                                                               andSuffix:@"" 
                                                              andDialect:@"" 
                                                             ofImageType:IMAGE_ANADATA];
    ITKImage::Pointer mniDataITK = [mniData asITKImage];

    typedef itk::TranslationTransform< double, IMAGE_DIMENSION > TransformType;
    
    typedef itk::RegularStepGradientDescentOptimizer       OptimizerType;
    
    typedef itk::LinearInterpolateImageFunction<ITKImage, double> InterpolatorType;
    
    typedef itk::ImageRegistrationMethod<ITKImage, ITKImage>  RegistrationType;
    
    typedef itk::MattesMutualInformationImageToImageMetric<ITKImage,
    ITKImage >  MetricType;
    
    TransformType::Pointer      transform     = TransformType::New();
    OptimizerType::Pointer      optimizer     = OptimizerType::New();
    InterpolatorType::Pointer   interpolator  = InterpolatorType::New();
    RegistrationType::Pointer   registration  = RegistrationType::New();
    
    registration->SetOptimizer(     optimizer     );
    registration->SetTransform(     transform     );
    registration->SetInterpolator(  interpolator  );
    
    MetricType::Pointer      metric = MetricType::New();
    
    registration->SetMetric( metric );
    
    registration->SetFixedImage( mniDataITK);
    registration->SetMovingImage(anaDataITK);
 
    registration->SetFixedImageRegion(mniDataITK->GetBufferedRegion() );
    
    typedef RegistrationType::ParametersType ParametersType;
    ParametersType initialParameters( transform->GetNumberOfParameters() );
    
    initialParameters[0] = 0.0;  // Initial offset in mm along X
    initialParameters[1] = 0.0;  // Initial offset in mm along Y
    
    registration->SetInitialTransformParameters( initialParameters );
    
    optimizer->SetMaximumStepLength( 4.00 );
    optimizer->SetMinimumStepLength( 0.01 );
    optimizer->SetNumberOfIterations( 200 );
    
    optimizer->MaximizeOff();

    try
    {
        registration->Update();
        std::cout << "Optimizer stop condition: "
        << registration->GetOptimizer()->GetStopConditionDescription()
        << std::endl;
    }
    catch( itk::ExceptionObject & err )
    {
        std::cout << "ExceptionObject caught !" << std::endl;
        std::cout << err << std::endl;
    }

    
    
    ParametersType finalParameters = registration->GetLastTransformParameters();
    
    const double TranslationAlongX = finalParameters[0];
    const double TranslationAlongY = finalParameters[1];
    
    const unsigned int numberOfIterations = optimizer->GetCurrentIteration();
    
    const double bestValue = optimizer->GetValue();
    
    std::cout << "Registration done !" << std::endl;
    std::cout << "Number of iterations = " << numberOfIterations << std::endl;
    std::cout << "Translation along X  = " << TranslationAlongX << std::endl;
    std::cout << "Translation along Y  = " << TranslationAlongY << std::endl;
    std::cout << "Optimal metric value = " << bestValue << std::endl;
    
    
    // Prepare the resampling filter in order to map the moving image.
    //
    typedef itk::ResampleImageFilter<ITKImage, ITKImage >    ResampleFilterType;
    
    TransformType::Pointer finalTransform = TransformType::New();
    
    finalTransform->SetParameters( finalParameters );
    finalTransform->SetFixedParameters( transform->GetFixedParameters() );
    
    ResampleFilterType::Pointer resample = ResampleFilterType::New();
    
    resample->SetTransform( finalTransform );
    resample->SetInput( anaDataITK );
    
    ITKImage::Pointer fixedImage = mniDataITK;
    
    resample->SetSize(    fixedImage->GetLargestPossibleRegion().GetSize() );
    resample->SetOutputOrigin(  fixedImage->GetOrigin() );
    resample->SetOutputSpacing( fixedImage->GetSpacing() );
    resample->SetOutputDirection( fixedImage->GetDirection() );
    resample->SetDefaultPixelValue( 100 );
    
    
    resample->Update();
    
    EDDataElement* aligned = [anaData convertFromITKImage:resample->GetOutput()];
    
    [aligned WriteDataElementToFile:outPath];
    
    
//    // Prepare a writer and caster filters to send the resampled moving image to
//    // a file
//    //
//    typedef  unsigned char  OutputPixelType;
//    
//    typedef itk::Image< ITKImagePixelType, IMAGE_DIMENSION > OutputImageType;
//    
//    typedef itk::CastImageFilter<
//    ITKImage,
//    ITKImage > CastFilterType;
//    
//    
//    CastFilterType::Pointer  caster =  CastFilterType::New();
//    
//
//    caster->SetInput( resample->GetOutput() );
//    writer->SetInput( caster->GetOutput()   );
//    writer->Update();


}


void testITK4Runtime()
{
    ROTestUtil* util = [[ROTestUtil alloc] init];
    [util redirect:stderr to:@"/Users/olli/tmp/BART_isis_test_release_ITK4_runtime.txt" using:@"w"];
    [util release];
    
    int runs = 20;
    
    // Base directories
    NSString* data_dir = @"/Users/olli/BART_testdata/TROY_ITK4_runtime/";
    NSString* out_dir = @"/Users/olli/tmp/";
    
    NSArray* mniTemplates = [NSArray arrayWithObjects:@"mni_lipsia.nii", @"T1_spm.nii", nil];
    
    NSArray* methodNames = [NSArray arrayWithObjects:@"Vnormdata_mni_lipsia", @"Vnormdata_T1_spm", @"BARTReg_mni_lipsia", @"BARTReg_T1_spm", @"BARTRegAnaOnly", nil];
    
    // dataset oliver
    NSArray* ozAnas = [NSArray arrayWithObjects:@"14265.5c_ana_mdeft.nii", @"14265.5c_ana_mprage.nii", nil];
    NSArray* ozFuns = [NSArray arrayWithObjects:@"14265.5c_fun_axial_128x128.nii", @"14265.5c_fun_axial_64x64.nii", @"14265.5c_fun_coronar_64x64.nii", nil];
    //@"14265.5c_fun_sagittal_64x64.nii", nil]; // crashes with sagittal image!
    NSString* ozFun1TS = @"14265.5c_fun_axial_64x64_just1timestep.nii";
    
    // dataset03
    NSString* ds03_ana = @"dataset03/09556.72_ana_mprage.nii";
    NSString* ds03_fun = @"dataset03/09556.72_fun_axial_64x64_10timesteps.nii";
    
    for (NSUInteger method = 0; method < [methodNames count]; method++) {
        for (NSUInteger ana = 0; ana < [ozAnas count]; ana++) {
            for (NSUInteger fun = 0; fun < [ozFuns count]; fun++) {
                testITK4RuntimeParams([data_dir stringByAppendingString:[ozFuns objectAtIndex:fun]],
                                      [data_dir stringByAppendingString:[ozAnas objectAtIndex:ana]],
                                      [data_dir stringByAppendingString:[mniTemplates objectAtIndex:method % 2]],
                                      [NSString stringWithFormat:@"%@out_OZ%ld%ld_%@_ITK4_2_1_isis_test_release.nii", out_dir, ana, fun, [methodNames objectAtIndex:method]],
                                      (enum RegistrationMethod) method,
                                      runs);
            }
            
            // 1 timestep
            testITK4RuntimeParams([data_dir stringByAppendingString:ozFun1TS],
                                  [data_dir stringByAppendingString:[ozAnas objectAtIndex:ana]],
                                  [data_dir stringByAppendingString:[mniTemplates objectAtIndex:method % 2]],
                                  [NSString stringWithFormat:@"%@out_OZ1TS%ld_%@_ITK4_2_1_isis_test_release.nii", out_dir, ana, [methodNames objectAtIndex:method]],
                                  (enum RegistrationMethod) method,
                                  runs);
        }
        
        // dataset03
        testITK4RuntimeParams([data_dir stringByAppendingString:ds03_fun],
                              [data_dir stringByAppendingString:ds03_ana],
                              [data_dir stringByAppendingString:[mniTemplates objectAtIndex:method % 2]],
                              [NSString stringWithFormat:@"%@out_dataset03_%@_ITK4_2_1_isis_test_release.nii", out_dir, [methodNames objectAtIndex:method]],
                              (enum RegistrationMethod) method,
                              runs);
    }

}

void testITK4RuntimeParams(NSString* funPath,
                           NSString* anaPath,
                           NSString* mniPath,
                           NSString* outPath,
                           enum RegistrationMethod method,
                           int runs)
{
    ROTestUtil* util = [[ROTestUtil alloc] init];
    RORegistrationMethod* methodObj = nil;
    
    switch (method) {
        case VNORMDATA_MNI:
        case VNORMDATA_T1:
            methodObj = [RORegistrationVnormdata alloc];
            break;
        case BART_MNI:
        case BART_T1:
            methodObj = [RORegistrationBART alloc];
            break;
        case BART_ANAONLY:
            methodObj = [RORegistrationBARTAnaOnly alloc];
            break;
        default:
            break;
    }
    
    if (methodObj != nil) {
        [util measureRegistrationRuntime:funPath
                                 anatomy:anaPath
                                     mni:mniPath
                                     out:outPath
                            registration:methodObj
                                    runs:runs];
        [methodObj release];
    }
    
    [util release];
}

int main(void)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    /* # Output redirection # */
//    system("rm -f /tmp/BART_regRuntime.txt");
//    freopen("/tmp/BART_regRuntime.txt", "a", stderr);
    
    /* # General Isis tests # */
//    testAdapterConversion();
//    testMemoryAdapter();
//    testPluginReadWrite();

    /* # Registration tests # */
//    testBARTRegistrationAnaOnly();
//    testBARTRegistrationWorkflow();
//    testVnormdataRegistrationWorkflow();
    
    /* # Zmap tests # */
//    testZmaps();
    
    /* # ITK 4 tests # */
//    testITK4RegistrationExample3();
    testITK4Runtime();
    
//    testVnormdataRegistrationWorkflowParams(fctFile,
//                                            anaFile,
//                                            mniFile,
//                                            1,
//                                            @"/tmp/BART_ITK4vnormdata.nii");

    [pool drain];
}