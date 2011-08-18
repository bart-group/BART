//
//  BAAnalyzerGLMReference.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/31/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EDNA/EDDataElement.h"
#import "NED/NEDesignElement.h"


#define MBETA    64   /* max number of covariates */
@interface BAAnalyzerGLMReference : NSObject {

	
	NEDesignElement *mDesign;
    EDDataElement *mData;
    
    EDDataElement *mBetaOutput;
    EDDataElement *mResOutput;
    EDDataElement *mResMap;
    EDDataElement *mBCOVOutput;
    
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

-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
                     withDesign:(NEDesignElement*) design
             andCurrentTimestep:(size_t)timestep;


@end




