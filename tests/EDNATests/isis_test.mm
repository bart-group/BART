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

NSString* T1_OUT_DIR = @"/Users/Lydi/RealTimeProject/data/Testdata_Registration/TROYTests/";

NSString *testfilePath = @"/Users/Lydi/RealTimeProject/data/Testdata_Registration/TROYTests/";

NSString* fctFile = nil;
NSString* anaFile = nil;

NSString* mniFile = nil;
NSString* t1File  = nil;

NSString* OZfun1ts =nil;

NSString* OZ00fun = nil;
NSString* OZ00ana = nil;
NSString* OZ00out = nil;

NSString* OZ01fun = nil;
NSString* OZ01ana = nil;
NSString* OZ01out = nil;

NSString* OZ02fun = nil;
NSString* OZ02ana = nil;
NSString* OZ02out = nil;

NSString* OZ03fun = nil;
NSString* OZ03ana = nil;
NSString* OZ03out = nil;

NSString* OZ10fun = nil;
NSString* OZ10ana = nil;
NSString* OZ10out = nil;

NSString* OZ11fun = nil;
NSString* OZ11ana = nil;
NSString* OZ11out = nil;

NSString* OZ12fun = nil;
NSString* OZ12ana = nil;
NSString* OZ12out = nil;

NSString* OZ13fun = nil;
NSString* OZ13ana = nil;
NSString* OZ13out = nil;

/* ### Zmaps ### */
NSString* dataset01zmap = nil;
NSString* OZzmap01 = nil;
NSString* OZzmap02 = nil;
NSString* OZzmap03 = nil;



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
    NSString* dir = T1_OUT_DIR;
    NSString* mni = t1File;
    
    testVnormdataRegistrationWorkflowParams(fctFile,
                                            anaFile,
                                            mni,
                                            runs,
                                            outFileName(dir, BART_VNORMDATA, DS01));
    
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ00ana, mni, runs, outFileName(dir, BART_VNORMDATA, ONE_TS_MDEFT));
    testVnormdataRegistrationWorkflowParams(OZfun1ts, OZ10ana, mni, runs, outFileName(dir, BART_VNORMDATA, ONE_TS_MPRAGE));
    
    testVnormdataRegistrationWorkflowParams(OZ00fun, OZ00ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ00));
    testVnormdataRegistrationWorkflowParams(OZ01fun, OZ01ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ01));
    testVnormdataRegistrationWorkflowParams(OZ02fun, OZ02ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ02));
    testVnormdataRegistrationWorkflowParams(OZ03fun, OZ03ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ03));
    testVnormdataRegistrationWorkflowParams(OZ10fun, OZ10ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ10));
    testVnormdataRegistrationWorkflowParams(OZ11fun, OZ11ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ11));
    testVnormdataRegistrationWorkflowParams(OZ12fun, OZ12ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ12));
    testVnormdataRegistrationWorkflowParams(OZ13fun, OZ13ana, mni, runs, outFileName(dir, BART_VNORMDATA, OZ13));
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
    
//    testBARTRegistrationAnaOnlyParams(fctFile,
//                                      anaFile,
//                                      runs,
//                                      bartRegAnaOnlyOut);
    
    testBARTRegistrationAnaOnlyParams(OZfun1ts, OZ00ana, runs, bartRegAnaOnlyOut);
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
    
    testZmapsParams(fctFile, anaFile, dataset01zmap, runs, outFileName(testfilePath,
                                                                       ZMAP_BASE_DS01,
                                                                       @""));

    testZmapsParams(OZ01fun, OZ01ana, OZzmap01, runs, outFileName(testfilePath, ZMAP_BASE, ZMAP01));
    testZmapsParams(OZ11fun, OZ11ana, OZzmap01, runs, outFileName(testfilePath, ZMAP_BASE, ZMAP01));
    
    testZmapsParams(OZ01fun, OZ01ana, OZzmap03, runs, outFileName(testfilePath, ZMAP_BASE, ZMAP03));
    testZmapsParams(OZ11fun, OZ11ana, OZzmap03, runs, outFileName(testfilePath, ZMAP_BASE, ZMAP03));
    
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
        NSLog(@"FUNPATH: %@", funPath);
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
    NSString* fctFile = [testfilePath stringByAppendingPathComponent:@"data_10timesteps.nii"];
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
    NSString* anaFile = [testfilePath stringByAppendingPathComponent:@"ana.nii"]; //_visotrop.nii";
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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    
    fctFile = [testfilePath stringByAppendingPathComponent:@"data_10timesteps.nii"];
    anaFile = [testfilePath stringByAppendingPathComponent:@"ana.nii"]; //_visotrop.nii";
    
    mniFile = [testfilePath stringByAppendingPathComponent:@"mni_lipsia.nii"];
    t1File  = [testfilePath stringByAppendingPathComponent:@"T1.nii"];
    
    OZfun1ts = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_64x64_just1timestep.nii"];
    
    OZ00fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_128x128.nii"];
    OZ00ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mdeft.nii"];
    OZ00out = [testfilePath stringByAppendingPathComponent:@"OZ00out.nii"];
    
    OZ01fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_64x64.nii"];
    OZ01ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mdeft.nii"];
    OZ01out = [testfilePath stringByAppendingPathComponent:@"OZ01out.nii"];
    
    OZ02fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_coronar_64x64.nii"];
    OZ02ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mdeft.nii"];
    OZ02out = [testfilePath stringByAppendingPathComponent:@"OZ02out.nii"];
    
    OZ03fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_sagittal_64x64.nii"];
    OZ03ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mdeft.nii"];
    OZ03out = [testfilePath stringByAppendingPathComponent:@"OZ03out.nii"];
    
    OZ10fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_128x128.nii"];
    OZ10ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mprage.nii"];
    OZ10out = [testfilePath stringByAppendingPathComponent:@"OZ10out.nii"];
    
    OZ11fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_axial_64x64.nii"];
    OZ11ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mprage.nii"];
    OZ11out = [testfilePath stringByAppendingPathComponent:@"OZ11out.nii"];
    
    OZ12fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_coronar_64x64.nii"];
    OZ12ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mprage.nii"];
    OZ12out = [testfilePath stringByAppendingPathComponent:@"OZ12out.nii"];
    
    OZ13fun = [testfilePath stringByAppendingPathComponent:@"14265.5c_fun_sagittal_64x64.nii"];
    OZ13ana = [testfilePath stringByAppendingPathComponent:@"14265.5c_ana_mprage.nii"];
    OZ13out = [testfilePath stringByAppendingPathComponent:@"OZ13out.nii"];
    
    /* ### Zmaps ### */
    dataset01zmap = [testfilePath stringByAppendingPathComponent:@"zmap02_11timesteps.nii"];
    OZzmap01 = [testfilePath stringByAppendingPathComponent:@"zmap01_10timesteps.nii"];
    OZzmap02 = [testfilePath stringByAppendingPathComponent:@"zmap02_10timesteps.nii"];
    OZzmap03 = [testfilePath stringByAppendingPathComponent:@"zmap03_10timesteps.nii"];
    
    
    
    
    
    
    
    
    
    
    /* # Output redirection # */
   // system("rm -f /tmp/BART_regRuntime.txt");
   // freopen("/tmp/BART_regRuntime.txt", "a", stderr);
    
    /* # General Isis tests # */
//    testAdapterConversion();
//    testMemoryAdapter();
//    testPluginReadWrite();

    /* # Registration tests # */
//    testBARTRegistrationAnaOnly();
//    testBARTRegistrationWorkflow();
//    testVnormdataRegistrationWorkflow();
    
    /* # Zmap tests # */
    testZmaps();
    
    [pool drain];
}