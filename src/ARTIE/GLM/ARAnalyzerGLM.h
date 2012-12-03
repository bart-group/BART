//
//  ARAnalyzerGLM.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef ARANALYZERELEMENTGLM_H
#define ARANALYZERELEMENTGLM_H

#import <Cocoa/Cocoa.h>
#import "../ARAnalyzerElement.h"

// strange MAXKONSTANTEN aus vcolorglm - sicherheitshalber noch da - Test notwendig
#define ETMP     64   /* max number of temporary images for smoothness estim */
#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */


@interface ARAnalyzerGLM : ARAnalyzerElement {
    
    NEDesignElement *mDesign;
    EDDataElement *mData;
    
   // EDDataElement *mBetaOutput;
   // EDDataElement *mResOutput;
   // EDDataElement *mResMap;
   // EDDataElement *mBCOVOutput;
    // EDDataElement *mKXOutput;
    uint slidingWindowSize;
	BOOL mSlidingWindowAnalysis;
	short mMinval; 
	
}

//TODO : get from config

@property(readwrite) uint slidingWindowSize;
@property(readwrite) BOOL mSlidingWindowAnalysis;
@property(readwrite) short mMinval;


@end

#endif //ARANALYZERELEMENTGLM_H

