//
//  BAAnalyzerElement.m
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/14/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAAnalyzerElement.h"

NSString *const kAnalyzerPluginNameKey = @"AnalyzerPluginName";
NSString *const kAnalyzerPluginAnalyzerTypeKey = @"AnalyzerPluginType";


NSString *const kAnalyzerGLM = @"GLM";

@implementation BAAnalyzerElement

static NSDictionary const *sSubclassToPluginTypeMap = nil;

+ (void)initialize
{
    // TODO: memory leak
    sSubclassToPluginTypeMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"BAAnalyzerGLM", kAnalyzerGLM, nil];
}

-(id)initWithAnalyzerType:(NSString *) analyzerType
{
    // return one object of concrete subclasses
    [self release];
   
    return [[[self class] searchPluginWithAnalyzerType:analyzerType] retain];
}

+(id)searchPluginWithAnalyzerType:(NSString *)analyzerType
{
    NSString *subclassForType = [sSubclassToPluginTypeMap objectForKey:analyzerType];
    if (subclassForType) {
        Class concreteAnalyzerSubclass = NSClassFromString(subclassForType);
        return [[[concreteAnalyzerSubclass alloc] init] autorelease];
    }
    return nil;
    
}

-(BOOL)parseSearchAnalyzerElementAtPath:(NSString *)searchAnalyzerPath
{
    return TRUE;
}

-(NSString *)searchAnalyzerElement
{
    return @"Test";
}

@end
