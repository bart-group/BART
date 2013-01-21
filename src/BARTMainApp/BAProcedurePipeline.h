//
//  BAProcedurePipeline.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef BAPROCEDUREPIPELINE_H
#define BAPROCEDUREPIPELINE_H

#import <Cocoa/Cocoa.h>
#import "BAProcedureStep_Paradigm.h"
#import "COExperimentContext.h"

@class EDDataElement;
//@class NEDesignElement;
@class ARAnalyzerElement;
@class EDDataElementRealTimeLoader;
@class PRPreprocessor;


@interface BAProcedurePipeline : NSObject <BARTScannerTriggerProtocol> {

	EDDataElement *mInputData;
    //NEDesignElement *mDesignData;
    EDDataElement *mResultData;
    ARAnalyzerElement *mAnalyzer;
    PRPreprocessor *mPreprocessor;
    size_t mCurrentTimestep;
    EDDataElementRealTimeLoader *mRtLoader;
    COSystemConfig *config;
    //TODO: define enum and take a switch where needed
    BOOL isRealTimeTCPInput;
    size_t startAnalysisAtTimeStep;
    BAProcedureStep_Paradigm *paradigm;
    NSString *testDataFileName;
    

}

-(id)initWithTestDataset:(NSString*)testData;


-(BOOL) initData;
//-(BOOL) initDesign;
-(BOOL) initParadigm;
-(BOOL) initPreprocessor;
-(BOOL) initAnalyzer;
-(BOOL) startAnalysis;


@end

#endif //BAPROCEDUREPIPELINE_H
