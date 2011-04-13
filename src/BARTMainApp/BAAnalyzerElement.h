//
//  BAAnalyzerElement.h
//  BARTCommandLine
//
//  Created by First Last on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class BASource;
@class BAElement;
@class BADesignElement;
@class BADataElement;


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
-(BADataElement*)anaylzeTheData:(BADataElement*)data 
                     withDesign:(BADesignElement*) design
			  atCurrentTimestep:(size_t)timestep
			  forContrastVector:(NSArray*)contrastVector
			 andWriteResultInto:(BADataElement*)resData;


-(void)sendFinishNotification;

@end

#pragma mark -

@interface BAAnalyzerElement (SubclassUseOnly)

// Private, concrete methods used by subclasses:
-(void)whatever:(BOOL) findParameters;
-(void)setDataToAnalyze:(BASource*) src;

@end