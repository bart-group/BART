//
//  ARAnalyzerGLM.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "ARAnalyzerGLM.h"
#import "EDNA/EDDataElement.h"
#import "NEDesignElement.h"
#import "BAGUIProtoCGLayer.h"
#include <Accelerate/Accelerate.h>
//#import "gsl/gsl_cblas.h"
#import "gsl/gsl_matrix.h"
//#import "gsl/gsl_vector.h"
//#import "gsl/gsl_blas.h"
#import "gsl_utils.h"


extern gsl_vector *GaussKernel(double);
extern void GaussMatrix(double, gsl_matrix_float *);
extern gsl_vector_float *VectorConvolve(gsl_vector_float *, gsl_vector_float *,
										gsl_vector *);

@interface ARAnalyzerGLM (PrivateMethods)
     
-(EDDataElement*)Regression:(short)minval
                 :(size_t)sliding_window_size
                 :(size_t)last_timestep
				 :(NSArray*)contrastVector
                 :(NEDesignElement*)copyDesign
                 :data;

-(float_t)CalcSigma:(float_t)fwhm forRepTime:(NSUInteger)repTime;

//-(void)createOutputImages:(NEDesignElement*)des fromData:(EDDataElement*)data;

@end


@implementation ARAnalyzerGLM

//TODO : get from config
@synthesize slidingWindowSize;
@synthesize mSlidingWindowAnalysis;
@synthesize mMinval;
//gsl_vector_float *global_y;
//gsl_vector_float *global_ys;
float global_sum;
float global_sum2;
float global_nx;

-(id)init
{
    if ((self = [super init])) {
        slidingWindowSize = 40;
        mSlidingWindowAnalysis = NO;
        //global_y = gsl_vector_float_alloc(720);
        //global_ys = gsl_vector_float_alloc(720);
        global_sum = 0.0f;
        global_sum2 = 0.0f;
        global_nx = 0.0f;
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNewData:) name:@"MessageName" object:nil];
    return self;
}

//-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
//                     withDesign:(NEDesignElement*)design
//             andCurrentTimestep:(size_t)timestep
-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
                     withDesign:(NEDesignElement*)design
			  atCurrentTimestep:(size_t)timestep
			  forContrastVector:(NSArray*)contrastVector
			 andWriteResultInto:(EDDataElement*)resData;
//TODO:Ergebnis als Referenz reingeben, nicht hier drin erzeugen UND Contrasts UND MINVAL mitgeben!!
{
    NEDesignElement* copyDesign = [design retain];
   // NSLog(@"DesignEl in Analysis: %@", copyDesign);
    EDDataElement* copyData = [data retain];
        
    
    /**********************
     * DO REGRESSION
     *********************/
    
    NSLog(@"Time analysis: Start");
    
    int64_t index = 0;
    if (mSlidingWindowAnalysis){
        index = slidingWindowSize;
    } else {
        index = timestep;
        
    }
    
    EDDataElement*  resMap = [self Regression:2000
                                             :index // sw: slidingWindowSize akk: indexForTimestep
                                             :timestep
                                             :contrastVector
                                             :copyDesign
                                             :copyData];
    //    [self sendFinishNotification];

    NSLog(@"Time analysis: End");
    
//    indexForTimestep++;
//    if (indexForTimestep < mData.numberTimesteps){
//        [self startTimer];
//    } else {
//        [mBetaOutput WriteDataElementToFile:@"/tmp/outfromBART.v"];
//        [mResOutput WriteDataElementToFile:@"/tmp/outfromBART.v"];
//    }
    
	
	[copyDesign release];
    [copyData release];
    return resMap ;
}

-(void)dealloc
{
    
    //gsl_vector_float_free(global_y);
    //gsl_vector_float_free(global_ys);
    [super dealloc];
}

-(void)sendFinishNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnalyzeGLMFinished" object:self];
}


-(EDDataElement*)Regression:(short)minval
				 :(size_t)sliding_window_size
				 :(size_t)lastTimestep
				 :(NSArray*)contrastVector
                 :(NEDesignElement*)copyDesign
                 :(EDDataElement*)data{
    
    if (sliding_window_size <= lastTimestep) {
        
        size_t numberBands = data.mImageSize.timesteps;
		size_t numberSlices = data.mImageSize.slices;
        size_t numberRows = data.mImageSize.rows;
        size_t numberCols = data.mImageSize.columns;
        size_t numberExplanatoryVariables = copyDesign.mNumberExplanatoryVariables;
        dispatch_queue_t queue = dispatch_queue_create("de.mpg.cbs.BARTAnalyzerGLMQueue", DISPATCH_QUEUE_CONCURRENT); /* asyn. dispatch queue. */
        
        gsl_set_error_handler_off();
        
        // C1) If there are more than one input image - test for dimensions
        
        if (numberExplanatoryVariables >= MBETA) {
            NSLog(@" too many covariates (%lu), max is %d", numberExplanatoryVariables, MBETA);
        }
        if (copyDesign.mNumberTimesteps != numberBands) {
            NSLog(@" design dimension inconsistency: %ld (numberTimesteps design) %lu (numberTimesteps data)", 
                  copyDesign.mNumberTimesteps, numberBands);
        }
        /* Read design matrix. */
        gsl_matrix_float *X = NULL; /*   matrix. */
        X = gsl_matrix_float_alloc(sliding_window_size, numberExplanatoryVariables);
        double x; /* One entry of matrix X. */
        for (size_t timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            for (size_t covariate = 0; covariate < numberExplanatoryVariables; covariate++) {
// TODO: use getFloatValue... (performance increase!)
                x = [[copyDesign getValueFromExplanatoryVariable:covariate atTimestep:timestep] floatValue];
                fmset(X, timestep - (lastTimestep - sliding_window_size), covariate, (float) x);
            }
        }
        /*
         * pre-coloring, set up K-matrix, S=K, V = K*K^T with K=S
         * K ... correlation matrix
         */
//TODO: fwhm aus Konfig
        float fwhm = 4.0;
        float_t sigma = [self CalcSigma:fwhm forRepTime:copyDesign.mRepetitionTimeInMs];
        gsl_matrix_float *S = NULL;	   /* Gaussian matrix / Gauss filter. */
        S = gsl_matrix_float_alloc(sliding_window_size, sliding_window_size);
        GaussMatrix((double) sigma, S);
        gsl_matrix_float *Vc = NULL;   /* Descibes auto correlation matrix. */
        Vc = fmat_x_matT(S, S, NULL);

        /* Compute pseudo inverse. */
        gsl_matrix_float *SX = NULL;   /* "Notation": SX = matrix S multiplied by matrix X. */
        SX = fmat_x_mat(S, X, NULL);
        gsl_matrix_float *XInv = NULL; /* Pseudo inverse matrix of X. */
        XInv = fmat_PseudoInv(SX, NULL);
        NSLog(@"4444");
        /* Get effective degrees of freedom. */
        gsl_matrix_float *R = NULL;
        R = gsl_matrix_float_alloc(sliding_window_size, sliding_window_size);
        gsl_matrix_float *P = NULL;
        P = fmat_x_mat(SX, XInv, P);
        
        gsl_matrix_float_set_identity(R);
        gsl_matrix_float_sub(R, P);
        
        gsl_matrix_float *RV = NULL;
        RV = fmat_x_mat(R, Vc, NULL);
        
        float trace = 0.0;
        for (size_t timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            trace += fmget(RV, timestep - (lastTimestep - sliding_window_size), timestep - (lastTimestep - sliding_window_size));
        }
        
        P = fmat_x_mat(RV, RV, P);
        
        float trace2 = 0.0;
        for (size_t timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            trace2 += fmget(P, timestep - (lastTimestep - sliding_window_size), timestep - (lastTimestep - sliding_window_size));
        }

        float df = (trace * trace) / trace2; /* df ... Degrees of freedom. */
        printf(" df = %.3f\n", df);
        
        /**********************
         * create output images
         *********************/
        BARTImageSize *s = [[data mImageSize] copy];
        s.timesteps = copyDesign.mNumberExplanatoryVariables;
        EDDataElement* betaOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_BETAS];
        
        NSArray *propsToCopy = [NSArray arrayWithObjects:
                                @"voxelsize",
                                @"subjectName",
                                @"caPos",
                                @"voxelGap",
                                @"repetitionTime",
                                @"capos",
                                @"subjectAge",
                                @"subjectWEIGHT",
                                @"flipAngle",
                                @"echoTime",
                                @"acquisitionTime",
                                @"rowVec",
                                @"sliceVec",
                                @"columnVec",
                                @"sequenceNumber",
                                @"indexOrigin",
                                nil];
        
        [betaOutput copyProps:propsToCopy fromDataElement:data];
        
        s.timesteps = 1;
        EDDataElement* resOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
        [resOutput copyProps:propsToCopy fromDataElement:data];
        EDDataElement*  resMap = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
        [ resMap copyProps:propsToCopy fromDataElement:data];
        s.slices = 1;
        EDDataElement*  BCOVOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_UNKNOWN] ;
        [s release];
                
        [betaOutput setImageProperty:PROPID_DF withValue:[NSNumber numberWithFloat:df]];
        [resOutput setImageProperty:PROPID_DF withValue:[NSNumber numberWithFloat:df]];
        
        /********************
         * REGRESS NOW
         ********************/
        gsl_vector *kernel;
        kernel = GaussKernel((double) sigma);
        
        /* Get variance estimate. */
        gsl_matrix_float *Q = NULL;
        Q = fmat_x_mat(XInv, Vc, Q);
        gsl_matrix_float *F = NULL; /* Variance (error) matrix. */
        F = fmat_x_matT(Q, XInv, F);
        
        NSNumber *val;
        float *fPointer;
        fPointer = F->data;
        for (size_t row = 0; row < numberExplanatoryVariables; row++) {
            for (size_t col = 0; col < numberExplanatoryVariables; col++) {
                val = [NSNumber numberWithFloat:(*fPointer)];
                [BCOVOutput setVoxelValue:val atRow:row col:col slice:0 timestep:0];
                fPointer++;
            }
        }
        
        gsl_matrix_float_free(Q);
        gsl_matrix_float_free(F);
        
        gsl_matrix_float *betaCovariates = NULL;
        betaCovariates = gsl_matrix_float_alloc(numberExplanatoryVariables, numberExplanatoryVariables);  
        fPointer = betaCovariates->data;
        for (size_t row = 0; row < numberExplanatoryVariables; row++) {
            for (size_t col = 0; col < numberExplanatoryVariables; col++) {
                *fPointer++ = [BCOVOutput getFloatVoxelValueAtRow:row col:col slice:0 timestep:0];
            }
        }
        gsl_matrix_float_transpose(betaCovariates);
        
		gsl_vector_float *gslContrastVector = gsl_vector_float_alloc([contrastVector count]);
		for (size_t i = 0; i < [contrastVector count]; i++){
			gslContrastVector->data[i] = [[contrastVector objectAtIndex:i] floatValue];	}
        
        gsl_vector_float *tmp = NULL;
        tmp = fmat_x_vector(betaCovariates, gslContrastVector, tmp);
        
        float variance = fskalarproduct(tmp, gslContrastVector);
        float new_sigma = sqrt(variance);
        
        gsl_matrix_float_free(betaCovariates);
        /* END Get variance estimate. */
        
        gsl_matrix_float_free(X);
        
        /* Process. */
        __block int npix = 0;
        
        for (size_t slice = 0; slice < numberSlices; slice++) {
            
            if (slice % 5 == 0) {
                fprintf(stderr, " slice: %3zd\r", slice);
            }
            //NSLog(@" Sl: %lu, TS: %lu", numberSlices, numberBands);
            
            if (TRUE == [data sliceIsZero:slice ]) {
                
                dispatch_apply(numberRows, queue, ^(size_t row) {
                    dispatch_apply(numberCols, queue, ^(size_t col) {
                        
                        if ([data getFloatVoxelValueAtRow:row col:col slice:slice timestep:0] >=  minval + 1) {
                            npix++;
                            float sum = 0.0L;
                            float sum2 = 0.0L;
                            float nx = 0.0L;
                            gsl_vector_float *y = gsl_vector_float_alloc(sliding_window_size);
                            
                            float *ptr1 = y->data;//y->data;
                            size_t i;
                            float u;
                            
                            for (i = (lastTimestep - sliding_window_size); i < lastTimestep; i++) {
                                u = [data getFloatVoxelValueAtRow:row col:col slice:slice timestep:i];
                                (*ptr1++) = u;
                                sum += u;
                                sum2 += u * u;
                                nx++;
                            }
                            
                            float mean = sum / nx;
                            float sig = sqrt((double) ((sum2 - nx * mean * mean) / (nx - 1.0)));
                            if (sig >= 0.001) {
                                
                                /* centering and scaling, Seber, p.330 */
                                ptr1 = y->data;//y->data;
                                for (i = 0; i < sliding_window_size; i++) {
                                    u = ((*ptr1) - mean) / sig;
                                    (*ptr1++) = u + 100.0;
                                }
                                
                                gsl_vector_float *ys = gsl_vector_float_alloc(sliding_window_size);
                                /* S x y */
                                ys = VectorConvolve(y, ys, kernel);
                                
                                gsl_vector_float *beta = gsl_vector_float_alloc(numberExplanatoryVariables);
                                /* compute betas */
                                fmat_x_vector(XInv, ys, beta);
                                
                                /* mResOutput (residual image) computation. */
                                gsl_vector_float *z = gsl_vector_float_alloc(sliding_window_size);
                                fmat_x_vector(SX, beta, z);
                                float err = 0.0;
                                float d;
                                ptr1 = ys->data;
                                float *ptr2 = z->data;
                                for (i = 0; i < sliding_window_size; i++) {
                                    d = ((*ptr1++) - (*ptr2++));
                                    err += d * d;
                                }
                                                            
                                /* sigma^2 */
                                float var = err / trace;
                                NSNumber *val = [NSNumber numberWithFloat:var];
                                
                                /* Write residuals output. */
								//STCHANGE!
                                //[mResOutput setVoxelValue:val atRow:row col:col slice:0 timestep:slice];
								[resOutput setVoxelValue:val atRow:row col:col slice:slice timestep:0];
                                
                                /* Write beta output. */
                                ptr1 = beta->data;
                                for (i = 0; i < numberExplanatoryVariables; i++) {
                                    val = [NSNumber numberWithFloat:(*ptr1)];
									//STCHANGE!
                                    //[mBetaOutput setVoxelValue: val atRow:row col:col slice:i timestep:slice];
									[betaOutput setVoxelValue: val atRow:row col:col slice:slice timestep:i];
                                    ptr1++;
                                }
                                gsl_vector_float_free(beta);
                                gsl_vector_float_free(ys);
                                gsl_vector_float_free(z);
                                
                                /* Computes mResMap (currently just t-image). */
                                float t = 0.0;
                                float z_value = 0.0;
                                float sum = 0.0;
                                float s = 0.0;
                                float tsigma = 0.0;
                                beta = gsl_vector_float_alloc(numberExplanatoryVariables);
                                
                                ptr1 = beta->data;
                                for (i = 0; i < numberExplanatoryVariables; i++) {
									
									*ptr1++ = [betaOutput getFloatVoxelValueAtRow:row col:col slice:slice timestep:i];
                                }
                                sum = fskalarproduct(beta, gslContrastVector);
                                if (fabs(sum) >= 1.0e-10) {
									
									s = [resOutput getFloatVoxelValueAtRow:row col:col slice:slice timestep:0];
                                    tsigma = sqrt(s) * new_sigma;
                                    if (tsigma > 0.00001) {
                                        t = sum / tsigma;
                                    } else {
                                        t = 0.0;
                                    }
                                    if (isnan(t) || isinf(t)) {
                                        t = 0.0;
                                    }
                                    z_value = t; // currently redundand - but when we compute more than just the t-image, we can't replace z by t
                                    if (isnan(z_value) || isinf(z_value)) {
                                        z_value = 0.0;
                                    }
                                    val = [NSNumber numberWithFloat:z_value];
                                    [resMap setVoxelValue:val atRow:row col:col slice:slice timestep:0];
                                }
                                
                                gsl_vector_float_free(beta);
                                
                            }
                            gsl_vector_float_free(y);
                        }
                    });
                });
            }
        }
        gsl_vector_float_free(gslContrastVector);
        gsl_matrix_float_free(XInv);
        gsl_matrix_float_free(SX);
        
        if (npix == 0) {
            NSLog(@" no voxels above threshold %d found", minval);
        }
        
        [betaOutput release];
        [resOutput release];
        [BCOVOutput release];
        dispatch_release(queue);
    
        return [resMap autorelease];
    }
    
    return nil;
}


-(float_t)CalcSigma:(float_t)fwhm forRepTime:(NSUInteger)repTime
{
    float sigma = 0.0;
    float repetitionTime = (float) repTime/1000;
    
	if (repetitionTime > 0.001 && fwhm > 0.001) {
		printf(" TR: %.3f seconds\n", repetitionTime);
		// the relation between fwhm and sigma for gauss is: fwhm = sqrt(8*ln(2))*sigma what is approx. 2.35482
		sigma = fwhm / 2.35482;
		sigma /= repetitionTime;
		if (sigma < 0.1) {
			NSLog(@" 'fwhm/sigma' too small (%.3f / %.3f), will be set to zero", fwhm, sigma);
			sigma = 0.0;
		}
	}
    return sigma;
}

//- (void)createOutputImages:(NEDesignElement*)des fromData:(EDDataElement*)data
//{
//        
//  
//	BARTImageSize *s = [[data mImageSize] copy];
//	s.timesteps = des.mNumberExplanatoryVariables;
//	mBetaOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_BETAS];
//	
//	NSArray *propsToCopy = [NSArray arrayWithObjects:
//							 @"voxelsize",
//							 @"subjectName",
//							 @"caPos",
//							 @"voxelGap", 
//							 @"repetitionTime",
//							 @"capos",
//							 @"subjectAge",
//							 @"subjectWEIGHT",
//							 @"flipAngle",
//							 @"echoTime",
//							 @"acquisitionTime",
//							@"rowVec",
//							@"sliceVec",
//							@"columnVec",
//							@"sequenceNumber",
//							@"indexOrigin",
//							 nil];
//	
//	[mBetaOutput copyProps:propsToCopy fromDataElement:data];
//
//	s.timesteps = 1;
//    mResOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
//	[mResOutput copyProps:propsToCopy fromDataElement:data];
//	mResMap = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
//	[ mResMap copyProps:propsToCopy fromDataElement:data];
//	mBCOVOutput = [[EDDataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:des.mNumberExplanatoryVariables andCols:des.mNumberExplanatoryVariables andSlices:1 andTimesteps:1];
//    [s release];
//}

@end
