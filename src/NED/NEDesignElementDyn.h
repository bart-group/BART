//
//  NEDesignElementDyn.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef NEDESIGNELEMENTDYN_H
#define NEDESIGNELEMENTDYN_H

#import <Cocoa/Cocoa.h>
#import "NEDesignElement.h"
#import <fftw3.h>
#import "NEDesignKernel.h"

typedef struct ComplexStruct {
    double re;
    double im;
} Complex;

typedef struct RegressorStruct {
	TrialList *regTrialList;
	unsigned int regDerivations;
	NSString *regID;
	NSString *regDescription;
	NEDesignKernel *regConvolKernel;
} TRegressor;

@interface NEDesignElementDyn : NEDesignElement {

	TRegressor **mRegressorList;
    unsigned int mNumberEvents;
	unsigned long mNumberSamplesForInit;
	unsigned long mNumberSamplesNeededForExp;
	double *mTimeOfRepetitionStartInMs;
	/* Generated design information/resulting design image. */
	float** mRegressorValues;
	float** mCovariateValues;
	
	/*buffers for input and output of fft*/
	double **mBuffersForwardIn; // one per each event
	double **mBuffersInverseOut; // one per each event
	fftw_complex **mBuffersForwardOut; // Resulting HRFs (one per Event).
	fftw_complex **mBuffersInverseIn; 
	
	/*plans for fft*/
	fftw_plan *mFftPlanForward;
	fftw_plan *mFftPlanInverse;
	
	BOOL mDesignHasChanged;
    
    
}

-(void)copyValuesOfFinishedDesign:(float**)copyFromR andCovariates:(float**)copyFromC;
-(NSError*)generateDesign;




@end

#pragma mark -

@interface NEDesignElementDyn (PrivateMethods)

-(id)initWithConfig:(COSystemConfig*)config;
-(NSError*)parseInputFile:(NSString*)path;
-(NSError*)initDesign;
-(Complex)multiplComplex:(Complex)a withComplex:(Complex) b;
-(BOOL)test_ascii:(int)val;
-(void)Convolve:(unsigned int)col
			   :(unsigned int) eventNr
               :(fftw_complex *)fkernel;

/* Utility function for TrialList. */
-(void)tl_append:(TrialList*)head
                :(TrialList*)newLast;

-(NSError*)getPropertiesFromConfig:(COSystemConfig*)config;

-(NSError*)correctForZeromean;
-(void)initRegressorValues;
-(void)initCovariateValues;



@end

#endif //NEDESIGNELEMENTDYN_H
