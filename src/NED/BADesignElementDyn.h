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

typedef struct ComplexStruct {
    double re;
    double im;
} Complex;


typedef struct GammaKernelListStruct {
	fftw_complex gammaKernel;
	struct GammaKernelListStruct *next;
} GammaKernelList;


@interface BADesignElementDyn : BADesignElement {

    TrialList** mTrialList;
    unsigned int mNumberTrials;
    unsigned int mNumberEvents;
	unsigned int mNumberRegressors;
	unsigned int mNumberCovariates;    

	unsigned int mDerivationsHrf;
	//float mBlockThreshold; // in seconds
	unsigned long mNumberSamplesForInit;
	unsigned long mNumberSamplesNeededForExp;
	double *mTimeOfRepetitionStartInMs;
	
	/* Generated design information/resulting design image. */
	float** mDesign;
	float** mCovariates;
	
	/* buffers for use with fftw3 for block design und eventrelated with derivations 0|1|2 */
	
	
	fftw_complex *mKernelBlockDeriv0; // can be gamma or gauss function
	fftw_complex *mKernelEventDeriv0; // always gamma function
	fftw_complex *mKernelDeriv1; // deriv 1
	fftw_complex *mKernelDeriv2; // deriv 2
	
	/*buffers for input and output of fft*/
	double **mBuffersForwardIn; // one per each event
	double **mBuffersInverseOut; // one per each event
	fftw_complex **mBuffersForwardOut; // Resulting HRFs (one per Event).
	fftw_complex **mBuffersInverseIn; 
	
	/*plans for fft*/
	fftw_plan *mFftPlanForward;
	fftw_plan *mFftPlanInverse;
	
	
	
    
}

-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;
-(NSError*)generateDesign;



@end

#pragma mark -

@interface BADesignElementDyn (PrivateMethods)

	


-(float**)Plot_gamma;
-(NSError*)parseInputFile:(NSString*)path;
-(NSError*)initDesign;

-(Complex)complex_mult:(Complex)a :(Complex)b;
-(double)xgamma:(double)xx :(double)t0;//TODO check functions
-(double)bgamma:(double)xx :(double)t0;
-(double)deriv1_gamma:(double)x :(double)t0;
-(double)deriv2_gamma:(double)x :(double)t0;
-(double)xgauss:(double)xx :(double)t0;

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

