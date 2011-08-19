//
//  NEDesignKernel.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/18/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignKernel.h"
#import "NEDesignGloverKernel.h"


@implementation GloverParams

@synthesize maxLengthHrfInMs;
@synthesize peak1;
@synthesize scale1; 
@synthesize peak2; 
@synthesize scale2; 
@synthesize offset;	
@synthesize relationP1P2;
@synthesize heightScale; 
@synthesize timeUnit;

-(id)initWithMaxLength:(uint)l peak1:(double_t)p1 scale1:(double_t)s1 peak2:(double_t)p2 scale2:(double_t)s2 offset:(double_t)o
		  relationP1P2:(double_t)rel heightScale:(double_t)hs givenInTimeUnit:(NEDesignKernelTimeUnit)tU
{
	self = [super init];
	if (nil != self){
		maxLengthHrfInMs = l;
		peak1 = p1;
		scale1 = s1; 
		peak2 = p2; 
		scale2 = s2; 
		offset = o;	
		relationP1P2 = rel;
		heightScale = hs;
		timeUnit = tU;
	}
	return self;
}
-(id)init
{
	self = [super init];
	if (nil != self){
		maxLengthHrfInMs = 0;
		peak1 = 0;
		scale1 = 0; 
		peak2 = 0; 
		scale2 = 0; 
		offset = 0;	
		relationP1P2 = 0;
		heightScale = 0;
		timeUnit = 0;
	}
	return self;
}

@end



@implementation NEDesignKernel

@synthesize mKernelDeriv0;
@synthesize mKernelDeriv1;
@synthesize mKernelDeriv2;



-(id)initWithGloverParams:(GloverParams*)gammaParams andNumberSamples:(NSNumber*) numberSamplesForInit andSamplingRate:(NSNumber*)samplingRate
{
	self = [[NEDesignGloverKernel alloc] initWithGloverParams:gammaParams andNumberSamples:numberSamplesForInit andSamplingRate:samplingRate];
    
	return self;
}

-(id)initWithGeneralGammaParams:(GeneralGammaParams)gammaParams
{
	//NSLog(@"General Gamma Function is not supported at the moment!");
//	return nil;
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)dealloc
{
	fftw_free(mKernelDeriv0);
	fftw_free(mKernelDeriv1);
	fftw_free(mKernelDeriv2);
	mKernelDeriv0 = nil;
	mKernelDeriv1 = nil;
	mKernelDeriv2 = nil;
	
	
	[super dealloc];
}
@end
