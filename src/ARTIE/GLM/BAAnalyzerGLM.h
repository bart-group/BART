//
//  BAAnalyzerGLM.h
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../../BARTMainApp/BAAnalyzerElement.h"

// strange MAXKONSTANTEN aus vcolorglm - sicherheitshalber noch da - Test notwendig
#define ETMP     64   /* max number of temporary images for smoothness estim */
#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */


@interface BAAnalyzerGLM : BAAnalyzerElement {
    
    BADesignElement *mDesign;
    BADataElement *mData;
    
    BADataElement *mBetaOutput;
    BADataElement *mResOutput;
    BADataElement *mResMap;
    BADataElement *mBCOVOutput;
    // BADataElement *mKXOutput;
    uint slidingWindowSize;
	BOOL mSlidingWindowAnalysis;
	short mMinval; 
	
}

//TODO : get from config

@property(readwrite) uint slidingWindowSize;
@property(readwrite) BOOL mSlidingWindowAnalysis;
@property(readwrite) short mMinval;


@end
