//
//  BAProcedurePipeline.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAProcedureStep_Paradigm.h"

@class EDDataElement;
@class NEDesignElement;
@class BAAnalyzerElement;
@class EDDataElementRealTimeLoader;
@class COSystemConfig;


@interface BAProcedurePipeline : NSObject {

	EDDataElement *mInputData;
    NEDesignElement *mDesignData;
    EDDataElement *mResultData;
    BAAnalyzerElement *mAnalyzer;
    size_t mCurrentTimestep;
    EDDataElementRealTimeLoader *mRtLoader;
    COSystemConfig *config;
    //TODO: define enum and take a switch where needed
    BOOL isRealTimeTCPInput;
    size_t startAnalysisAtTimeStep;
    BAProcedureStep_Paradigm *paradigm;
    

}


-(BOOL) initData;
-(BOOL) initDesign;
-(BOOL) initPresentation;
-(BOOL) initAnalyzer;
-(BOOL) startAnalysis;

@end
