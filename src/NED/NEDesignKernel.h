//
//  NEDesignKernel.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/18/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <fftw3.h>

typedef enum { KERNEL_TIME_MS = 0, KERNEL_TIME_S = 1 } NEDesignKernelTimeUnit;

@interface GloverParams : NSObject {
    unsigned int maxLengthHrfInMs;
	double peak1; //fka a1 - 6
	double scale1; //fka b1 - 0.9
	double peak2; // fka a2 - 12
	double scale2; //fka b2 - 0.9
	double offset;	// fka hard coded - for gamma 0.0, gauss 5.0
	double relationP1P2; // fka cc cx - for block 0.1, event 0.35
	double heightScale; //fka hard coded voodoo scale - for block 120, event 20
	NEDesignKernelTimeUnit timeUnit;
}

@property (readwrite) unsigned int maxLengthHrfInMs;
@property (readwrite) double peak1;
@property (readwrite) double scale1; 
@property (readwrite) double peak2; 
@property (readwrite) double scale2; 
@property (readwrite) double offset;	
@property (readwrite) double relationP1P2;
@property (readwrite) double heightScale; 
@property (readwrite) NEDesignKernelTimeUnit timeUnit;


/**
 * init a glover kernel with all it's params
 *
 * \param maxLength			maximum length of the Hemodynamic Response Function (HRF)
 * \param peak1				time of the first peak (overshoot) of HRF
 * \param scale1			scale the width of the first peak
 * \param peak2				time of the second peak (undershoot) of HRF
 * \param scale2			scale the width of the second peak
 * \param offset			delay of the HRF
 * \param relationP1P2		scale the relation of the two peaks
 * \param heightScale		general height of the HRF
 * \param givenInTimeUnit	time unit in which maxLength, peak1 and peak2 are given: KERNEL_TIME_MS KERNEL_TIME_S
 * \return      a glover kernel object
 */

-(id)initWithMaxLength:(uint)l peak1:(double_t)p1 scale1:(double_t)s1 peak2:(double_t)p2 scale2:(double_t)s2 offset:(double_t)o
		  relationP1P2:(double_t)rel heightScale:(double_t)hs givenInTimeUnit:(NEDesignKernelTimeUnit)tU;

@end

typedef struct GeneralGammaStruct {
    unsigned int maxLengthHrfInMs;
	double peak1; 
	double scale1; 
	double peak2; 
	double scale2; 
} GeneralGammaParams;

@interface NEDesignKernel : NSObject {
	
	fftw_complex *mKernelDeriv0; // gamma function
	fftw_complex *mKernelDeriv1; // deriv 1
	fftw_complex *mKernelDeriv2; // deriv 2
	
}

@property (readonly) fftw_complex *mKernelDeriv0; 
@property (readonly) fftw_complex *mKernelDeriv1; 
@property (readonly) fftw_complex *mKernelDeriv2; 



-(id)initWithGloverParams:(GloverParams*)gammaParams andNumberSamples:(NSNumber*) numberSamplesForInit andSamplingRate:(NSNumber*)samplingRate;
-(id)initWithGeneralGammaParams:(GeneralGammaParams)gammaParams;

@end

@interface NEDesignKernel (AbstractMethods)

-(float**)plotGammaWithDerivs:(unsigned int)derivs;

@end