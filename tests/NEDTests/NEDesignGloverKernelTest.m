//
//  NEDesignGloverKernelTest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 4/22/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignGloverKernelTest.h"
#import "NEDesignGloverKernel.h"
#import "NEDesignGloverKernelReference.h"
@implementation NEDesignGloverKernelTest



-(void)setUp
{}

-(void)testGloverKernel
{
	
	
	unsigned long numberSamples = 15000;
	
	
	/*Reference implementation*/
	/**************************/
	
	unsigned long numberSamplesResult = numberSamples/2 + 1;
	
	double *block_kernel  = (double *)fftw_malloc(sizeof(double) * numberSamples);
    fftw_complex *fkernelg = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesResult);
    memset(block_kernel,0,sizeof(double) * numberSamples);
    
    double *kernel0  = (double *)fftw_malloc(sizeof(double) * numberSamples);
    fftw_complex *fkernel0 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesResult);
    memset(kernel0,0,sizeof(double) * numberSamples);
    
   double *kernel1  = (double *)fftw_malloc(sizeof(double) * numberSamples);
   fftw_complex *fkernel1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesResult);
   memset(kernel1,0,sizeof(double) * numberSamples);
   
    
   double *kernel2  = (double *)fftw_malloc(sizeof(double) * numberSamples);
   fftw_complex *fkernel2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesResult);
   memset(kernel2,0,sizeof(double) * numberSamples);
   	
	unsigned int i = 0;
    double t1 = 30.0;  // HRF duration / Breite der HRF
    double dt = 20.0/1000; //sampling
    
    for (double t=0; t<t1; t+= dt) {
        if (i >= numberSamples) break;
		block_kernel[i] = bgamma(t,0); 
	    kernel0[i] = xgamma(t,0);
        kernel1[i] = deriv1_gamma(t,0);
        kernel2[i] = deriv2_gamma(t,0);
        i++;
    }
    
    /* fft for kernels */
    fftw_plan pkg = fftw_plan_dft_r2c_1d (numberSamples,block_kernel,fkernelg,FFTW_ESTIMATE);
    fftw_execute(pkg);
    
    fftw_plan pk0 = fftw_plan_dft_r2c_1d (numberSamples,kernel0,fkernel0,FFTW_ESTIMATE);
    fftw_execute(pk0);
    
    fftw_plan pk1 = fftw_plan_dft_r2c_1d (numberSamples,kernel1,fkernel1,FFTW_ESTIMATE);
    fftw_execute(pk1);
    
    
    fftw_plan pk2 = fftw_plan_dft_r2c_1d (numberSamples,kernel2,fkernel2,FFTW_ESTIMATE);
    fftw_execute(pk2);
    /********************************/
	
	//now, my way, params as in reference xgamma
	GloverParams *params = [[GloverParams alloc] initWithMaxLength:30000 peak1:6.000 scale1:0.9 
															 peak2:12.000 scale2:0.9 offset:0.0 
													  relationP1P2:0.35 heightScale:20.0];
	
	NEDesignGloverKernel *kernel = [[NEDesignGloverKernel alloc] initWithGloverParams:params andNumberSamples:numberSamples];
			
	
	//compare
	// TODO: remove output
	FILE* fp = fopen("/tmp/gloTest.txt", "w");
//		fputc('\n', fp);
//	//	fputc('B', fp);
//	//	fputc(' ', fp);
		for (unsigned int ind = 0; ind < numberSamplesResult; ind++)
			fprintf(fp, "%.2f\n", kernel.mKernelDeriv0[ind][0]);	 
		fclose(fp);
	// END output
	for (unsigned int ind = 0; ind < numberSamplesResult; ind++){
		STAssertTrue( kernel.mKernelDeriv0[ind][0] == fkernel0[ind][0], @"value in mKernelDeriv0 wrong - re");
		STAssertTrue( kernel.mKernelDeriv0[ind][1] == fkernel0[ind][1], @"value in mKernelDeriv0 wrong - im");
		STAssertTrue( kernel.mKernelDeriv1[ind][0] == fkernel1[ind][0], @"value in mKernelDeriv1 wrong - re");
		STAssertTrue( kernel.mKernelDeriv1[ind][1] == fkernel1[ind][1], @"value in mKernelDeriv1 wrong - im");
		STAssertTrue( kernel.mKernelDeriv2[ind][0] == fkernel2[ind][0], @"value in mKernelDeriv2 wrong - re");
		STAssertTrue( kernel.mKernelDeriv2[ind][1] == fkernel2[ind][1], @"value in mKernelDeriv2 wrong - im");
	}
	
	//second try - params as in bgamma
	[params release];
	[kernel release];
	params = [[GloverParams alloc] initWithMaxLength:30000 peak1:6.000 scale1:0.9 
															 peak2:12.000 scale2:0.9 offset:0.0 
													  relationP1P2:0.1 heightScale:120.0];
	kernel = [[NEDesignGloverKernel alloc] initWithGloverParams:params andNumberSamples:numberSamples];
	for (unsigned int ind = 0; ind < numberSamplesResult; ind++){
		STAssertTrue( kernel.mKernelDeriv0[ind][0] == fkernelg[ind][0], @"2nd value in mKernelDeriv0 wrong - re");
		STAssertTrue( kernel.mKernelDeriv0[ind][1] == fkernelg[ind][1], @"2nd value in mKernelDeriv0 wrong - im");
	}
	
	//everything zero
	[params release];
	[kernel release];
	params = [[GloverParams alloc] initWithMaxLength:0 peak1:0 scale1:0 
											   peak2:0 scale2:0 offset:0.0 
										relationP1P2:0 heightScale:0];
	kernel = [[NEDesignGloverKernel alloc] initWithGloverParams:params andNumberSamples:numberSamples];
	for (unsigned int ind = 0; ind < numberSamplesResult; ind++){
		STAssertTrue( kernel.mKernelDeriv0[ind][0] == 0.0, @"3rd value in mKernelDeriv0 wrong - re");
		STAssertTrue( kernel.mKernelDeriv0[ind][1] == 0.0, @"3rd value in mKernelDeriv0 wrong - im");
	}
	
		
	
}

@end
