//
//  NEDesignKernel.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/18/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignKernel.h"
#import "NEDesignGloverKernel.h"


@implementation NEDesignKernel

@synthesize mKernelDeriv0;
@synthesize mKernelDeriv1;
@synthesize mKernelDeriv2;
@synthesize mParams;


-(id)initWithGloverParams:(GloverParams)gammaParams andNumberSamples:(unsigned long) numberSamplesForInit
{
	self = [super init];
	if (nil != self){
		self = [[NEDesignGloverKernel alloc] initWithGloverParams:gammaParams andNumberSamples:numberSamplesForInit];
	}
	return self;
}

-(id)initWithGeneralGammaParams:(GeneralGammaParams)gammaParams
{
	NSLog(@"General Gamma Function is not supported at the moment!");
	return nil;
}


-(void)dealloc
{

	fftw_free(mKernelDeriv0);
	fftw_free(mKernelDeriv1);
	fftw_free(mKernelDeriv2);
	
	[super dealloc];
}
@end
