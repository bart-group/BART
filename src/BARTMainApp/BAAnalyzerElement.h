//
//  BAAnalyzerElement.h
//  BARTCommandLine
//
//  Created by First Last on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class BAElement;
@class NEDesignElement;
@class EDDataElement;


// Supported Analyzer types:
extern NSString *const kAnalyzerGLM;

@interface BAAnalyzerElement : NSObject

{
   
}
    


+ (id)searchPluginWithAnalyzerType:(NSString *) analyzerType;

- (id)initWithAnalyzerType:(NSString *) analyzerType;

-(BOOL)parseSearchAnalyzerElementAtPath:(NSString *)searchAnalyzerPath;

-(NSString *)searchAnalyzerElement;

@end

#pragma mark -

@interface BAAnalyzerElement (AbstractMethods)

// abstract methods to be implemented by subclasses
-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
                     withDesign:(NEDesignElement*) design
			  atCurrentTimestep:(size_t)timestep
			  forContrastVector:(NSArray*)contrastVector
			 andWriteResultInto:(EDDataElement*)resData;


-(void)sendFinishNotification;

@end

#pragma mark -

@interface BAAnalyzerElement (SubclassUseOnly)

// Private, concrete methods used by subclasses:
-(void)whatever:(BOOL) findParameters;
-(void)setDataToAnalyze:(EDDataElement*) src;

@end