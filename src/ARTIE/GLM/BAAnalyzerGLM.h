//
//  BAAnalyzerGLM.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../../BARTMainApp/BAAnalyzerElement.h"

// strange MAXKONSTANTEN aus vcolorglm - sicherheitshalber noch da - Test notwendig
#define ETMP     64   /* max number of temporary images for smoothness estim */
#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */


@interface BAAnalyzerGLM : BAAnalyzerElement {
    
  //  NEDesignElement *mDesign;
  //  EDDataElement *mData;
    
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
