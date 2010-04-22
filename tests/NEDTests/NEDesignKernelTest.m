//
//  NEDesignKernelTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 4/22/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignKernelTest.h"
#import "NEDesignKernel.h"
#import "NEDesignGloverKernel.h"

@implementation NEDesignKernelTest
NEDesignKernel *kernel;

-(void)setUp
{
	
}

-(void)testInitFunctions
{
	GeneralGammaParams params;
	STAssertThrows(kernel = [[NEDesignKernel alloc] initWithGeneralGammaParams:params], @"initWithGeneralGamma doesn't throw exception");
	STAssertNil(kernel, @"init GeneralGamma doesn't return nil");
	
	GloverParams *gloverParams;
	STAssertNoThrow( kernel = [[NEDesignKernel alloc] initWithGloverParams:gloverParams andNumberSamples:100], @" initWithGlover throws exception");
	// glover params not initialized and not set yet
	STAssertNil(kernel, @"init GloverGamma returns not nil");

	//	//init gloverParams but not set
	gloverParams = [[GloverParams alloc] init];
	STAssertNoThrow( kernel = [[NEDesignKernel alloc] initWithGloverParams:gloverParams andNumberSamples:100], @" initWithGlover throws exception");
	STAssertNotNil(kernel, @"init GloverGamma returns not nil");
	[kernel release];
	[gloverParams release];

	// init and set glover params
	//TODO: ABH numberSamples!!!!!!
	gloverParams = [[GloverParams alloc] initWithMaxLength:30000 peak1:6.0 scale1:0.9 peak2:12.0 scale2:0.9 offset:0.0
													  relationP1P2:0.1 heightScale:120];
	STAssertNoThrow( kernel = [[NEDesignKernel alloc] initWithGloverParams:gloverParams andNumberSamples:1000000], @" initWithGlover throws exception");
	STAssertNotNil(kernel, @"init GloverGamma returns nil");
	STAssertTrue([kernel isKindOfClass:[NEDesignGloverKernel class]], @"initWithGloverParams doesn't return correct class type");
	[kernel release];
	[gloverParams release];
	
}


@end
