//
//  ARAnalyzerElement.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/14/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef ARANALYZERELEMENT_H
#define ARANALYZERELEMENT_H

#import <Cocoa/Cocoa.h>


@class BAElement;
@class NEDesignElement;
@class EDDataElement;


// Supported Analyzer types:
static NSString *const kAnalyzerGLM = @"GLM";
static NSString *const kAnalyzerPluginNameKey = @"AnalyzerPluginName";
static NSString *const kAnalyzerPluginAnalyzerTypeKey = @"AnalyzerPluginType";


@interface ARAnalyzerElement : NSObject

{
   
}
    


+ (id)searchPluginWithAnalyzerType:(NSString *) analyzerType;

- (id)initWithAnalyzerType:(NSString *) analyzerType;

-(BOOL)parseSearchAnalyzerElementAtPath:(NSString *)searchAnalyzerPath;

-(NSString *)searchAnalyzerElement;

@end

#pragma mark -

@interface ARAnalyzerElement (AbstractMethods)

// abstract methods to be implemented by subclasses
-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
                     withDesign:(NEDesignElement*) design
			  atCurrentTimestep:(size_t)timestep
			  forContrastVector:(NSArray*)contrastVector
			 andWriteResultInto:(EDDataElement*)resData;


-(void)sendFinishNotification;


#pragma mark -



// Private, concrete methods used by subclasses:
-(void)whatever:(BOOL) findParameters;
-(void)setDataToAnalyze:(EDDataElement*) src;

@end

#endif //ARANALYZERELEMENT_H
