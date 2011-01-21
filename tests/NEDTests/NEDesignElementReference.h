/*
 *  NEDesignElementReference.h
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 8/31/10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <fftw3.h>
#import "NEDesignKernel.h"

typedef struct ComplexRefStruct {
    double re;
    double im;
} ComplexRef;

typedef struct TrialRefStruct{
    unsigned int id;               // Stimulus number.
    float onset;
    float duration;         // in seconds
    float height;
} TrialRef;

typedef struct TrialListRefStruct {
    TrialRef trial;
    struct TrialListRefStruct *next;
} TrialListRef;


typedef struct RegressorRefStruct {
	TrialListRef *regTrialList;
	unsigned int regDerivations;
	NSString *regID;
	NSString *regDescription;
	NEDesignKernel *regConvolKernel;
} TRegressorRef;

enum BADesignElementErrorRef {
    R_TR_NOT_SPECIFIED,
    R_NUMBERTIMESTEPS_NOT_SPECIFIED,
	R_NUMBERCOVARIATES_NOT_SPECIFIED,
	R_NUMBERREGRESSORS_NOT_SPECIFIED,
	R_CONVOLUTION_KERNEL_NOT_SPECIFIED,
    R_FILEOPEN,
    R_TXT_SCANFILE,
    R_ILLEGAL_INPUT_FORMAT,
    R_NO_EVENTS_FOUND,
    R_EVENT_NUMERATION,
    R_MAX_TRIALS,
    R_WRITE_OUTPUT
};

@interface NEDesignElementReference : NSObject{
	
	TRegressorRef **mRegressorList;
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
	
	unsigned int mRepetitionTimeInMs;
    unsigned int mNumberExplanatoryVariables;
    unsigned int mNumberTimesteps;
    unsigned int mNumberRegressors;
	unsigned int mNumberCovariates;  
	unsigned int mImageDataType;
	
	
}

@property ( assign) unsigned int mRepetitionTimeInMs;
@property ( assign) unsigned int mNumberExplanatoryVariables;
@property ( assign) unsigned int mNumberTimesteps;
@property ( assign) unsigned int mNumberRegressors;
@property ( assign) unsigned int mNumberCovariates;  
@property ( assign) unsigned int mImageDataType;


-(NSError*)generateDesign;

-(id)init;


-(NSError*)writeDesignFile:(NSString*)path;

-(NSNumber*)getValueFromExplanatoryVariable: (unsigned int)cov atTimestep:(unsigned int)t;



@end

#pragma mark -

@interface NEDesignElementReference (PrivateMethods)

-(NSError*)parseInputFile:(NSString*)path;
-(NSError*)initDesign;
-(ComplexRef)multiplComplex:(ComplexRef)a withComplex:(ComplexRef) b;
-(BOOL)test_ascii:(int)val;
-(void)Convolve:(unsigned int)col
			   :(unsigned int) eventNr
               :(fftw_complex *)fkernel;

/* Utility function for TrialList. */
-(void)tl_append:(TrialListRef*)head
                :(TrialListRef*)newLast;

-(NSError*)getPropertiesFromConfig;

-(NSError*)correctForZeromean;
-(void)initRegressorValues;
-(void)initCovariateValues;



@end
