//
//  BADesignElementDyn.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BADesignElement.h"
#import <fftw3.h>
#import "NEDesignKernel.h"

typedef struct ComplexStruct {
    double re;
    double im;
} Complex;


@interface NEDesignElementDyn : BADesignElement {

    TrialList** mTrialList;
    unsigned int mNumberEvents;
	
	unsigned int mDerivationsHrf;
	//float mBlockThreshold; // in seconds
	unsigned long mNumberSamplesForInit;
	unsigned long mNumberSamplesNeededForExp;
	double *mTimeOfRepetitionStartInMs;
	
	/* Generated design information/resulting design image. */
	float** mDesign;
	float** mCovariates;
	
	/*buffers for input and output of fft*/
	double **mBuffersForwardIn; // one per each event
	double **mBuffersInverseOut; // one per each event
	fftw_complex **mBuffersForwardOut; // Resulting HRFs (one per Event).
	fftw_complex **mBuffersInverseIn; 
	
	/*plans for fft*/
	fftw_plan *mFftPlanForward;
	fftw_plan *mFftPlanInverse;
	
	// the kernels to convolve with the event trials
	NEDesignKernel **mConvolutionKernels; //one per each event
	
	BOOL mDesignHasChanged;
}

-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;
-(void)copyValuesOfFinishedDesign:(float**)copyFromR andCovariates:(float**)copyFromC;
-(NSError*)generateDesign;
-(void)copyValuesOfFinishedDesign:(float**)copyFromR andCovariates:(float**)copyFromC;

@property (readonly) BOOL mDesignHasChanged;
@property TrialList** mTrialList;

@end

#pragma mark -

@interface NEDesignElementDyn (PrivateMethods)

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

-(NSError*)getPropertiesFromConfig;

-(NSError*)correctForZeromean;

@end

