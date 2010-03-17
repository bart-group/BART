/*
 *  NEDesignGammaFct.h
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 3/16/10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */


/*This class generates a Gamma function and tweo derivates described by the params in GammaParams
/*The origin is the Glover Kernel with following params: 
   peak1 = 6.0
   scale1 = 0.9
   peak2 = 12.0
   scale2 = 0.9
   understrength = 0.35 for eventrelated design || 0.1 for block design
   some special scaling factors 20.0 for eventrelated designs and derivs || 120 for block designs
 */


#import <Cocoa/Cocoa.h>
#import <fftw3.h>

typedef struct GammaStruct {
    unsigned int maxLengthHrfInMs;
	double peak1; //fka a1
	double width1;
	double scale1; //fka b1
	double peak2; // fka a2
	double width2;
	double scale2; //fka b2
	double offset;	
	double understrength; // fka cc cx
} GammaParams;

@interface NEDesignGammaKernel :NSObject
{
	GammaParams mParams;
	unsigned long mNumberSamplesForInit;
	
	fftw_complex *mKernelDeriv0; // gamma function
	fftw_complex *mKernelDeriv1; // deriv 1
	fftw_complex *mKernelDeriv2; // deriv 2
}

@property (readonly) fftw_complex *mKernelDeriv0; 
@property (readonly) fftw_complex *mKernelDeriv1; 
@property (readonly) fftw_complex *mKernelDeriv2; 
@property (readonly, assign) GammaParams mParams;



-(id)initWithGammaStruct:(GammaParams)gammaParams andNumberSamples:(unsigned long) numberSamplesForInit;

-(float**)plotGammaWithDerivs:(unsigned int)derivs;	


@end