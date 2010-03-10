//
//  BAAnalyzerGLM.m
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BAAnalyzerGLM.h"
#import "BADataElement.h"
#import "BADesignElement.h"
#import "BAGUIProtoCGLayer.h"

#import "gsl/gsl_cblas.h"
#import "gsl/gsl_matrix.h"
#import "gsl/gsl_vector.h"
#import "gsl/gsl_blas.h"
#import "gsl_utils.h"

extern gsl_vector *GaussKernel(double);
extern void GaussMatrix(double, gsl_matrix_float *);
extern gsl_vector_float *VectorConvolve(gsl_vector_float *, gsl_vector_float *,
										gsl_vector *);

@interface BAAnalyzerGLM (PrivateMethods)

    BADataElement *mBetaOutput;
    BADataElement *mResOutput;
    BADataElement *mResMap;
    BADataElement *mBCOVOutput;
    // BADataElement *mKXOutput;
    NSTimer *timerToFakeRepetitionTime;
    int indexForTimestep;
    int slidingWindowSize;
	BOOL mSlidingWindowAnalysis;
     
-(void)Regression:(short)minval
                 :(int)sliding_window_size
                 :(int)last_timestep;

-(float_t)CalcSigma:(float_t)fwhm;

-(void)createOutputImages;

-(void)stopTimer;

-(void)startTimer;

-(void)OnNewData:(NSTimer*)timer;

@end

@implementation BAAnalyzerGLM

-(id)init
{
    slidingWindowSize = 40;
	mSlidingWindowAnalysis = YES;
    indexForTimestep = slidingWindowSize;
    gui = [BAGUIProtoCGLayer getGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnNewData:) name:@"MessageName" object:nil];
    return self;
}

-(void)anaylzeTheData:(BADataElement*) data withDesign:(BADesignElement*) design
//-(BOOL)anaylzeTheData:(BOOL) findParameters
{
    mDesign = design;
    mData = data;
    /*
     * create output images
     */
    [self createOutputImages];
    [self startTimer];

    return;
}

-(void)dealloc
{
    if (timerToFakeRepetitionTime) {
        [timerToFakeRepetitionTime invalidate];
        [timerToFakeRepetitionTime release];
    }
    [mBetaOutput release];
    [super dealloc];
}


// Create and start the timer that triggers a refetch every few seconds
- (void)startTimer 
{
    [self stopTimer];
    timerToFakeRepetitionTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnNewData:) userInfo:nil repeats:YES];
    [timerToFakeRepetitionTime retain];
}


// Stop the timer; prevent future loads until startTimer is called again
- (void)stopTimer 
{
    if (timerToFakeRepetitionTime) {
        [timerToFakeRepetitionTime invalidate];
        [timerToFakeRepetitionTime release];
        timerToFakeRepetitionTime = nil;
    }
}


-(void)OnNewData:(NSTimer*)timer
{
    printf("Timestep %i\n", indexForTimestep);
    if (timer)
    {
        [self stopTimer];
        
        NSLog(@"Time analysis: Start");
        
		int index = 0;
		if (mSlidingWindowAnalysis){
			index = slidingWindowSize;}
		else {
			index = indexForTimestep;}

        [self Regression:2000 
                        :index // sw: slidingWindowSize akk: indexForTimestep
                        :indexForTimestep];
        [self sendFinishNotification];
        [gui setForegroundImage:mResMap];
		[gui setTimesteps:indexForTimestep andSlidWindSize:index];
		
        
        NSLog(@"Time analysis: End");
        
        indexForTimestep++;
        if (indexForTimestep < mData.numberTimesteps){
            [self startTimer];
        } else {
            [mBetaOutput WriteDataElementToFile:@"/tmp/outfromBART.v"];
            [mResOutput WriteDataElementToFile:@"/tmp/outfromBART.v"];
        }
    }
}

-(void)sendFinishNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AnalyzeGLMFinished" object:self];
}


-(void)Regression:(short)minval
                 :(int)sliding_window_size
                 :(int)lastTimestep {
    
    if (sliding_window_size <= lastTimestep) { 
        
        int numberBands = mData.numberTimesteps;
        int numberSlices = mData.numberSlices;
        int numberRows = mData.numberRows;
        int numberCols = mData.numberCols;
        int numberExplanatoryVariables = mDesign.numberExplanatoryVariables;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); /* Global asyn. dispatch queue. */
        
        gsl_set_error_handler_off();
        
        // C1) If there are more than one input image - test for dimensions
        
        if (numberExplanatoryVariables >= MBETA) {
            NSLog(@" too many covariates (%d), max is %d", numberExplanatoryVariables, MBETA);
        }
        if (mDesign.numberTimesteps != numberBands) {
            NSLog(@" design dimension inconsistency: %d (numberTimesteps design) %d (numberTimesteps data)", 
                  mDesign.numberTimesteps, numberBands);
        }
        
        /* Read design matrix. */
        gsl_matrix_float *X = NULL; /* mDesign matrix. */
        X = gsl_matrix_float_alloc(sliding_window_size, numberExplanatoryVariables);
        double x; /* One entry of matrix X. */
        for (int timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            for (int covariate = 0; covariate < numberExplanatoryVariables; covariate++) {
// TODO: use getFloatValue... (performance increase!)
                x = [[mDesign getValueFromExplanatoryVariable:covariate atTimestep:timestep] floatValue];
                fmset(X, timestep - (lastTimestep - sliding_window_size), covariate, (float) x);
            }
        }
        
        /*
         * pre-coloring, set up K-matrix, S=K, V = K*K^T with K=S
         * K ... correlation matrix
         */
//TODO: fwhm aus Konfig
        float fwhm = 4.0;
        float_t sigma = [self CalcSigma:fwhm];
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
        for (int timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            trace += fmget(RV, timestep - (lastTimestep - sliding_window_size), timestep - (lastTimestep - sliding_window_size));
        }
        
        P = fmat_x_mat(RV, RV, P);
        
        float trace2 = 0.0;
        for (int timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            trace2 += fmget(P, timestep - (lastTimestep - sliding_window_size), timestep - (lastTimestep - sliding_window_size));
        }

        float df = (trace * trace) / trace2; /* df ... Degrees of freedom. */
        printf(" df = %.3f\n", df);
        
        [mBetaOutput setImageProperty:PROPID_DF withValue:[NSNumber numberWithFloat:df]];
        [mResOutput setImageProperty:PROPID_DF withValue:[NSNumber numberWithFloat:df]];
        
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
        for (int row = 0; row < numberExplanatoryVariables; row++) {
            for (int col = 0; col < numberExplanatoryVariables; col++) {
                val = [NSNumber numberWithFloat:(*fPointer)];
                [mBCOVOutput setVoxelValue:val atRow:row col:col slice:0 timestep:0];
                fPointer++;
            }
        }
        
        gsl_matrix_float_free(Q);
        gsl_matrix_float_free(F);
        
        gsl_matrix_float *betaCovariates = NULL;
        betaCovariates = gsl_matrix_float_alloc(numberExplanatoryVariables, numberExplanatoryVariables);  
        fPointer = betaCovariates->data;
        for (int row = 0; row < numberExplanatoryVariables; row++) {
            for (int col = 0; col < numberExplanatoryVariables; col++) {
                *fPointer++ = [mBCOVOutput getFloatVoxelValueAtRow:row col:col slice:0 timestep:0];
            }
        }
        gsl_matrix_float_transpose(betaCovariates);
        
		float contrast[mDesign.numberExplanatoryVariables];
		//TODO
		//for (int i = 0; i < mDesign.numberExplanatoryVariables; i++){
		contrast[0] = 1.0;
		contrast[1] = 0.0;
		contrast[2] = 0.0;
        //float contrast[3] = {1.0, -1.0, 0.0};
        gsl_vector_float *contrastVector;
        contrastVector = gsl_vector_float_alloc(mDesign.numberExplanatoryVariables);
        //contrastVector = gsl_vector_float_alloc(3);
        contrastVector->data = contrast;
        
        gsl_vector_float *tmp = NULL;
        tmp = fmat_x_vector(betaCovariates, contrastVector, tmp);
        float variance = fskalarproduct(tmp, contrastVector);
        float new_sigma = sqrt(variance);
        
        gsl_matrix_float_free(betaCovariates);
        /* END Get variance estimate. */
        
        gsl_matrix_float_free(X);
        
        /* Process. */
        __block int npix = 0;
        for (int slice = 0; slice < numberSlices; slice++) {
            
            if (slice % 5 == 0) {
                fprintf(stderr, " slice: %3d\r", slice);
            }
            
            if (TRUE == [mData sliceIsZero:slice ]) {
                
                dispatch_apply(numberRows, queue, ^(size_t row) {
                    dispatch_apply(numberCols, queue, ^(size_t col) {
                        
                        if ([mData getFloatVoxelValueAtRow:row col:col slice:slice timestep:0] >=  minval + 1) {
                            npix++;
                            float sum = 0.0;
                            float sum2 = 0.0;
                            float nx = 0.0;
                            gsl_vector_float *y = gsl_vector_float_alloc(sliding_window_size);
                            float *ptr1 = y->data;
                            int i;
                            float u;
                            
                            for (i = (lastTimestep - sliding_window_size); i < lastTimestep; i++) {
                                u = [mData getFloatVoxelValueAtRow:row col:col slice:slice timestep:i];
                                (*ptr1++) = u;
                                sum += u;
                                sum2 += u * u;
                                nx++;
                            }
                                                        
                            float mean = sum / nx;
                            float sig = sqrt((double) ((sum2 - nx * mean * mean) / (nx - 1.0)));
                            if (sig >= 0.001) {
                                
                                /* centering and scaling, Seber, p.330 */
                                ptr1 = y->data;
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
                                [mResOutput setVoxelValue:val atRow:row col:col slice:0 timestep:slice];
                                
                                /* Write beta output. */
                                ptr1 = beta->data;
                                for (i = 0; i < numberExplanatoryVariables; i++) {
                                    val = [NSNumber numberWithFloat:(*ptr1)];
                                    [mBetaOutput setVoxelValue: val atRow:row col:col slice:i timestep:slice];
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
                                    *ptr1++ = [mBetaOutput getFloatVoxelValueAtRow:row col:col slice:i timestep:slice];
                                }
                                sum = fskalarproduct(beta, contrastVector);
                                if (fabs(sum) >= 1.0e-10) {
                                    s = [mResOutput getFloatVoxelValueAtRow:row col:col slice:0 timestep:slice];
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
                                    [mResMap setVoxelValue:val atRow:row col:col slice:0 timestep:slice];
                                }
                                
                                gsl_vector_float_free(beta);
                                
                            }
                            gsl_vector_float_free(y);
                        }
                    });
                });
            }
        }
        gsl_vector_float_free(contrastVector);
        gsl_matrix_float_free(XInv);
        gsl_matrix_float_free(SX);
        
        if (npix == 0) {
            NSLog(@" no voxels above threshold %d found", minval);
        }
    }
}


-(float_t)CalcSigma:(float_t)fwhm
{
    float sigma = 0.0;
    float repetitionTime = (float) mDesign.repetitionTimeInMs/1000;
    
	if (repetitionTime > 0.001 && fwhm > 0.001) {
		printf(" TR: %.3f seconds\n", repetitionTime);
		sigma = fwhm / 2.35482;
		sigma /= repetitionTime;
		if (sigma < 0.1) {
			NSLog(@" 'fwhm/sigma' too small (%.3f / %.3f), will be set to zero", fwhm, sigma);
			sigma = 0.0;
		}
	}
    return sigma;
}

- (void)createOutputImages
{
        
   // NSArray *betaProps = [[NSArray alloc] initWithObjects:PROPID_CA, 
//                          PROPID_CP, 
//                          PROPID_FIXPOINT, 
//                          PROPID_EXTENT, 
//                          PROPID_PATIENT, 
//                          PROPID_TALAIRACH, 
//                          PROPID_VOXEL, 
//                          nil];
//   /*mData.numberRows*/
    mBetaOutput = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mData.numberRows andCols:mData.numberCols andSlices:mDesign.numberExplanatoryVariables andTimesteps:mData.numberSlices];

    [mBetaOutput setImageProperty:PROPID_PATIENT    withValue:[mData getImageProperty:PROPID_PATIENT]];
    [mBetaOutput setImageProperty:PROPID_VOXEL      withValue:[mData getImageProperty:PROPID_VOXEL]];
    [mBetaOutput setImageProperty:PROPID_REPTIME    withValue:[NSNumber numberWithLong:mDesign.repetitionTimeInMs]];
    [mBetaOutput setImageProperty:PROPID_TALAIRACH  withValue:[mData getImageProperty:PROPID_TALAIRACH]];
    //if ('N' != [[mData getImageProperty:PROPID_FIXPOINT] UTF8String]){
    [mBetaOutput setImageProperty:PROPID_FIXPOINT   withValue:[mData getImageProperty:PROPID_FIXPOINT]];//}
    
//    if ('N' != [[mData getImageProperty:PROPID_CA] charValue]){
    [mBetaOutput setImageProperty:PROPID_CA         withValue:[mData getImageProperty:PROPID_CA]];
    [mBetaOutput setImageProperty:PROPID_CP         withValue:[mData getImageProperty:PROPID_CP]];
    [mBetaOutput setImageProperty:PROPID_EXTENT     withValue:[mData getImageProperty:PROPID_EXTENT]];
  //  }
    
    [mBetaOutput setImageProperty:PROPID_NAME       withValue:@"BETA"];
    [mBetaOutput setImageProperty:PROPID_MODALITY   withValue:@"BETA"];
    //[mBetaOutput setImageProperty:PROPID_DF         withValue:[NSNumber numberWithFloat:*df]];
    [mBetaOutput setImageProperty:PROPID_VOXEL      withValue:[mData getImageProperty:PROPID_VOXEL]];
    
    
    //m_BetaImages[i] = VCreateImage(nslices, nrows, ncols, VFloatRepn);
    //
    //mResOutput = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mData.numberRows andCols:mData.numberCols andSlices:mData.numberSlices andTimesteps:1];
    //mBCOVOutput = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mDesign.numberCols andCols:mDesign.numberCols andSlices:1 andTimesteps:1];

    mResOutput = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mData.numberRows andCols:mData.numberCols andSlices:1 andTimesteps:mData.numberSlices];
    
    [mResOutput setImageProperty:PROPID_NAME        withValue:@"RES/trRV"];
    [mResOutput setImageProperty:PROPID_MODALITY    withValue:@"RES/trRV"];
    [mResOutput setImageProperty:PROPID_PATIENT     withValue:[mData getImageProperty:PROPID_PATIENT]];
    [mResOutput setImageProperty:PROPID_VOXEL       withValue:[mData getImageProperty:PROPID_VOXEL]];
    [mResOutput setImageProperty:PROPID_REPTIME     withValue:[NSNumber numberWithLong:mDesign.repetitionTimeInMs]];
    [mResOutput setImageProperty:PROPID_TALAIRACH   withValue:[mData getImageProperty:PROPID_TALAIRACH]];
    //if ('N' != [[mData getImageProperty:PROPID_FIXPOINT] UTF8String]) {
	[mResOutput setImageProperty:PROPID_FIXPOINT    withValue:[mData getImageProperty:PROPID_FIXPOINT]];
	//}
	//if ('N' != [[mData getImageProperty:PROPID_CA] charValue]) {
	[mResOutput setImageProperty:PROPID_CA         withValue:[mData getImageProperty:PROPID_CA]];
    [mResOutput setImageProperty:PROPID_CP         withValue:[mData getImageProperty:PROPID_CP]];
    [mResOutput setImageProperty:PROPID_EXTENT     withValue:[mData getImageProperty:PROPID_EXTENT]];
	//}
    
    mResMap = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mData.numberRows andCols:mData.numberCols andSlices:1 andTimesteps:mData.numberSlices];
    [mResMap setImageProperty:PROPID_NAME        withValue:@"tmap"]; // TODO: name variably based on ResMap type
    [mResMap setImageProperty:PROPID_MODALITY    withValue:@"tmap"]; // TODO: name variably based on ResMap type
    //[mResMap setImageProperty:PROPID_CONTRAST    withValue:<#(id)value#>]
    
    mBCOVOutput = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT andRows:mDesign.numberExplanatoryVariables andCols:mDesign.numberExplanatoryVariables andSlices:1 andTimesteps:1];
}

@end
