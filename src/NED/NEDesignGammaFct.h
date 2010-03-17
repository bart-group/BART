/*
 *  NEDesignGammaFct.h
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 3/16/10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>


typedef struct GammaStruct {
    unsigned int maxLengthHrfInMs;
	double peak1;
	double width1;
	double scale1;
	double peak2;
	double width2;
	double scale2;
	double offset;
	unsigned int derivs;    
} GammaParams;

@interface NEDesignGammaFct 
{
	double *mGammaKernel;
	double *mGammaKernelDeriv1;
	double *mGammaKernelDeriv2;

}

@property (readonly) double *mGammaKernel;
@property (readonly) double *mGammaKernelDeriv1;
@property (readonly) double *mGammaKernelDeriv2;


	-(id)initWithGammaStruct:(GammaParams)gammaParams;
	


//-(double)xgamma:(double)xx :(double)t0;//TODO check functions
//-(double)bgamma:(double)xx :(double)t0;
//-(double)deriv1_gamma:(double)x :(double)t0;
//-(double)deriv2_gamma:(double)x :(double)t0;
//-(double)xgauss:(double)xx :(double)t0;
 

@end