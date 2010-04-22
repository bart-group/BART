//
//  NEDesignGloverKernelTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 4/22/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignGloverKernelTest.h"
#import "NEDesignGloverKernel.h"

@implementation NEDesignGloverKernelTest



-(void)setUp
{}

-(void)testGloverKernel
{
	
	GloverParams *params = [[GloverParams alloc] init];
	unsigned long numberSamples = 100;
	NEDesignGloverKernel *kernel = [[NEDesignGloverKernel alloc] initWithGloverParams:params andNumberSamples:numberSamples];
	// fftw_complex *mKernelDeriv0; 
//	 fftw_complex *mKernelDeriv1; 
//	 fftw_complex *mKernelDeriv2; 
//	 GloverParams mParams;
}

@end
