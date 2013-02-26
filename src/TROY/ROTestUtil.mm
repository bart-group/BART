//
//  ROTestUtil.m
//  BARTApplication
//
//  Created by Oliver Zscheyge on 2/8/13.
//  Copyright (c) 2013 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "ROTestUtil.h"

#import "EDDataElementIsis.h"

#import "RORegistrationMethod.h"

#import "TimeUtil.h"

@implementation ROTestUtil

-(id)init
{
    if (self = [super init]) {
    }
    
    return self;
}

-(void)redirect:(FILE*)stream
             to:(NSString*)filepath
          using:(NSString*)mode
{
    freopen([filepath UTF8String], [mode UTF8String], stream);
}

-(NSArray*)measureRegistrationRuntime:(NSString*)funPath
                              anatomy:(NSString*)anaPath
                                  mni:(NSString*)mniPath
                                  out:(NSString*)outPath
                         registration:(RORegistrationMethod*)method
                                 runs:(int)runs
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
        
        EDDataElementIsis* mniData = nil;
        if ([mniPath length] > 0) {
            mniData = [[EDDataElementIsis alloc] initWithFile:mniPath
                                                    andSuffix:@""
                                                   andDialect:@""
                                                  ofImageType:IMAGE_ANADATA];
        }
        
        aliStart = now(); // RUNTIME ANALYSIS CODE #
        
        method = [method initFindingTransform:fctData
                                      anatomy:anaData
                                    reference:mniData];
        
        aliEnd = now();   // RUNTIME ANALYSIS CODE #
        
        EDDataElement* result = [method apply:fctData];
        
        appEnd = now();   // RUNTIME ANALYSIS CODE #
        diff = newTimeDiff(&aliStart, &aliEnd); // #
        alignTime += asDouble(diff);            // #
        free(diff);                             // #
        diff = newTimeDiff(&aliEnd, &appEnd);   // #
        applyTime += asDouble(diff);            // #
        free(diff);       // RUNTIME ANALYSIS CODE #
        
        if ([outPath length] > 0) {
            [result WriteDataElementToFile:outPath];
        }
        
        if (mniData != nil) {
            [mniData release];
        }
        
        [anaData release];
        [fctData release];
        
        [pool drain];
    }
    
    if (runs > 0) {
        alignTime /= static_cast<double>(runs);
        applyTime /= static_cast<double>(runs);
    }
    
    NSLog(@"Runtime for %d runs. Method: %@ fun: %@ ana: %@ mni: %@ out: %@. Registration: %lf s, application: %lf s",
          runs, NSStringFromClass([method class]), funPath, anaPath, mniPath, outPath, alignTime, applyTime);
    
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:alignTime], [NSNumber numberWithFloat:applyTime], nil];
}

-(EDDataElement*)createDiffImage:(EDDataElement*)a
                                :(EDDataElement*)b
{
    BARTImageSize* aSize = [a getImageSize];
    BARTImageSize* bSize = [b getImageSize];
    
    if (aSize.rows      == bSize.rows      and
        aSize.columns   == bSize.columns   and
        aSize.slices    == bSize.slices    and
        aSize.timesteps == bSize.timesteps and
        a.mImageType    == b.mImageType) {
        
        EDDataElement* diffImg = [[EDDataElement alloc] initEmptyWithSize:aSize ofImageType:a.mImageType];
        
        for (size_t ts = 0; ts < aSize.timesteps; ts++) {
            for (size_t slice = 0; slice < aSize.slices; slice++) {
                for (size_t row = 0; row < aSize.rows; row++) {
                    for (size_t col = 0; col < aSize.columns; col++) {
                        float aVal = [a getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                        float bVal = [a getFloatVoxelValueAtRow:row col:col slice:slice timestep:ts];
                        
                        float diffVal = aVal - bVal;
                        NSNumber* diffValNumber = [NSNumber numberWithFloat:diffVal];
                        [diffImg setVoxelValue:diffValNumber atRow:row col:col slice:slice timestep:ts];
                    }
                }
            }
        }
        
        return diffImg;
    }
    
    return nil;
}

@end
