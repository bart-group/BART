//
//  BAAnalyzerGLMReference.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/31/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../../src/BARTMainApp/BADataElement.h"
#import "../../src/BARTMainApp/BADesignElement.h"
#import "../../src/BARTMainApp/BAAnalyzerElement.h"

#define MBETA    64   /* max number of covariates */
@interface BAAnalyzerGLMReference : BAAnalyzerElement {

	
	BADesignElement *mDesign;
    BADataElement *mData;
    
    BADataElement *mBetaOutput;
    BADataElement *mResOutput;
    BADataElement *mResMap;
    BADataElement *mBCOVOutput;
    
	uint mSlidingWindowSize;
	BOOL mSlidingWindowAnalysis;
	uint mFwhm;
	uint mMinval;
}

@property uint mSlidingWindowSize;
@property BOOL mSlidingWindowAnalysis;
@property uint mFwhm;
@property uint mMinval;

-(id)initWithFwhm:(uint) fwhm andMinval:(uint)minval forSlidingAnalysis:(BOOL)swa withSize:(uint)sws;


@end
