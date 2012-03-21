/*
 *  NEDesignGammaFct.h
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 3/16/10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */


 /* This class generates a Gamma function and tweo derivates described by the params in GammaParams
 *
 * first implementation in the tool vgendesign from the Software Package Lipsia
 * and is based on the Glover kernel, see G.H. Glover, 1999, NeuroImage 9, 416-429 
 */


#import <Cocoa/Cocoa.h>

#import "NEDesignKernel.h"


@interface NEDesignGloverKernel : NEDesignKernel
{
	GloverParams *mParams;
	unsigned long mNumberSamplesForInit;
	unsigned long mSamplingRateInMs;
	double	mScaleTimeUnit;
}

-(float**)plotGammaWithDerivs:(unsigned int)derivs;	


@end