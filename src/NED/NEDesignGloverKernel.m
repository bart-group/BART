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
-(double)getGammaValue:(double)xx :(double)t0;
-(double)getGammaDeriv1Value:(double)x :(double)t0;
-(double)getGammaDeriv2Value:(double)x :(double)t0;

@end

@implementation NEDesignGloverKernel


-(id)initWithGloverParams:(GloverParams)gammaParams andNumberSamples:(unsigned long) numberSamplesForInit
{
    if (self = [super init]) {
        mParams = gammaParams;
        mNumberSamplesForInit = numberSamplesForInit;
        [self generateGammaKernel];
    }
	return self;
}


-(void)generateGammaKernel
{
	
	unsigned int numberSamplesInResult = (mNumberSamplesForInit / 2) + 1;//defined for results of fftw3
	
	/*always generate with both derivates - so you can ask member variables if you need them*/
	double *kernel0 = NULL;//just temp to write values in
	kernel0  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv0 = (fftw_complex *)fftw_malloc (sizeof(fftw_complex) * numberSamplesInResult);
	memset(kernel0, 0, sizeof(double) * mNumberSamplesForInit);
	
	double *kernel1 = NULL;
	kernel1  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
	memset(kernel1,0,sizeof(double) * mNumberSamplesForInit);
	
	double *kernel2 = NULL;
	//if (mDerivationsHrf == 2) {
	kernel2  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
	mKernelDeriv2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
	memset(kernel2,0,sizeof(double) * mNumberSamplesForInit);
	
	unsigned int samplingRateInMs = 20; // sample the whole stuff with 20 ms;!!!!!!! NOT HERE DEFINED
	//TODO : NOT WITH DOUBLE INDEX _ EVERYTHING IN MS BUT BE CAREFUL
	double lengthHRF = (double) mParams.maxLengthHrfInMs / 1000.0;
	unsigned int indexS = 0;
	double dt = samplingRateInMs / 1000.0; /* Delta (temporal resolution) in seconds. */
	//unsigned int maxLengthHrfInMs = 30000; //=lengthHRF
	//for (unsigned int indexSample = 0; indexSample < maxLengthHrfInMs; indexSample += samplingRateInMs) {
	for (double indexSample = 0; indexSample < lengthHRF; indexSample += dt) {
		
		if (indexSample >= mNumberSamplesForInit) break;        
				
		kernel0[indexS] = [self getGammaValue:indexSample :mParams.offset];
		kernel1[indexS] = [self getGammaDeriv1Value:indexSample :mParams.offset];
		kernel2[indexS] = [self getGammaDeriv2Value:indexSample :mParams.offset];
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
-(double)getGammaValue:(double) xx
               :(double) t0
{
    double x = xx - t0;// div 1000 due to ms unit but here s used
    if (x < 0 || x > 50) {
        return 0;
    }
    
	double d1 = mParams.peak1 * mParams.scale1;
    double d2 = mParams.peak2 * mParams.scale2;
    
	double overshootFct = pow(x / d1, mParams.peak1) * exp(-(x - d1) / mParams.scale1);
    double undershootFct = pow(x / d2, mParams.peak2) * exp(-(x - d2) / mParams.scale2);
    
	double gammaFct = overshootFct - mParams.relationP1P2 * undershootFct;
    gammaFct /= mParams.heightScale;
    return gammaFct;
}


/* First derivative. */
-(double)getGammaDeriv1Value:(double) x 
                     :(double) t0
{
    double xx = x - t0;
    if (xx < 0 || xx > 50) {
        return 0;
    }
    
   	double d1 = mParams.peak1 * mParams.scale1;
    double d2 = mParams.peak2 * mParams.scale2;

    
    double overshootFct = pow(d1, -mParams.peak1) * mParams.peak1 * pow(xx, (mParams.peak1 - 1.0)) * exp(-(xx - d1) / mParams.scale1) 
	- (pow((xx / d1), mParams.peak1) * exp(-(xx - d1) / mParams.scale1)) / mParams.scale1;
    
    double undershootFct = pow(d2, -mParams.peak2) * mParams.peak2 * pow(xx, (mParams.peak2 - 1.0)) * exp(-(xx - d2) / mParams.scale2) 
	- (pow((xx / d2), mParams.peak2) * exp(-(xx - d2) / mParams.scale2)) / mParams.scale2;
    
    double gammFct = overshootFct - mParams.relationP1P2 * undershootFct;
	gammFct /= mParams.heightScale;
    
    return gammFct;
}

/* Second derivative. */
-(double)getGammaDeriv2Value:(double) x0
                     :(double) t0
{
    double x = x0 - t0;
    if (x < 0 || x > 50) {
        return 0;
    }
    
   	double d1 = mParams.peak1 * mParams.scale1;
    double d2 = mParams.peak2 * mParams.scale2;

	double overshootFct1 = pow(d1, -mParams.peak1) * mParams.peak1 * (mParams.peak1 - 1) * pow(x, mParams.peak1 - 2) * exp(-(x - d1) / mParams.scale1) 
				- pow(d1, -mParams.peak1) * mParams.peak1 * pow(x, (mParams.peak1 - 1)) * exp(-(x - d1) / mParams.scale1) / mParams.scale1;
	
    double overshootFct2 = pow(d1, -mParams.peak1) * mParams.peak1 * pow(x, mParams.peak1 - 1) * exp(-(x - d1) / mParams.scale1) / mParams.scale1
				- pow((x / d1), mParams.peak1) * exp(-(x - d1) / mParams.scale1) / (mParams.scale1 * mParams.scale1);
    
	double undershootFct1 = pow(d2, -mParams.peak2) * mParams.peak2 * (mParams.peak2 - 1) * pow(x, mParams.peak2 - 2) * exp(-(x - d2) / mParams.scale2) 
				- pow(d2, -mParams.peak2) * mParams.peak2 * pow(x, (mParams.peak2 - 1)) * exp(-(x - d2) / mParams.scale2) / mParams.scale2;
	
    double undershootFct2 = pow(d2, -mParams.peak2) * mParams.peak2 * pow(x, mParams.peak2 - 1) * exp(-(x - d2) / mParams.scale2) / mParams.scale2
				- pow((x / d2), mParams.peak2) * exp(-(x - d2) / mParams.scale2) / (mParams.scale2 * mParams.scale2);
    
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
        gammaFct = [self getGammaValue:x :t0];
        gammaDeriv1 = [self getGammaDeriv1Value:x :t0];
        gammaDeriv2 = [self getGammaDeriv2Value:x :t0];
		
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
    fftw_free(mKernelDeriv0);
    fftw_free(mKernelDeriv1);
    fftw_free(mKernelDeriv2);
    
	[super dealloc];
}


@end
 