//
//  RTAnalysisExperiment.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 8/6/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RTAnalysisExperiment.h"

@implementation RTAnalysisExperiment


+ (NSString*)typeDisplayName
{
    return @"RT Analysis";
}

+ (NSString*)typeDescription
{
    return @"RT Analysis Experiment Description";
}

+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
{
    self = [super experimentWithEDL:edl name:name description:description];
    
    if(self) {
        NSLog(@"[RTAnalysisExperiment] initialization started ...");
        NSLog(@"[RTAnalysisExperiment] EDL: %@", edl);
        NSLog(@"[RTAnalysisExperiment] EDL node count: %lu", [[(BAExperiment2*)self edl] countNodes:@"*/*/*"]);
    }
    
    return self;
}

@end
