//
//  NEDesignGammaFct.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/16/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//




#import "NEDesignGloverKernel.h"

@interface NEDesignGloverKernel (PrivateMethods)

-(void)generateGammaKernel;
-(double)getGammaValue:(double)val withOffset:(double)t0;
-(double)getGammaDeriv1Value:(double)val withOffset:(double)t0;
-(double)getGammaDeriv2Value:(double)val withOffset:(double)t0;

@end

@implementation NEDesignGloverKernel



-(id)initWithGloverParams:(GloverParams*)gammaParams andNumberSamples:(NSNumber*)numberSamplesForInit andSamplingRate:(NSNumber*)samplingRate
{
	if (nil == gammaParams || 0 >= [numberSamplesForInit unsignedLongValue] || 0 >= [samplingRate unsignedLongValue]){
		NSLog(@"GloverParams not valid - no HRF defined!");
		return nil;
	}
	if (self = [super init]) {
        mParams = [gammaParams retain] ;
        mNumberSamplesForInit = [numberSamplesForInit longValue];
		mSamplingRateInMs = [samplingRate longValue];
		mScaleTimeUnit = 1.0;
		if (mParams.timeUnit == KERNEL_TIME_MS){
			mScaleTimeUnit = 0.001; // due to glover formula given for s we will scale later on
		}
		[self generateGammaKernel];
    }
	return self;
}


-(void)generateGammaKernel
{
	unsigned long numberSamplesInResult = (mNumberSamplesForInit/ 2) + 1;//defined for results of fftw3
	/*always generate with both derivates - so you can ask member variables if you need them*/
	double *kernel0 = NULL;//just temp to write values in
	kernel0  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv0 = (fftw_complex *)fftw_malloc (sizeof(fftw_complex) * numberSamplesInResult);
	memset(kernel0, 0.0, sizeof(double) * mNumberSamplesForInit);
	
	double *kernel1 = NULL;
	kernel1  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
	memset(kernel1,0.0,sizeof(double) * mNumberSamplesForInit);
	
	double *kernel2 = NULL;
	kernel2  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
	memset(kernel2,0.0,sizeof(double) * mNumberSamplesForInit);
	
	// sample the whole stuff e.g. something bout 20 ms;
	unsigned int indexS = 0;
	for (unsigned long timeSample = 0; timeSample < mParams.maxLengthHrfInMs; timeSample += mSamplingRateInMs) {
		if (indexS >= mNumberSamplesForInit) break;        
		//unsigned long indexS = (unsigned long)timeSample/mSamplingRateInMs;
		kernel0[indexS] = [self getGammaValue:(double)timeSample withOffset:(double)mParams.offset];
		kernel1[indexS] = [self getGammaDeriv1Value:(double)timeSample withOffset:(double)mParams.offset];
		kernel2[indexS] = [self getGammaDeriv2Value:(double)timeSample withOffset:(double)mParams.offset];
		indexS++;
	}

	/* do fft for kernels right now - result buffers are the members the convolution will ask for*/
	fftw_plan pk0;
	pk0 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel0, mKernelDeriv0, FFTW_ESTIMATE);
	fftw_execute(pk0);
	
	fftw_plan pk1;
	pk1 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel1, mKernelDeriv1, FFTW_ESTIMATE);
	fftw_execute(pk1);
	
	fftw_plan pk2;
	pk2 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel2, mKernelDeriv2, FFTW_ESTIMATE);
	fftw_execute(pk2);
	
	fftw_free(kernel0);
	fftw_free(kernel1);
	fftw_free(kernel2);
}

/*
 * Glover kernel, gamma function
 */
-(double)getGammaValue:(double)val withOffset:(double)t0
{
    double x = (val - t0)*mScaleTimeUnit;// scale to s
    if (x < 0 || x > 50) {
        return 0;
    }
    
	double peak1 = mParams.peak1 * mScaleTimeUnit;
	double peak2 = mParams.peak2 * mScaleTimeUnit;
	double d1 = peak1 * mParams.scale1;
    double d2 = peak2 * mParams.scale2;
    
	double overshootFct = pow(x / d1, peak1) * exp(-(x - d1) / mParams.scale1);
    double undershootFct = pow(x / d2, peak2) * exp(-(x - d2) / mParams.scale2);
    		double gammaFct = overshootFct - mParams.relationP1P2 * undershootFct;
    gammaFct /= mParams.heightScale;
    return gammaFct;
}


/* First derivative. */
-(double)getGammaDeriv1Value:(double)val withOffset:(double) t0
{
    double x = (val - t0)*mScaleTimeUnit;
    if (x < 0 || x > 50) {
        return 0;
    }
    
	double peak1 = mParams.peak1 * mScaleTimeUnit;
	double peak2 = mParams.peak2 * mScaleTimeUnit;
   	double d1 = peak1 * mParams.scale1;
    double d2 = peak2 * mParams.scale2;

    
    double overshootFct = pow(d1, -peak1) * peak1 * pow(x, (peak1 - 1.0)) * exp(-(x - d1) / mParams.scale1) 
	- (pow((x / d1), peak1) * exp(-(x - d1) / mParams.scale1)) / mParams.scale1;
    
    double undershootFct = pow(d2, -peak2) * peak2 * pow(x, (peak2 - 1.0)) * exp(-(x - d2) / mParams.scale2) 
	- (pow((x / d2), peak2) * exp(-(x - d2) / mParams.scale2)) / mParams.scale2;
    
    double gammFct = overshootFct - mParams.relationP1P2 * undershootFct;
	gammFct /= mParams.heightScale;
    
    return gammFct;
}

/* Second derivative. */
-(double)getGammaDeriv2Value:(double)val withOffset:(double)t0
{
    double x = (val - t0)*mScaleTimeUnit;
    if (x < 0 || x > 50) {
        return 0;
    }
    
	double peak1 = mParams.peak1 * mScaleTimeUnit;
	double peak2 = mParams.peak2 * mScaleTimeUnit;
   	double d1 = peak1 * mParams.scale1;
    double d2 = peak2 * mParams.scale2;

	double overshootFct1 = pow(d1, -peak1) * peak1 * (peak1 - 1) * pow(x, peak1 - 2) * exp(-(x - d1) / mParams.scale1) 
				- pow(d1, -peak1) * peak1 * pow(x, (peak1 - 1)) * exp(-(x - d1) / mParams.scale1) / mParams.scale1;
	
    double overshootFct2 = pow(d1, -peak1) * peak1 * pow(x, peak1 - 1) * exp(-(x - d1) / mParams.scale1) / mParams.scale1
				- pow((x / d1), peak1) * exp(-(x - d1) / mParams.scale1) / (mParams.scale1 * mParams.scale1);
    
	double undershootFct1 = pow(d2, -peak2) * peak2 * (peak2 - 1) * pow(x, peak2 - 2) * exp(-(x - d2) / mParams.scale2) 
				- pow(d2, -peak2) * peak2 * pow(x, (peak2 - 1)) * exp(-(x - d2) / mParams.scale2) / mParams.scale2;
	
    double undershootFct2 = pow(d2, -peak2) * peak2 * pow(x, peak2 - 1) * exp(-(x - d2) / mParams.scale2) / mParams.scale2
				- pow((x / d2), peak2) * exp(-(x - d2) / mParams.scale2) / (mParams.scale2 * mParams.scale2);
    
	double gammaFct = (overshootFct1 - overshootFct2) - mParams.relationP1P2 * (undershootFct1 - undershootFct2);
    gammaFct /= mParams.heightScale;
    
    return gammaFct;
}

///* Gaussian function. */
//-(double)xgauss:(double)x0
//               :(double)t0
//{
//    double sigma = 1.0;
//    double scale = 20.0;
//    double x;
//    double y;
//    double z;
//    double a=2.506628273;
//    
//    x = (x0 - t0);
//    z = x / sigma;
//    y = exp((double) - z * z * 0.5) / (sigma * a);
//    y /= scale;
//    return y;
//}
//

-(float**)plotGammaWithDerivs:(unsigned int)derivs
{
    double gammaFct;
    double gammaDeriv1;
    double gammaDeriv2;
    double t0 = 0.0;
    double step = 0.2;
    
    int ncols = (int) (28.0 / step);
    int nrows = derivs + 2;
    
    float** dest = (float**) malloc(sizeof(float*) * ncols);
    for (int col = 0; col < ncols; col++) {
        
        dest[col] = (float*) malloc(sizeof(float) * nrows);
        for (int row = 0; row < nrows; row++) {
            dest[col][row] = 0.0;
        }
    }
    
    int j = 0;
    for (double x = 0.0; x < 28.0; x += step) {
        if (j >= ncols) {
            break;
        }
        gammaFct = [self getGammaValue:x withOffset:t0];
        gammaDeriv1 = [self getGammaDeriv1Value:x withOffset:t0];
        gammaDeriv2 = [self getGammaDeriv2Value:x withOffset:t0];
		
        dest[j][0] = x;
        dest[j][1] = gammaFct;
        if (derivs > 0) {
            dest[j][2] = gammaDeriv1;
        }
        if (derivs > 1) {	
            dest[j][3] = gammaDeriv2;
        }
        j++;
    }
    
    return dest;
}

-(void)dealloc
{
    [mParams release];
	[super dealloc];
}


@end
 