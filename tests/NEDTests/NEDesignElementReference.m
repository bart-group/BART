//
//  NEDesignElementDyn.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementReference.h"
#import "COExperimentContext.h"

// just as long as it will be written as .v
//#include <viaio/VImage.h>

@implementation NEDesignElementReference


@synthesize mRepetitionTimeInMs;
@synthesize mNumberExplanatoryVariables;
@synthesize mNumberTimesteps;
@synthesize mImageDataType;
@synthesize mNumberRegressors;
@synthesize mNumberCovariates;

const int R_BUFFER_LENGTH = 10000;

double r_samplingRateInMs = 20.0; /* Temporal resolution for convolution is 20 ms. */
const TrialListRef R_TRIALLIST_INIT = { {0,0,0,0}, NULL};


-(id)init
{
	self = [super init];
    
	mImageDataType = 0;
	mDesignHasChanged = NO;
	NSLog(@"GenDesign GCD: START");
	NSError *error = [self getPropertiesFromConfig];
	if (nil != error){
		NSLog(@"%@", error);
		return nil;
	}
	NSLog(@"GenDesign GCD: READCONFIG");
    [self initDesign];
	NSLog(@"GenDesign GCD: INIT");   
    [self generateDesign];
    NSLog(@"GenDesign GCD: END");
    
	
	
	[self writeDesignFile:@"/tmp/testDesign.v"];
	return self;
}



-(NSError*)getPropertiesFromConfig
{
	COSystemConfig *config = [[COExperimentContext getInstance] systemConfig];
	NSError* error = nil;
	// temp formatter due to converting from string to number
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	
	//what kind of design we have to ask for - in edl decision between growing / sliding window and dynamic
	NSMutableString *expType = [[NSMutableString alloc ]initWithCapacity:20];
	if (nil != [config getProp:@"$gwDesign"]){
		[expType setString:@"$gwDesign"];
	}
	else if (nil != [config getProp:@"$swDesign"]){
		[expType setString:@"$swDesign"];
	}
	else if (nil != [config getProp:@"$dynDesign"]){
		[expType setString:@"$dynDesign"];
	}
	else {
		NSString* errorString = [NSString stringWithFormat:@"No design struct found in edl-file. Define gwDesignStruct or swDesignStruct or dynamicDesignStruct! "];
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:errorString code:R_EVENT_NUMERATION userInfo:nil];
	}
	
	//TODO: what kind of regressor do we have - scanBased vs. timeBased
	
	
	mRepetitionTimeInMs = [[f numberFromString:[config getProp:@"$TR"]] unsignedIntValue];
	if (0 >= mRepetitionTimeInMs)
	{
		mRepetitionTimeInMs = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:[NSString stringWithFormat:@"negative TR not possible"] code:R_TR_NOT_SPECIFIED userInfo:nil];
	}
	
	mNumberTimesteps = [[f numberFromString:[config getProp:@"$nrTimesteps"]] unsignedIntValue];
	NSLog(@"length of Exp: %d", mNumberTimesteps);
	if ( 0 >= mNumberTimesteps)
	{
		mNumberTimesteps = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:[NSString stringWithFormat:@"negative number of timesteps not possible"] code:R_NUMBERTIMESTEPS_NOT_SPECIFIED userInfo:nil];
	}
	
	mNumberCovariates = [config countNodes:[NSString stringWithFormat:@"%@/scanBasedCovariates", expType]];
	if (0 > mNumberCovariates)
	{
		mNumberCovariates = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:@"negative number of covariates not possible" code:R_NUMBERCOVARIATES_NOT_SPECIFIED userInfo:nil];
	}
	
	mNumberEvents = [config countNodes:[NSString stringWithFormat:@"%@/timeBasedRegressor", expType]];
	if (0 >= mNumberEvents)
	{
		mNumberEvents = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:@"numberEvents not defined" code:R_NUMBERREGRESSORS_NOT_SPECIFIED userInfo:nil];
	}
	
	// calc number of samples for the fft - also needed for KernelInit
	mNumberSamplesForInit = (mNumberTimesteps * mRepetitionTimeInMs) / r_samplingRateInMs + 10000;//add some seconds to avoid wrap around problems with fft, here defined as 10s
	
	NSLog(@"indep Regressors without derivs: %d", mNumberEvents);
	// with this initialise the regressor list
	mRegressorList = (TRegressorRef**) malloc(sizeof(TRegressorRef*) * mNumberEvents);
	for (unsigned int i = 0; i < mNumberEvents; i++) {
        mRegressorList[i] = (TRegressorRef*) malloc(sizeof(TRegressorRef));
		mRegressorList[i]->regTrialList = NULL;
		mRegressorList[i]->regConvolKernel = NULL;
		mRegressorList[i]->regID = nil;
		mRegressorList[i]->regDescription = nil;
    }
    
	
	// now read all the trials for each event
	unsigned int nrDerivs = 0; // count nr derivations per event - whole number of clumns needed at the end
	for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++)
	{
		unsigned int trialID = eventNr+1;
		NSString *requestTrialsInReg = [NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/tbrDesign/statEvent", expType, trialID];
		NSUInteger nrTrialsInRegr = [config countNodes:requestTrialsInReg ];
		
		
		for (unsigned int trialNr = 0; trialNr < nrTrialsInRegr; trialNr++)
		{
			NSString *requestTrialTime = [NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@time", expType, trialID, trialNr+1];
			NSString *requestTrialDuration = [NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@duration", expType, trialID, trialNr+1];
			NSString *requestTrialHeight = [NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/tbrDesign/statEvent[%d]/@parametricScaleFactor", expType, trialID, trialNr+1];
			float onset = [[f numberFromString:[config getProp:requestTrialTime]] floatValue];
			float duration = [[f numberFromString:[config getProp:requestTrialDuration]] floatValue];
			float height = [[f numberFromString:[config getProp:requestTrialHeight]] floatValue];
			
			if (0.0 >= duration) {//if not set or negative
                [expType release];
                [f release];
				return error = [NSError errorWithDomain:@"negative duration of a statEvent" code:R_REGRESSOR_DURATION_NOT_SPECIFIED userInfo:nil];
				//NSLog(@"There's a negative duration of a statEvent - that's not valid, so set to 1.0");
				//duration = 1.0;
			}
			if (0.0 >= height){//if not set
				NSLog(@"There's a zero height of a statEvent - that's not valid, so set to 1.0");
				height = 1.0;
				//TODO: REGRESSOR_PARAMETRIC_SCALE_NOT_SPECIFIED ,
			}
			
			
			TrialRef newTrial;
			newTrial.id       = trialID;
			newTrial.onset    = onset;
			newTrial.duration = duration;
			newTrial.height   = height;
			
			TrialListRef* newListEntry;
			newListEntry = (TrialListRef*) malloc(sizeof(TrialListRef));
			*newListEntry = R_TRIALLIST_INIT;
			newListEntry->trial = newTrial;
			
			if (mRegressorList[trialID - 1]->regTrialList == NULL) {
				mRegressorList[trialID - 1]->regTrialList = newListEntry;
			} else {
				[self tl_append:mRegressorList[trialID - 1]->regTrialList :newListEntry];
			}
			
		}
		
		mRegressorList[eventNr]->regID = [config getProp:[NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/@regressorID", expType, trialID]];
		mRegressorList[eventNr]->regDescription = [config getProp:[NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/@name", expType, trialID]];
		
		// number of derivations used per each event
		if ( YES == [[config getProp:[NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/@useRefFctSecondDerivative", expType, trialID]] boolValue]){
			mRegressorList[eventNr]->regDerivations = 2;
			nrDerivs += 2;}
		else if (YES == [[config getProp:[NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/@useRefFctFirstDerivative", expType, trialID]] boolValue]){
			mRegressorList[eventNr]->regDerivations = 1;
			nrDerivs += 1;}
		else {
			mRegressorList[eventNr]->regDerivations = 0;}
		
		// now we read and generate the HRF Kernel per event
		//TODO get per event from config!!!!
		NSString *hrfKernelName = [config getProp:[NSString stringWithFormat:@"%@/timeBasedRegressor[%d]/@useRefFct", expType, trialID]];
		NSUInteger nrRefFcts = [config countNodes:@"$refFctsGlover"];
		nrRefFcts += [config countNodes:@"$refFctsGamma"];
		
		NEDesignKernelTimeUnit timeUnit = KERNEL_TIME_MS;
		if ([[config getProp:@"$timeUnit"] isEqualToString:@"milliseconds"]){
			timeUnit = KERNEL_TIME_MS;}
		else {
			NSLog(@"timeUnit in configuration is NOT milliseconds!");}
		
		
		for (unsigned int refNr = 0; refNr < nrRefFcts; refNr++){
			if( [hrfKernelName isEqualToString:[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/@refFctID",refNr+1]]]){
				//NSString *request = NSString stringWithFormat:@"$refFctsGlover[%d]",refNr];
				GloverParams *params = [[GloverParams alloc] 
										initWithMaxLength:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/overallWidth", refNr+1]] longLongValue]
										peak1:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/tPeak1", refNr+1]] doubleValue]
										scale1:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/tPeak1Scale", refNr+1]] doubleValue]  
										peak2:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/tPeak2", refNr+1]] doubleValue]
										scale2:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/tPeak2Scale", refNr+1]]  doubleValue]
										offset:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/offset", refNr+1]] doubleValue]
										relationP1P2:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/ratioTPeaks", refNr+1]]  doubleValue]
										heightScale:[[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/heightScale", refNr+1]]  doubleValue]
										givenInTimeUnit:timeUnit];
				mRegressorList[eventNr]->regConvolKernel = [[NEDesignKernel alloc] initWithGloverParams:params andNumberSamples:[NSNumber numberWithLong:mNumberSamplesForInit] andSamplingRate:[NSNumber numberWithLong:r_samplingRateInMs]];
				if (nil == mRegressorList[eventNr]->regConvolKernel){
					[params release];
                    [expType release];
                    [f release];
					return error = [NSError errorWithDomain:@"generation of design kernel failed" code:R_CONVOLUTION_KERNEL_NOT_SPECIFIED userInfo:nil];
				}
				[params release];
			}
			else if ([hrfKernelName isEqualToString:[config getProp:[NSString stringWithFormat:@"$refFctsGamma[%d]/@refFctID",refNr+1]]]){
				GeneralGammaParams params;
                params.maxLengthHrfInMs = 0;
                params.peak1 = 0;
                params.peak2 = 0;
                params.scale2 = 0;
                params.scale1 = 0;
				mRegressorList[eventNr]->regConvolKernel = [[NEDesignKernel alloc] initWithGeneralGammaParams:params];
				if (nil == mRegressorList[eventNr]->regConvolKernel){
                    [expType release];
                    [f release];
					return error = [NSError errorWithDomain:@"generation of design kernel failed" code:R_CONVOLUTION_KERNEL_NOT_SPECIFIED userInfo:nil];
				}
			}
		}
	}
	
    mNumberRegressors = mNumberEvents + nrDerivs + 1;
    mNumberExplanatoryVariables = mNumberRegressors + mNumberCovariates;
    [expType release];
	[f release];//temp for conversion purposes
	return error;
}


-(void)initRegressorValues
{
	for (unsigned int col = 0; col < mNumberRegressors; col++) {
        mRegressorValues[col] = (float*) malloc(sizeof(float) * mNumberTimesteps);
		for (unsigned int ts = 0; ts < mNumberTimesteps; ts++) {
			if (col == mNumberRegressors-1) {
				mRegressorValues[col][ts] = 1.0;
			} else {
				mRegressorValues[col][ts] = 0.0;
			}
		}
    }
}

-(void)initCovariateValues
{
	for (unsigned int cov = 0; cov < mNumberCovariates; cov++) {
		mCovariateValues[cov] = (float*) malloc(sizeof(float) * mNumberTimesteps);
		memset(mCovariateValues[cov], 0.0, sizeof(float) * mNumberTimesteps);
	}
}



-(NSError*)initDesign
{
    BOOL zeromean = YES;
	fprintf(stderr, " TR in ms = %d\n", mRepetitionTimeInMs);
	
	mTimeOfRepetitionStartInMs = (double *) malloc(sizeof(double) * mNumberTimesteps);
	for (unsigned int i = 0; i < mNumberTimesteps; i++) {
		mTimeOfRepetitionStartInMs[i] = (double) (i) * mRepetitionTimeInMs;//TODO: Gabi fragen letzter Zeitschritt im moment nicht einbezogen xx[i] = (double) i * tr * 1000.0;
	}
	
    unsigned long maxExpLengthInMs = mTimeOfRepetitionStartInMs[0] + mTimeOfRepetitionStartInMs[mNumberTimesteps - 1] + mRepetitionTimeInMs;//+1 repetition to add time of last rep
    NSLog(@"Number timesteps: %d,  experiment duration: %.2f min\n", mNumberTimesteps, maxExpLengthInMs / 60000.0);
	/*
     ** check amplitude: must have zero mean for parametric designs
	 ** for not parametric nothing will be corrected due to check of stddev
     */
    if (YES == zeromean) { 
		[self correctForZeromean];
	}
    if (mNumberEvents < 1) {
        return [[NSError errorWithDomain:@"No events were found!" code:R_NO_EVENTS_FOUND userInfo:nil] retain];
    }
    
	
	/* alloc memory for all NEDesignDyn specific stuff*/
	
    mRegressorValues = (float** ) malloc(sizeof(float*) * (mNumberRegressors ));
    [self initRegressorValues];	
	
	if (mNumberCovariates > 0) {
        mCovariateValues = (float**) malloc(sizeof(float*) * mNumberCovariates);
		[self initCovariateValues];}
	
    unsigned int numberSamplesInResult = (mNumberSamplesForInit / 2) + 1;//defined for results of fftw3
	
    /* make plans one per each event*/
    mFftPlanForward = (fftw_plan *) malloc(sizeof(fftw_plan) * mNumberEvents);
    mFftPlanInverse = (fftw_plan *) malloc(sizeof(fftw_plan) * mNumberEvents);
	
	/* alloc input/output buffers for forward/inverse fft one per each event*/
	mBuffersForwardIn = (double **) malloc(sizeof(double *) * mNumberEvents);
    mBuffersForwardOut = (fftw_complex **) malloc(sizeof(fftw_complex *) * mNumberEvents);
    mBuffersInverseIn = (fftw_complex **) malloc(sizeof(fftw_complex *) * mNumberEvents);
    mBuffersInverseOut = (double **) malloc(sizeof(double *) * mNumberEvents);
	
	/* alloc gamma kernels one per each event*/
    
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
    
    return nil;
}

-(NSError*)generateDesign
{
	//reinit regressor result buffers
	[self initRegressorValues];
    __block NSError* error = nil;
    
    dispatch_queue_t queue;       /* Global asyn. dispatch queue. */
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    /* For each event and trial do... */
    dispatch_apply(mNumberEvents, queue, ^(size_t eventNr) {
        memset(mBuffersForwardIn[eventNr], 0, sizeof(double) * mNumberSamplesForInit);
        
        /* get data */
        unsigned int trialcount = 0;
        double t0;
        double h;
		
        TrialListRef* currentTrial;
        currentTrial = mRegressorList[eventNr]->regTrialList;//mTrialList[eventNr];
        
        while (currentTrial != NULL) {
            trialcount++;
			
            t0 = currentTrial->trial.onset;
            double tmax = currentTrial->trial.onset + currentTrial->trial.duration;
            h  = currentTrial->trial.height;
            unsigned int k = t0 / r_samplingRateInMs;
            
            for (double t = t0; t <= tmax; t += r_samplingRateInMs) {
                if (k >= mNumberSamplesForInit) {
                    break;
                }
                mBuffersForwardIn[eventNr][k++] += h;
            }
            
            currentTrial = currentTrial->next;
        }
        
        if (trialcount < 1) {
            NSString* errorString = [NSString stringWithFormat:@"No trials in event %ld, please re-number event-IDs!", eventNr + 1];
            error = [NSError errorWithDomain:errorString code:R_EVENT_NUMERATION userInfo:nil];
        }
        if (trialcount < 4) {
            NSLog(@"Warning: too few trials (%d) in event %ld. Statistics will be unreliable.",
                  trialcount, eventNr + 1);
        }
        
        /* fft */
        fftw_execute(mFftPlanForward[eventNr]);
 		// the actual column is added from all events and their derivations before
		unsigned int columnsForDerivs = 0;
		for (unsigned int countCols = 0; countCols < eventNr; countCols++){
			columnsForDerivs += mRegressorList[countCols]->regDerivations;}
		
		unsigned int col = eventNr + columnsForDerivs;
		
  		[self Convolve:col
					  :eventNr
					  :mRegressorList[eventNr]->regConvolKernel.mKernelDeriv0]; 
        col++;
        
        if (1 <= mRegressorList[eventNr]->regDerivations) {
            [self Convolve:col
						  :eventNr
                          :mRegressorList[eventNr]->regConvolKernel.mKernelDeriv1];
            col++;
        }
        
        if (2 == mRegressorList[eventNr]->regDerivations) {
            [self Convolve:col
						  :eventNr
						  :mRegressorList[eventNr]->regConvolKernel.mKernelDeriv2];
        }
    });
	mDesignHasChanged = NO;
    return error;
}

-(NSError*)writeDesignFile:(NSString*) path 
{
//    VImage outDesign = NULL;
//    outDesign = VCreateImage(1, mNumberTimesteps, mNumberRegressors, VFloatRepn);
//    
//    VSetAttr(VImageAttrList(outDesign), "modality", NULL, VStringRepn, "X");
//    VSetAttr(VImageAttrList(outDesign), "name", NULL, VStringRepn, "X");
//    VSetAttr(VImageAttrList(outDesign), "repetition_time", NULL, VLongRepn, (VLong) mRepetitionTimeInMs);
//    VSetAttr(VImageAttrList(outDesign), "ntimesteps", NULL, VLongRepn, (VLong) mNumberTimesteps);
//    
//    VSetAttr(VImageAttrList(outDesign), "derivatives", NULL, VShortRepn, mRegressorList[0]->regDerivations);
//    
//    // evil: Copy&Paste from initDesign()
//    float delay = 6.0;              
//    float understrength = 0.35;
//    float undershoot = 12.0;
//    char buf[R_BUFFER_LENGTH];
//    
//    VSetAttr(VImageAttrList(outDesign), "delay", NULL, VFloatRepn, delay);
//    VSetAttr(VImageAttrList(outDesign), "undershoot", NULL, VFloatRepn, undershoot);
//    sprintf(buf, "%.3f", understrength);
//    VSetAttr(VImageAttrList(outDesign), "understrength", NULL, VStringRepn, &buf);
//    
//    VSetAttr(VImageAttrList(outDesign), "nsessions", NULL, VShortRepn, (VShort) 1);
//    VSetAttr(VImageAttrList(outDesign), "designtype", NULL, VShortRepn, (VShort) 1);
//    
//    for (unsigned int col = 0; col < mNumberRegressors; col++) {
//        for (unsigned int ts = 0; ts < mNumberTimesteps; ts++) {
//			VPixel(outDesign, 0, ts, col, VFloat) = (VFloat) mRegressorValues[col][ts];
//        }
//    }
//    
//    
//    VAttrList out_list = NULL;                         
//    out_list = VCreateAttrList();
//    VAppendAttr(out_list, "image", NULL, VImageRepn, outDesign);
//    
//    // Numbers taken from Plot_gamma()
//    int ncols = (int) (28.0 / 0.2);
//    int nrows = mRegressorList[0]->regDerivations + 2;
//    VImage plot_image = NULL;
//    plot_image = VCreateImage(1, nrows, ncols, VFloatRepn);
//    float** plot_image_raw = NULL;
//    plot_image_raw = [mRegressorList[0]->regConvolKernel plotGammaWithDerivs:mRegressorList[0]->regDerivations];//take first event, here just one fct possible
//    
//    for (int col = 0; col < ncols; col++) {
//        for (int row = 0; row < nrows; row++) {
//            VPixel(plot_image, 0, row, col, VFloat) = (VFloat) plot_image_raw[col][row];
//        }
//    }
//	
//	
//	// VAppendAttr(out_list, "plot_gamma", NULL, VImageRepn, plot_image);
//    
//    char* outputFilename = (char*) malloc(sizeof(char) * UINT16_MAX);
//    [path getCString:outputFilename maxLength:UINT16_MAX  encoding:NSUTF8StringEncoding];
//    FILE *out_file = fopen(outputFilename, "w"); //fopen("/tmp/testDesign.v", "w");
//	
//    if (!VWriteFile(out_file, out_list)) {
//        return [NSError errorWithDomain:@"Writing output design image failed." code:R_WRITE_OUTPUT userInfo:nil];
//    }
//    
//    fclose(out_file);
//    free(outputFilename);
//    
    return nil;
}

-(ComplexRef)multiplComplex:(ComplexRef)a withComplex:(ComplexRef) b
{
    ComplexRef w;
    w.re = a.re * b.re  -  a.im * b.im;
    w.im = a.re * b.im  +  a.im * b.re;
    return w;
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
	unsigned int numberSamplesResult = (mNumberSamplesForInit / 2) + 1;//fftw3 definition
	ComplexRef valueEventSeries;
    ComplexRef valueGammaKernel;
    ComplexRef multiplResult;
	
	if (nil == kernel){
		NSLog(@"Convolve with zero kernel");
		return;}
	
	/* convolution */
    unsigned int j;
    for (j = 0; j < numberSamplesResult; j++) {
        valueEventSeries.re = mBuffersForwardOut[eventNr][j][0];
        valueEventSeries.im = mBuffersForwardOut[eventNr][j][1];
        valueGammaKernel.re = kernel[j][0];
        valueGammaKernel.im = kernel[j][1];
        multiplResult = [self multiplComplex:valueEventSeries withComplex:valueGammaKernel];
        mBuffersInverseIn[eventNr][j][0] = multiplResult.re;
        mBuffersInverseIn[eventNr][j][1] = multiplResult.im;
    }
    
    /* inverse fft */
    fftw_execute(mFftPlanInverse[eventNr]);
    
    /* scaling */
    for (j = 0; j < mNumberSamplesForInit; j++) {
        mBuffersInverseOut[eventNr][j] /= (double) mNumberSamplesForInit;}
    
    /* sampling */
    for (unsigned int timestep = 0; timestep < mNumberTimesteps; timestep++) {
        j = (int) (mTimeOfRepetitionStartInMs[timestep] / r_samplingRateInMs + 0.5);
        
        if (j >= 0 && j < mNumberSamplesForInit) {
			mRegressorValues[col][timestep] = mBuffersInverseOut[eventNr][j];
        }
    }
}

-(void)tl_append:(TrialListRef*)head
                :(TrialListRef*)newLast
{
    TrialListRef* current;
    current = head;
    while (current->next != NULL) {
        current = current->next;
    }
    current->next = newLast; 
}


-(NSNumber*)getValueFromExplanatoryVariable:(unsigned int)cov 
                                 atTimestep:(unsigned int)t 
{
	// At first check if design is still valid or something has changed
	if (YES == mDesignHasChanged){
		NSError *error = [self generateDesign];
		if (nil != error){
			NSLog(@"%@", error);
			return nil;
	}}
		
    NSNumber *value = nil;
    if (cov < mNumberRegressors) {
        if (mRegressorValues != NULL) {
            if (0 == mImageDataType){
                value = [NSNumber numberWithFloat:mRegressorValues[cov][t]];
            } else {
                NSLog(@"Cannot identify type of design image - no float");
            }
        } else {
            NSLog(@"%@: generateDesign has not been called yet! (initial design information NULL)", self);
        }
    } else {
        int covIndex = cov - mNumberRegressors;
        value = [NSNumber numberWithFloat:mCovariateValues[covIndex][t]];
    }
    
    return value;
}

-(void)dealloc
{
    for (unsigned int col = 0; col < mNumberRegressors; col++) {
        free(mRegressorValues[col]);
    }
    free(mRegressorValues);
    
    if (mCovariateValues != NULL) {
        for (unsigned int cov = 0; cov < mNumberCovariates; cov++) {
            free(mCovariateValues[cov]);
        }
        free(mCovariateValues);
    }
    
    free(mTimeOfRepetitionStartInMs);
    
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++) {
        fftw_free(mBuffersForwardIn[eventNr]);
        fftw_free(mBuffersForwardOut[eventNr]);
        fftw_free(mBuffersInverseIn[eventNr]);
        fftw_free(mBuffersInverseOut[eventNr]);
		
        TrialListRef* node;
        TrialListRef* tmp;
        node = mRegressorList[eventNr]->regTrialList;
        while (node != NULL) {
            tmp = node;
            node = node -> next;
            free(tmp);
        }
    }
    
    free(mRegressorList);
    free(mBuffersForwardIn);
    fftw_free(mBuffersForwardOut);
    fftw_free(mBuffersInverseIn);
    free(mBuffersInverseOut);
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
		
		TrialListRef* currentTrial;
		currentTrial = mRegressorList[i]->regTrialList;
		
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
			currentTrial = mRegressorList[i]->regTrialList;
			
			while (currentTrial != NULL) {
				currentTrial->trial.height -= mean;
				currentTrial = currentTrial->next;
			}
		}
	}
	return nil;
}

@end
