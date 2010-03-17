//
//  BADesignElementDyn.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BADesignElementDyn.h"



#include <viaio/VImage.h>

#import "COSystemConfig.h"

extern int VStringToken (char *, char *, int, int);

// komische Konstanten erstmal aus vgendesign.c (Lipsia) uebernommen


//@interface BADesignElementDyn (PrivateMethods)


/* Other Attributes set up by initDesign. Main use in generate Design. */




///* Other Attributes END. */
//
//-(NSError*)parseInputFile:(NSString*)path;
//-(NSError*)initDesign;
//
//-(Complex)complex_mult:(Complex)a :(Complex)b;
//-(double)xgamma:(double)xx :(double)t0;//TODO check functions
//-(double)bgamma:(double)xx :(double)t0;
//-(double)deriv1_gamma:(double)x :(double)t0;
//-(double)deriv2_gamma:(double)x :(double)t0;
//-(double)xgauss:(double)xx :(double)t0;
//
//-(BOOL)test_ascii:(int)val;
//-(void)Convolve:(unsigned int)col
//				:(unsigned int) eventNr
//               :(fftw_complex *)fkernel;
///* Utility function for TrialList. */
//-(void)tl_append:(TrialList*)head
//                :(TrialList*)newLast;
//
//-(NSError*)getPropertiesFromConfig;
//
//-(NSError*)correctForZeromean;



//@end

@implementation BADesignElementDyn

const int BUFFER_LENGTH = 10000;
const int MAX_NUMBER_EVENTS = 100;
double samplingRateInMs = 20.0;           /* Temporal resolution for convolution is 20 ms. */
double t1 = 30.0;              /* HRF duration / Breite der HRF.                */
const TrialList TRIALLIST_INIT = { {0,0,0,0}, NULL};



/* Standard parameter values for gamma function, Glover 99. */
double a1 = 6.0;     
double b1 = 0.9;
double a2 = 12.0;
double b2 = 0.9;
double cc = 0.35;



// TODO: check if imageDataType still needed (here: float)
-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    self = [super init];
    
    if (type == IMAGE_DATA_FLOAT) {
        mImageDataType = type;
    } else {
        NSLog(@" BADesignElementDyn.initWithFile: defaulting to IMAGE_DATA_FLOAT (other values are not supported)!");
        mImageDataType = IMAGE_DATA_FLOAT;
    }
	
    mTrialList = (TrialList**) malloc(sizeof(TrialList*) * MAX_NUMBER_EVENTS);
    for (int i = 0; i < MAX_NUMBER_EVENTS; i++) {
        mTrialList[i] = NULL;
    }
	
	if (nil != [self getPropertiesFromConfig]){
		return nil;
	}
	
			
    NSLog(@"GenDesign GCD: START");
	[self parseInputFile:path];
	NSLog(@"GenDesign GCD: PARSE");
    [self initDesign];
	NSLog(@"GenDesign GCD: INIT");   
    [self generateDesign];
    NSLog(@"GenDesign GCD: END");
    
    if (mNumberCovariates > 0) {
        mCovariates = (float**) malloc(sizeof(float*) * mNumberCovariates);
        for (unsigned int cov = 0; cov < mNumberCovariates; cov++) {
            mCovariates[cov] = (float*) malloc(sizeof(float) * mNumberTimesteps);
            memset(mCovariates[cov], 0.0, sizeof(float) * mNumberTimesteps);
        }
    }
     
    mNumberRegressors = mNumberEvents * (mDerivationsHrf + 1) + 1;
    mNumberExplanatoryVariables = mNumberRegressors + mNumberCovariates;
	[self writeDesignFile:@"/tmp/testDesign.v"];
	return self;
}

-(id)initWithDynamicDataOfImageDataType:(enum ImageDataType)type
{
    self = [super init];
    
    if (type == IMAGE_DATA_FLOAT) {
        mImageDataType = type;
    } else {
        NSLog(@" BADesignElementDyn.initWithFile: defaulting to IMAGE_DATA_FLOAT (other values are not supported)!");
        mImageDataType = IMAGE_DATA_FLOAT;
    }
    
    mTrialList = (TrialList**) malloc(sizeof(TrialList*) * MAX_NUMBER_EVENTS);
    for (int i = 0; i < MAX_NUMBER_EVENTS; i++) {
        mTrialList[i] = NULL;
    }
	mNumberEvents = 4;//TODO get from config
	mNumberTimesteps = 396; //TODO get from config
    
    NSLog(@"GenDesign GCD: START");
    [self initDesign];
    [self generateDesign];
    NSLog(@"GenDesign GCD: END");
    
    if (mNumberCovariates > 0) {
        mCovariates = (float**) malloc(sizeof(float*) * mNumberCovariates);
        for (unsigned int cov = 0; cov < mNumberCovariates; cov++) {
            mCovariates[cov] = (float*) malloc(sizeof(float) * mNumberTimesteps);
            memset(mCovariates[cov], 0.0, sizeof(float) * mNumberTimesteps);
        }
    }
	
	
    mNumberRegressors = mNumberEvents * (mDerivationsHrf + 1) + 1;
    mNumberExplanatoryVariables = mNumberRegressors + mNumberCovariates;
    
	
    //[self writeDesignFile:@"/tmp/testDesign.v"];
    
    return self;
}



-(NSError*)getPropertiesFromConfig
{
	COSystemConfig *config = [COSystemConfig getInstance];
	
	//TODO:  Will be initialized somewhere else
	NSError *err = [config initializeWithContentsOfEDLFile:@"../../tests/CLETUSTests/Init_Links_1.edl"];
	NSLog(@"%@", err);
	if ( nil != err){
		NSLog(@"Where the hell is the edl file");
		return err;
	}
	
	NSString* config_tr = [config getProp:@"/rtExperiment/experimentData/imageModalities/TR"];
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	//TODO : Abfrage Einheit der repetition Time
	mRepetitionTimeInMs = 1000;//[[f numberFromString:config_tr] intValue];
	NSString* config_nrTimesteps = [config getProp:@"/rtExperiment/..."];
	mNumberTimesteps = 720;//[[f numberFromString:config_nrTimesteps] intValue]; //TODO get from config
	
	mNumberRegressors = 0;
	mNumberCovariates = 0;     // TODO: get from config  
	
	mDerivationsHrf = 0;
	
	
	[f release];//temp for conversion purposes
	
	
	mNumberSamplesForInit = (mNumberTimesteps * mRepetitionTimeInMs) / samplingRateInMs;
	
	
	/* Attributes that should be modifiable (were once CLI parameters). */
	//mKernelBlockDesignIsGamma = YES;
	//mBlockThreshold = 10.0; // in seconds
	
	
	return nil;
	


}

-(NSError*)initDesign
{
    // TODO: parameterize or/and use config
    float delay = 6.0;              
    float understrength = 0.35;
    float undershoot = 12.0;
    BOOL zeromean = YES;
    
        
	fprintf(stderr, " TR in ms = %d\n", mRepetitionTimeInMs);
	
	mTimeOfRepetitionStartInMs = (double *) malloc(sizeof(double) * mNumberTimesteps);
	for (unsigned int i = 0; i < mNumberTimesteps; i++) {
		mTimeOfRepetitionStartInMs[i] = (double) (i) * mRepetitionTimeInMs;//TODO: Gabi fragen letzter Zeitschritt im moment nicht einbezogen xx[i] = (double) i * tr * 1000.0;
	}

    unsigned long maxExpLengthInMs = mTimeOfRepetitionStartInMs[0] + mTimeOfRepetitionStartInMs[mNumberTimesteps - 1];
	
	NSLog(@"x[0]: %lf und xx[last] %lf", mTimeOfRepetitionStartInMs[0], mTimeOfRepetitionStartInMs[mNumberTimesteps - 1]);
    NSLog(@"Number timesteps: %d,  experiment duration: %.2f min\n", mNumberTimesteps, maxExpLengthInMs / 60000.0);
    
    maxExpLengthInMs += 10000; /* add 10 seconds to avoid FFT problems (wrap around) */
    
    /* set gamma function parameters */
    a1 = delay;
    a2 = undershoot;
    cc = understrength;
    
    /*
     ** check amplitude: must have zero mean for parametric designs
	 ** for not parametric nothing will be corrected due to check of stddev
     */
    if (YES == zeromean) { 
		[self correctForZeromean];
	}
    if (mNumberEvents < 1) {
        return [NSError errorWithDomain:@"No events were found!" code:NO_EVENTS_FOUND userInfo:nil];
    }
    
    float xmin;
    int ncols = 0;
    for (unsigned int i = 0; i < mNumberEvents; i++) {
        
        xmin = FLT_MAX;
        
        TrialList* currentTrial;
        currentTrial = mTrialList[i];
        
        while (currentTrial != NULL) {
            if (currentTrial->trial.duration < xmin) {
                xmin = currentTrial->trial.duration;
            }
            currentTrial = currentTrial->next;
        }
        
        if (0 == mDerivationsHrf) {
            ncols++;
        } else if (1 == mDerivationsHrf) {
            ncols += 2;
        } else if (2 == mDerivationsHrf) {
            ncols += 3;
        }
    }
    
    NSLog(@"# number of events: %d,  num columns in design matrix: %d\n", mNumberEvents, ncols + 1);
    
    mDesign = (float**) malloc(sizeof(float*) * (ncols + 1));
    for (int col = 0; col < ncols + 1; col++) {
        mDesign[col] = (float*) malloc(sizeof(float) * mNumberTimesteps);
         for (int ts = 0; ts < mNumberTimesteps; ts++) {
             if (col == ncols) {
                 mDesign[col][ts] = 1.0;
             } else {
                 mDesign[col][ts] = 0.0;
             }
         }
    }
    
	
    /* alloc memory */
    mNumberSamplesNeededForExp = (unsigned long) (maxExpLengthInMs / samplingRateInMs);
	NSLog(@"mNumberSamplesNeededForExp %d", mNumberSamplesNeededForExp);
	NSLog(@"total duration in ms %lf", maxExpLengthInMs);
    
        
    unsigned int numberSamplesInResult = (mNumberSamplesForInit / 2) + 1;//defined for results of fftw3

    /* make plans */
    mFftPlanForward = (fftw_plan *) malloc(sizeof(fftw_plan) * mNumberEvents);
    mFftPlanInverse = (fftw_plan *) malloc(sizeof(fftw_plan) * mNumberEvents);
    
    mBuffersForwardIn = (double **) malloc(sizeof(double *) * mNumberEvents);
    mBuffersForwardOut = (fftw_complex **) malloc(sizeof(fftw_complex *) * mNumberEvents);
    mBuffersInverseIn = (fftw_complex **) malloc(sizeof(fftw_complex *) * mNumberEvents);
    mBuffersInverseOut = (double **) malloc(sizeof(double *) * mNumberEvents);
    
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++) {
        
        mBuffersForwardIn[eventNr] = (double *) fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        mBuffersForwardOut[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * numberSamplesInResult);
        memset(mBuffersForwardIn[eventNr], 0, sizeof(double) * mNumberSamplesForInit);
        
        mBuffersInverseIn[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * numberSamplesInResult);
        mBuffersInverseOut[eventNr] = (double *) fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        memset(mBuffersInverseOut[eventNr], 0, sizeof(double) * mNumberSamplesForInit);

        mFftPlanForward[eventNr] = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, mBuffersForwardIn[eventNr], mBuffersForwardOut[eventNr], FFTW_ESTIMATE);
        mFftPlanInverse[eventNr] = fftw_plan_dft_c2r_1d(mNumberSamplesForInit, mBuffersInverseIn[eventNr], mBuffersInverseOut[eventNr], FFTW_ESTIMATE);
		
    }
    
    /* get kernel */
    double *blockKernel = NULL;
    blockKernel = (double *) fftw_malloc(sizeof(double) * mNumberSamplesForInit);
    mKernelBlockDeriv0 = (fftw_complex *) fftw_malloc (sizeof(fftw_complex) * numberSamplesInResult);
    memset(blockKernel,0, sizeof(double) * mNumberSamplesForInit);
    
    double *kernel0 = NULL;
    kernel0  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
    mKernelEventDeriv0 = (fftw_complex *)fftw_malloc (sizeof(fftw_complex) * numberSamplesInResult);
    memset(kernel0, 0, sizeof(double) * mNumberSamplesForInit);
    
    double *kernel1 = NULL;
    if (mDerivationsHrf >= 1) {
        kernel1  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        mKernelDeriv1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
        memset(kernel1,0,sizeof(double) * mNumberSamplesForInit);
    }
    
    double *kernel2 = NULL;
    if (mDerivationsHrf == 2) {
        kernel2  = (double *)fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        mKernelDeriv2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * numberSamplesInResult);
        memset(kernel2,0,sizeof(double) * mNumberSamplesForInit);
    }
	
    
    unsigned int indexS = 0;
    double dt = samplingRateInMs / 1000.0; /* Delta (temporal resolution) in seconds. */
    //unsigned int maxLengthHrfInMs = 30000; //TODO get from config
	//for (unsigned int indexSample = 0; indexSample < maxLengthHrfInMs; indexSample += samplingRateInMs) {
	for (double indexSample = 0; indexSample < t1; indexSample += dt) {
			
        if (indexSample >= mNumberSamplesForInit) break;        
        /* Gauss kernel for block designs */
		BOOL kernelBlockDesignIsGamma = YES; //TODO get from config
        if (NO == kernelBlockDesignIsGamma) {
            blockKernel[indexS] = [self xgauss:indexSample :5.0];
        } else {
            blockKernel[indexS] = [self bgamma:indexSample :0.0];
        }
        
        kernel0[indexS] = [self xgamma:indexSample :0];
        if (mDerivationsHrf >= 1) {
            kernel1[indexS] = [self deriv1_gamma:indexSample :0.0];
        }
        if (mDerivationsHrf == 2) {
            kernel2[indexS] = [self deriv2_gamma:indexSample :0.0];
        }
        indexS++;
    }
    
    /* fft for kernels */
    fftw_plan pkg;
    pkg = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, blockKernel, mKernelBlockDeriv0, FFTW_ESTIMATE);
    fftw_execute(pkg);
    
    fftw_plan pk0;
    pk0 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel0, mKernelEventDeriv0, FFTW_ESTIMATE);
    fftw_execute(pk0);
    
    fftw_plan pk1;
    if (mDerivationsHrf >= 1) {
        pk1 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel1, mKernelDeriv1, FFTW_ESTIMATE);
        fftw_execute(pk1);
    }
    
    fftw_plan pk2;
    if (mDerivationsHrf == 2) {
        pk2 = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, kernel2, mKernelDeriv2, FFTW_ESTIMATE);
        fftw_execute(pk2);
    }
    
    fftw_free(blockKernel);
    fftw_free(kernel0);
    fftw_free(kernel1);
    fftw_free(kernel2);
    
    return nil;
}

-(NSError*)generateDesign
{
    __block NSError* error = nil;
    
    dispatch_queue_t queue;       /* Global asyn. dispatch queue. */
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    /* For each event and trial do... */
    dispatch_apply(mNumberEvents, queue, ^(size_t eventNr) {
        memset(mBuffersForwardIn[eventNr], 0, sizeof(double) * mNumberSamplesForInit);
        
        /* get data */
        int trialcount = 0;
        double t0;
        double h;
		float blockThreshold = 10.0; //TODO get from config
        float minTrialDuration = blockThreshold;
        
        TrialList* currentTrial;
        currentTrial = mTrialList[eventNr];
        
        while (currentTrial != NULL) {
            trialcount++;
        
            if (currentTrial->trial.duration < minTrialDuration) {
                minTrialDuration = currentTrial->trial.duration;
            }
            t0 = currentTrial->trial.onset;
            double tmax = currentTrial->trial.onset + currentTrial->trial.duration;
            h  = currentTrial->trial.height;
            
            t0 *= 1000.0;
            tmax *= 1000.0;
            
            unsigned int k = t0 / samplingRateInMs;
            
            for (double t = t0; t <= tmax; t += samplingRateInMs) {
                if (k >= mNumberSamplesForInit) {
                    break;
                }
                mBuffersForwardIn[eventNr][k++] += h;
            }
            
            currentTrial = currentTrial->next;
        }
        
        if (trialcount < 1) {
            NSString* errorString = [NSString stringWithFormat:@"No trials in event %d, please re-number event-IDs!", eventNr + 1];
            error = [NSError errorWithDomain:errorString code:EVENT_NUMERATION userInfo:nil];
        }
        if (trialcount < 4) {
            NSLog(@"Warning: too few trials (%d) in event %d. Statistics will be unreliable.",
                  trialcount, eventNr + 1);
        }
        
        /* fft */
        fftw_execute(mFftPlanForward[eventNr]);
        unsigned int col = eventNr * (mDerivationsHrf + 1);
        
        if (minTrialDuration >= blockThreshold) {
            [self Convolve:col 
						  :eventNr
                          :mKernelBlockDeriv0];
        } else {
            [self Convolve:col
						  :eventNr
                          :mKernelEventDeriv0];
        }
        
        col++;
        
        if (mDerivationsHrf >= 1) {
            [self Convolve:col
						  :eventNr
                          :mKernelDeriv1];
            col++;
        }
        
        if (mDerivationsHrf == 2) {
            [self Convolve:col
						  :eventNr
                          :mKernelDeriv2];
        }
    });
    
    return error;
}

-(NSError*)parseInputFile:(NSString *)path
{
    
    int character;
    int trialID    = 0;
    float onset    = 0.0;
    float duration = 0.0;
    float height   = 0.0;
    
    mNumberTrials = 0;
    mNumberEvents = 0;
    
    FILE* inFile;
    char* inputFilename = (char*) malloc(sizeof(char) * UINT16_MAX);
    [path getCString:inputFilename maxLength:UINT16_MAX  encoding:NSUTF8StringEncoding];
    
    inFile = fopen(inputFilename, "r");
    char buffer[BUFFER_LENGTH];
    
    while (!feof(inFile)) {
        for (int j = 0; j < BUFFER_LENGTH; j++) {
            buffer[j] = '\0';
        }
        fgets(buffer, BUFFER_LENGTH, inFile);
        if (strlen(buffer) >= 2) {
            
            // TODO: Maybe remove this check
            if (![self test_ascii:((int) buffer[0])]) {
                NSLog(@" input file must be a text file");
            }
            
            if (buffer[0] != '%' && buffer[0] != '#') {
                /* remove non-alphanumeric characters */
                for (unsigned int j = 0; j < strlen(buffer); j++) {
                    character = (int) buffer[j];
                    if (!isgraph(character) && buffer[j] != '\n' && buffer[j] != '\r' && buffer[j] != '\0') {
                        buffer[j] = ' ';
                    }
                    
                    /* remove tabs */
                    if (buffer[j] == '\v') {
                        buffer[j] = ' ';
                    }
                    if (buffer[j] == '\t') {
                        buffer[j] = ' ';
                    }
                }
                
                if (sscanf(buffer, "%d %f %f %f", &trialID, &onset, &duration, &height) != 4) {

                    NSString* errorString = 
                        [NSString stringWithFormat:
                            @"Illegal design file input format (at line %d)! Expected format: one entry per line and columns separated by tabs.", mNumberTrials + 1];
                    return [NSError errorWithDomain:errorString code:ILLEGAL_INPUT_FORMAT userInfo:nil];
                    
                }
                
                if (duration < 0.5 && duration >= -0.0001) {
                    duration = 0.5;
                }

                Trial newTrial;
                newTrial.id       = trialID;
                newTrial.onset    = onset;
                newTrial.duration = duration;
                newTrial.height   = height;
                
                TrialList* newListEntry;
                newListEntry = (TrialList*) malloc(sizeof(TrialList));
                *newListEntry = TRIALLIST_INIT;
                newListEntry->trial = newTrial;
                
                if (mTrialList[trialID - 1] == NULL) {
                    mTrialList[trialID - 1] = newListEntry;
                    mNumberEvents++;
                } else {
                    [self tl_append:mTrialList[trialID - 1] :newListEntry];
                }
                
                mNumberTrials++;
            }
        }
    }
    fclose(inFile);  
    free(inputFilename);
    
    return nil;
}

-(NSError*)writeDesignFile:(NSString*) path 
{
    VImage outDesign = NULL;
    outDesign = VCreateImage(1, mNumberTimesteps, mNumberRegressors, VFloatRepn);
    
    VSetAttr(VImageAttrList(outDesign), "modality", NULL, VStringRepn, "X");
    VSetAttr(VImageAttrList(outDesign), "name", NULL, VStringRepn, "X");
    VSetAttr(VImageAttrList(outDesign), "repetition_time", NULL, VLongRepn, (VLong) mRepetitionTimeInMs);
    VSetAttr(VImageAttrList(outDesign), "ntimesteps", NULL, VLongRepn, (VLong) mNumberTimesteps);
    
    VSetAttr(VImageAttrList(outDesign), "derivatives", NULL, VShortRepn, mDerivationsHrf);
    
    // evil: Copy&Paste from initDesign()
    static float delay = 6.0;              
    static float understrength = 0.35;
    static float undershoot = 12.0;
    char buf[BUFFER_LENGTH];
    
    VSetAttr(VImageAttrList(outDesign), "delay", NULL, VFloatRepn, delay);
    VSetAttr(VImageAttrList(outDesign), "undershoot", NULL, VFloatRepn, undershoot);
    sprintf(buf, "%.3f", understrength);
    VSetAttr(VImageAttrList(outDesign), "understrength", NULL, VStringRepn, &buf);
    
    VSetAttr(VImageAttrList(outDesign), "nsessions", NULL, VShortRepn, (VShort) 1);
    VSetAttr(VImageAttrList(outDesign), "designtype", NULL, VShortRepn, (VShort) 1);
    
    for (unsigned int col = 0; col < mNumberRegressors; col++) {
        for (unsigned int ts = 0; ts < mNumberTimesteps; ts++) {
				VPixel(outDesign, 0, ts, col, VFloat) = (VFloat) mDesign[col][ts];
        }
    }
    
    
    VAttrList out_list = NULL;                         
    out_list = VCreateAttrList();
    VAppendAttr(out_list, "image", NULL, VImageRepn, outDesign);
    
    // Numbers taken from Plot_gamma()
    int ncols = (int) (28.0 / 0.2);
    int nrows = mDerivationsHrf + 2;
    VImage plot_image = NULL;
    plot_image = VCreateImage(1, nrows, ncols, VFloatRepn);
    float** plot_image_raw = NULL;
    plot_image_raw = [self Plot_gamma];
    
    for (int col = 0; col < ncols; col++) {
        for (int row = 0; row < nrows; row++) {
            VPixel(plot_image, 0, row, col, VFloat) = (VFloat) plot_image_raw[col][row];
//			if (col < 10 && row < 10){
//				NSLog(@"%.50lf", (VFloat) plot_image_raw[col][row]);
//			}
        }
    }
	

    VAppendAttr(out_list, "plot_gamma", NULL, VImageRepn, plot_image);
    
    char* outputFilename = (char*) malloc(sizeof(char) * UINT16_MAX);
    [path getCString:outputFilename maxLength:UINT16_MAX  encoding:NSUTF8StringEncoding];
    FILE *out_file = fopen(outputFilename, "w"); //fopen("/tmp/testDesign.v", "w");

    if (!VWriteFile(out_file, out_list)) {
        return [NSError errorWithDomain:@"Writing output design image failed." code:WRITE_OUTPUT userInfo:nil];
    }
    
    fclose(out_file);
    free(outputFilename);
    
    return nil;
}

-(Complex)complex_mult:(Complex) a
                      :(Complex) b
{
    Complex w;
    w.re = a.re * b.re  -  a.im * b.im;
    w.im = a.re * b.im  +  a.im * b.re;
    return w;
}

/*
 * Glover kernel, gamma function
 */
-(double)xgamma:(double) xx
               :(double) t0
{
    double scale = 20.0; // nobody knows where it comes from
    
    double x = xx - t0;// div 1000 due to ms unit but here s used
    if (x < 0 || x > 50) {
        return 0;
    }
    
    double d1 = a1 * b1;
    double d2 = a2 * b2;
    
    double y1 = pow(x / d1, a1) * exp(-(x - d1) / b1);
    double y2 = pow(x / d2, a2) * exp(-(x - d2) / b2);
    
    double y = y1 - cc * y2;
    y /= scale;
    return y;
}

/*
 * Glover kernel, gamma function, parameters changed for block designs
 */
-(double)bgamma:(double) xx
               :(double) t0
{
    double x;
    double y;
    double scale=120;
    
    double y1;
    double y2;
    double d1;
    double d2;
    
    double aa1 = 6;     
    double bb1 = 0.9;
    double aa2 = 12;
    double bb2 = 0.9;
    double cx  = 0.1;
    
    x = xx - t0;
    if (x < 0 || x > 50) {
        return 0;
    }
    
    d1 = aa1 * bb1;
    d2 = aa2 * bb2;
    
    y1 = pow(x / d1, aa1) * exp(-(x - d1) / bb1);
    y2 = pow(x / d2, aa2) * exp(-(x - d2) / bb2);
    
    y = y1 - cx * y2;
    y /= scale;
    return y;
}

/* First derivative. */
-(double)deriv1_gamma:(double) x 
                     :(double) t0
{
    double d1;
    double d2;
    double y1;
    double y2;
    double y;
    double xx;
    
    double scale = 20.0;
    
    xx = x - t0;
    if (xx < 0 || xx > 50) {
        return 0;
    }
    
    d1 = a1 * b1;
    d2 = a2 * b2;
    
    y1 = pow(d1, -a1) * a1 * pow(xx, (a1 - 1.0)) * exp(-(xx - d1) / b1) 
                - (pow((xx / d1), a1) * exp(-(xx - d1) / b1)) / b1;
    
    y2 = pow(d2, -a2) * a2 * pow(xx, (a2 - 1.0)) * exp(-(xx - d2) / b2) 
                - (pow((xx / d2), a2) * exp(-(xx - d2) / b2)) / b2;
    
    y = y1 - cc * y2;
    y /= scale;
    
    return y;
}

/* Second derivative. */
-(double)deriv2_gamma:(double) x0
                     :(double) t0
{
    double d1;
    double d2;
    double y1;
    double y2;
    double y3;
    double y4;
    double y;
    double x;
    
    double scale=20.0;
    
    x = x0 - t0;
    if (x < 0 || x > 50) {
        return 0;
    }
    
    d1 = a1 * b1;
    d2 = a2 * b2;
    
    y1 = pow(d1, -a1) * a1 * (a1 - 1) * pow(x, a1 - 2) * exp(-(x - d1) / b1) 
                - pow(d1, -a1) * a1 * pow(x, (a1 - 1)) * exp(-(x - d1) / b1) / b1;
    y2 = pow(d1, -a1) * a1 * pow(x, a1 - 1) * exp(-(x - d1) / b1) / b1
                - pow((x / d1), a1) * exp(-(x - d1) / b1) / (b1 * b1);
    y1 = y1 - y2;
    
    y3 = pow(d2, -a2) * a2 * (a2 - 1) * pow(x, a2 - 2) * exp(-(x - d2) / b2) 
                - pow(d2, -a2) * a2 * pow(x, (a2 - 1)) * exp(-(x - d2) / b2) / b2;
    y4 = pow(d2, -a2) * a2 * pow(x, a2 - 1) * exp(-(x - d2) / b2) / b2
                - pow((x / d2), a2) * exp(-(x - d2) / b2) / (b2 * b2);
    y2 = y3 - y4;
    
    y = y1 - cc * y2;
    y /= scale;
    
    return y;
}

/* Gaussian function. */
-(double)xgauss:(double)x0
               :(double)t0
{
    double sigma = 1.0;
    double scale = 20.0;
    double x;
    double y;
    double z;
    double a=2.506628273;
    
    x = (x0 - t0);
    z = x / sigma;
    y = exp((double) - z * z * 0.5) / (sigma * a);
    y /= scale;
    return y;
}

-(float**)Plot_gamma
{
    double y0;
    double y1;
    double y2;
    double t0 = 0.0;
    double step = 0.2;
    
    int ncols = (int) (28.0 / step);
    int nrows = mDerivationsHrf + 2;
    
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
        y0 = [self xgamma:x :t0];
        y1 = [self deriv1_gamma:x :t0];
        y2 = [self deriv2_gamma:x :t0];

        dest[j][0] = x;
        dest[j][1] = y0;
        if (mDerivationsHrf > 0) {
            dest[j][2] = y1;
        }
        if (mDerivationsHrf > 1) {
            dest[j][3] = y2;
        }
        j++;
    }
    
    return dest;
}

-(BOOL)test_ascii:(int)val
{
    if (val >= 'a' && val <= 'z') return YES;
    if (val >= 'A' && val <= 'Z') return YES;
    if (val >= '0' && val <= '9') return YES;
    if (val ==  ' ')              return YES;
    if (val == '\0')              return YES;
    if (val == '\n')              return YES;
    if (val == '\r')              return YES;
    if (val == '\t')              return YES;
    if (val == '\v')              return YES;
    
    return NO;
}

-(void)Convolve:(unsigned int) col
				:(unsigned int) eventNr
               :(fftw_complex *)kernel
{
    Complex a;
    Complex b;
    Complex c;
 
	fftw_complex *localBufInverseIn = mBuffersInverseIn[eventNr];
	fftw_complex *localBufForwardOut = mBuffersForwardOut[eventNr];
	double *localBufInverseOut = mBuffersInverseOut[eventNr];
	fftw_plan planInverseFFT = mFftPlanInverse[eventNr];
	
	unsigned int numberSamplesResult = (mNumberSamplesForInit / 2) + 1;//fftw3 definition
	
    
    /* convolution */
    unsigned int j;
    for (j = 0; j < numberSamplesResult; j++) {
        a.re = localBufForwardOut[j][0];
        a.im = localBufForwardOut[j][1];
        b.re = kernel[j][0];
        b.im = kernel[j][1];
        c = [self complex_mult:a :b];    
        localBufInverseIn[j][0] = c.re;
        localBufInverseIn[j][1] = c.im;
    }
    
    /* inverse fft */
    fftw_execute(planInverseFFT);
    
    /* scaling */
    for (j = 0; j < mNumberSamplesForInit; j++) {
        localBufInverseOut[j] /= (double) mNumberSamplesForInit;}
    
    /* sampling */
    for (unsigned int timestep = 0; timestep < mNumberTimesteps; timestep++) {
        j = (int) (mTimeOfRepetitionStartInMs[timestep] / samplingRateInMs + 0.5);
        
        if (j >= 0 && j < mNumberSamplesNeededForExp) {
            mDesign[col][timestep] = localBufInverseOut[j];
        }
    }
}

-(void)tl_append:(TrialList*)head
                :(TrialList*)newLast
{
    TrialList* current;
    current = head;
    while (current->next != NULL) {
        current = current->next;
    }
    current->next = newLast; 
}


-(NSNumber*)getValueFromExplanatoryVariable:(unsigned int)cov 
                                 atTimestep:(unsigned int)t 
{
    NSNumber *value = nil;
    if (cov < mNumberRegressors) {
        if (mDesign != NULL) {
            if (IMAGE_DATA_FLOAT == mImageDataType){
                value = [NSNumber numberWithFloat:mDesign[cov][t]];
            } else {
                NSLog(@"Cannot identify type of design image - no float");
            }
        } else {
            NSLog(@"%@: generateDesign has not been called yet! (initial design information NULL)", self);
        }
    } else {
        int covIndex = cov - mNumberRegressors;
        value = [NSNumber numberWithFloat:mCovariates[covIndex][t]];
    }
    
    return value;
}

-(void)setRegressor:(TrialList *)regressor
{
    free(mTrialList[regressor->trial.id - 1]);
    mTrialList[regressor->trial.id - 1] = NULL;
    mTrialList[regressor->trial.id - 1] = regressor;
    
    [self generateDesign];
}

-(void)setRegressorTrial:(Trial)trial 
{

	//TODO: eine Logik falls sich Bereiche überschneiden in einem Eventtyp
	TrialList* newListEntry;
	newListEntry = (TrialList*) malloc(sizeof(TrialList));
	*newListEntry = TRIALLIST_INIT;
	newListEntry->trial = trial;
	
	if (mTrialList[trial.id - 1] == NULL) {
		mTrialList[trial.id - 1] = newListEntry;
	} else {
		[self tl_append:mTrialList[trial.id - 1] :newListEntry];
	}
}

-(void)setCovariate:(float*)covariate forCovariateID:(int)covID
{
    if (mCovariates != NULL) {
        free(mCovariates[covID - 1]);
        mCovariates[covID - 1] = NULL;
        mCovariates[covID - 1] = covariate;
    } else {
        NSLog(@"Could not set covariate values for CovariateID %d because number of covariates is 0.", covID);
    }

}

-(void)setCovariateValue:(float)value forCovariateID:(int)covID atTimestep:(int)timestep
{
    if (mCovariates != NULL) {
        mCovariates[covID - 1][timestep] = value;
    } else {
        NSLog(@"Could not set covariate value %f for CovariateID %d at timestep %d because number of covariates is 0.", value, covID, timestep);
    }
}

-(void)dealloc
{
    for (unsigned int col = 0; col < mNumberRegressors; col++) {
        free(mDesign[col]);
    }
    free(mDesign);
    
    if (mCovariates != NULL) {
        for (unsigned int cov = 0; cov < mNumberCovariates; cov++) {
            free(mCovariates[cov]);
        }
        free(mCovariates);
    }
    
    free(mTimeOfRepetitionStartInMs);
    
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++) {
        fftw_free(mBuffersForwardIn[eventNr]);
        fftw_free(mBuffersForwardOut[eventNr]);
        fftw_free(mBuffersInverseIn[eventNr]);
        fftw_free(mBuffersInverseOut[eventNr]);
        
        TrialList* node;
        TrialList* tmp;
        node = mTrialList[eventNr];
        while (node != NULL) {
            tmp = node;
            node = node -> next;
            free(tmp);
        }
    }
    
    free(mTrialList);
    free(mBuffersForwardIn);
    fftw_free(mBuffersForwardOut);
    fftw_free(mBuffersInverseIn);
    free(mBuffersInverseOut);
    fftw_free(mKernelBlockDeriv0);
    fftw_free(mKernelEventDeriv0);
    fftw_free(mKernelDeriv1);
    fftw_free(mKernelDeriv2);
    
    free(mFftPlanForward);
    free(mFftPlanInverse);

    [super dealloc];
}

-(NSError*)correctForZeromean
{
	for (unsigned int i = 0; i < mNumberEvents; i++) {
		float sum1 = 0.0;
		float sum2 = 0.0;
		float nx   = 0.0;
		
		TrialList* currentTrial;
		currentTrial = mTrialList[i];
		
		while (currentTrial != NULL) {
			sum1 += currentTrial->trial.height;
			sum2 += currentTrial->trial.height * currentTrial->trial.height;
			nx++;
			currentTrial = currentTrial->next;
		}
		
		if (nx >= 1) {
			float mean  = sum1 / nx;
			if (nx < 1.5) continue;      /* sigma not computable       */
			float sigma =  sqrt((double)((sum2 - nx * mean * mean) / (nx - 1.0)));
			if (sigma < 0.01) continue;  /* not a parametric covariate */
			
			/* correct for zero mean */
			currentTrial = mTrialList[i];
			
			while (currentTrial != NULL) {
				currentTrial->trial.height -= mean;
				currentTrial = currentTrial->next;
			}
		}
	}
	return nil;
}

@end
