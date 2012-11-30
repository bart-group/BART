//
//  NEDesignElementDyn.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElementDyn.h"
#import "COExperimentContext.h"


@implementation NEDesignElementDyn

double samplingRateInMs = 20.0; /* Temporal resolution for convolution is 20 ms. */
const TrialList TRIALLIST_INIT = { {0,0,0,0}, NULL};

dispatch_queue_t serialDesignElementAccessQueue;
BOOL isDynamicDesign = NO;

-(id)initWithConfig:(COSystemConfig*)config
{
    [config retain];
    
	if ( (self = [super init] ))
    {
        
        serialDesignElementAccessQueue = dispatch_queue_create("de.mpg.cbs.NEDesignElementDynSerialAccessQueue", DISPATCH_QUEUE_SERIAL);
        
        mDesignHasChanged = NO;
        //NSLog(@"GenDesign GCD: START");
        NSError *error = [self getPropertiesFromConfig:config];
        if (nil != error){
            NSLog(@"%@", error);
            return nil;
        }
        //NSLog(@"GenDesign GCD: READCONFIG");
        error = [self initDesign];
        if (nil != error){
            NSLog(@"%@", error);
            return nil;
        }
        //NSLog(@"GenDesign GCD: INIT");
        error = [self updateDesign];
        if (nil != error){
            NSLog(@"%@", error);
            return nil;
        }
        //NSLog(@"GenDesign GCD: END");
        
    }
	[config release];
	//[self writeDesignFile:@"/tmp/testDesign.edl"];
    
	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	id newDesign = [super copyWithZone:zone];
	[newDesign copyValuesOfFinishedDesign:mRegressorValues andCovariates:mCovariateValues];
	return newDesign;
	
}

-(void)copyValuesOfFinishedDesign:(float**)copyFromR andCovariates:(float**)copyFromC
{
	if (mRegressorValues != copyFromR)
	{
		unsigned int nrCols = self.mNumberExplanatoryVariables - self.mNumberCovariates;
		mRegressorValues = (float**) malloc(sizeof(float*) * nrCols);
		for (unsigned int col = 0; col < nrCols; col++){
			mRegressorValues[col] = (float*) malloc(sizeof(float) * self.mNumberTimesteps);
			for (unsigned int ts = 0; ts < self.mNumberTimesteps; ts ++){
				mRegressorValues[col][ts] = copyFromR[col][ts];
			}
		}
	}
	if (mCovariateValues != copyFromC)
	{
		mCovariateValues = (float**) malloc(sizeof(float*) * self.mNumberCovariates);
		for (unsigned int col = 0; col < self.mNumberCovariates; col++){
			mCovariateValues[col] = (float*) malloc(sizeof(float) * self.mNumberTimesteps);
			for (unsigned int ts = 0; ts < self.mNumberTimesteps; ts++){
				mCovariateValues[col][ts] = copyFromC[col][ts];
			}
		}
	}
	
	mRegressorList = nil;
	mNumberEvents = 0;
	mNumberSamplesForInit = 0;
	mNumberSamplesNeededForExp = 0;
	mTimeOfRepetitionStartInMs = 0;
	mBuffersForwardIn = nil;
	mBuffersForwardOut = nil;
	mBuffersInverseIn = nil;
	mBuffersInverseOut = nil;
	mFftPlanForward = nil;
	mFftPlanInverse = nil;
	mDesignHasChanged = NO;
}



-(NSError*)getPropertiesFromConfig:(COSystemConfig*)config
{
	NSError* error = nil;
	// temp formatter due to converting from string to number
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	//what kind of design we have to ask for - in edl decision between growing / sliding window and dynamic
	NSMutableString *expType = [[NSMutableString alloc ]initWithCapacity:20];
    NSMutableString *regType = [[NSMutableString alloc ]initWithCapacity:20];
    
	if (nil != [config getProp:@"$gwDesign"]){
		[expType setString:@"$gwDesign"];
        [regType setString:@"timeBasedRegressor"];
	}
	else if (nil != [config getProp:@"$swDesign"]){
		[expType setString:@"$swDesign"];
        [regType setString:@"timeBasedRegressor"];
	}
	else if (nil != [config getProp:@"$dynDesign"]){
		[expType setString:@"$dynDesign"];
        [regType setString:@"dynamicTimeBasedRegressor"];
        isDynamicDesign = YES;
	}
	else {
		NSString* errorString = [NSString stringWithFormat:@"No design struct found in edl-file. Define gwDesignStruct or swDesignStruct or dynamicDesignStruct! "];
        [expType release];
        [regType release];
        [f release];
		return error = [NSError errorWithDomain:errorString code:EVENT_NUMERATION userInfo:nil];
	}
    
	
	
	
	self.mRepetitionTimeInMs = [[f numberFromString:[config getProp:@"$TR"]] unsignedIntValue];
	if (0 >= self.mRepetitionTimeInMs)
	{
		self.mRepetitionTimeInMs = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:[NSString stringWithFormat:@"negative TR not possible"] code:TR_NOT_SPECIFIED userInfo:nil];
	}
	
	self.mNumberTimesteps = [[f numberFromString:[config getProp:@"$nrTimesteps"]] unsignedIntValue];
	NSLog(@"length of Exp: %ld", self.mNumberTimesteps);
	if ( 0 >= self.mNumberTimesteps)
	{
		self.mNumberTimesteps = 0;
        [expType release];
        [f release];
		return error = [NSError errorWithDomain:[NSString stringWithFormat:@"negative number of timesteps not possible"] code:NUMBERTIMESTEPS_NOT_SPECIFIED userInfo:nil];
	}
	
	self.mNumberCovariates = [config countNodes:[NSString stringWithFormat:@"%@/scanBasedCovariates", expType]];
    
    mNumberEvents = [config countNodes:[NSString stringWithFormat:@"%@/%@", expType, regType]];
    if (0 >= mNumberEvents)
    {
        mNumberEvents = 0;
        [expType release];
        [f release];
        return error = [NSError errorWithDomain:@"numberEvents not defined" code:NUMBERREGRESSORS_NOT_SPECIFIED userInfo:nil];
    }
    
	// calc number of samples for the fft - also needed for KernelInit
    //  GET THIS FROM THE REGRESSOR LENGTH - TAKE MAX
    unsigned long maxLengthRegressor = 0;
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++)
    {
        unsigned long curLength = [[ f numberFromString:[config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@length", expType, regType, eventNr+1]] ] unsignedLongValue];
        if ( curLength > maxLengthRegressor)
        {
            maxLengthRegressor = curLength;
        }
    }
	mNumberSamplesForInit = maxLengthRegressor / samplingRateInMs + 10000; // don't bother about the absolute value, it's just 10s added to avoid wrap aroung problems with fft
    
    // OLDER VERSION -
    //mNumberSamplesForInit = (self.mNumberTimesteps * self.mRepetitionTimeInMs) / samplingRateInMs + 10000;//add some seconds to avoid wrap around problems with fft, here defined as 10s
	
	NSLog(@"indep Regressors without derivs: %d", mNumberEvents);
	// with this initialise the regressor list
	mRegressorList = (TRegressor**) malloc(sizeof(TRegressor*) * mNumberEvents);
	for (unsigned int i = 0; i < mNumberEvents; i++) {
        mRegressorList[i] = (TRegressor*) malloc(sizeof(TRegressor));
		mRegressorList[i]->regTrialList = NULL;
		mRegressorList[i]->regConvolKernel = NULL;
		mRegressorList[i]->regID = nil;
		mRegressorList[i]->regDescription = nil;
        mRegressorList[i]->regRefFunction = nil;
        mRegressorList[i]->length = maxLengthRegressor;
        mRegressorList[i]->regDerivations = 0;
    }
    
    
    
    // now read all the trials for each event
    unsigned int nrDerivs = 0; // count nr derivations per event - whole number of columns needed at the end
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++)
    {
        unsigned int trialID = eventNr+1;
        
        /**************************************
         * INIT WITH TRIALS OF STATIC DESIGN
         *************************************/
        if (NO == isDynamicDesign)
        {
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
                    return error = [NSError errorWithDomain:@"negative duration of a statEvent" code:REGRESSOR_DURATION_NOT_SPECIFIED userInfo:nil];
                    //NSLog(@"There's a negative duration of a statEvent - that's not valid, so set to 1.0");
                    //duration = 1.0;
                }
                if (0.0 >= height){//if not set
                    NSLog(@"There's a zero height of a statEvent - that's not valid, so set to 1.0");
                    height = 1.0;
                    //TODO: REGRESSOR_PARAMETRIC_SCALE_NOT_SPECIFIED ,
                }
                
                Trial newTrial;
                newTrial.trialid  = trialID;
                newTrial.onset    = onset;
                newTrial.duration = duration;
                newTrial.height   = height;
                
                TrialList* newListEntry;
                newListEntry = (TrialList*) malloc(sizeof(TrialList));
                *newListEntry = TRIALLIST_INIT;
                newListEntry->trial = newTrial;
                
                if (mRegressorList[trialID - 1]->regTrialList == NULL) {
                    mRegressorList[trialID - 1]->regTrialList = newListEntry;
                } else {
                    [self tl_append:mRegressorList[trialID - 1]->regTrialList :newListEntry];
                }
                
            }
        }
        /*********************************************************
         * END OF INIT WITH TRIALS OF STATIC DESIGN
         ********************************************************/
        
        
		mRegressorList[eventNr]->regID = [config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@regressorID", expType, regType, trialID]];
		mRegressorList[eventNr]->regDescription = [config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@name", expType, regType, trialID]];
        
		// number of derivations used per each event
		if ( YES == [[config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@useRefFctSecondDerivative", expType, regType, trialID]] boolValue]){
			mRegressorList[eventNr]->regDerivations = 2;
			nrDerivs += 2;}
		else if (YES == [[config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@useRefFctFirstDerivative", expType, regType,  trialID]] boolValue]){
			mRegressorList[eventNr]->regDerivations = 1;
			nrDerivs += 1;}
		else {
			mRegressorList[eventNr]->regDerivations = 0;}
		
		// now we read and generate the HRF Kernel per event
		NSString *hrfKernelName = [config getProp:[NSString stringWithFormat:@"%@/%@[%d]/@useRefFct", expType, regType, trialID]];
		NSUInteger nrRefFcts = [config countNodes:@"$refFctsGlover"];
		nrRefFcts += [config countNodes:@"$refFctsGamma"];
        mRegressorList[eventNr]->regRefFunction = hrfKernelName;
		
		NEDesignKernelTimeUnit timeUnit = KERNEL_TIME_MS;
		if ([[config getProp:@"$timeUnit"] isEqualToString:@"milliseconds"]){
			timeUnit = KERNEL_TIME_MS;}
		else {
			NSLog(@"timeUnit in configuration is NOT milliseconds!");}
		
        
		for (unsigned int refNr = 0; refNr < nrRefFcts; refNr++){
			if( [hrfKernelName isEqualToString:[config getProp:[NSString stringWithFormat:@"$refFctsGlover[%d]/@refFctID",refNr+1]]]){
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
				mRegressorList[eventNr]->regConvolKernel = [[NEDesignKernel alloc] initWithGloverParams:params andNumberSamples:[NSNumber numberWithLong:mNumberSamplesForInit] andSamplingRate:[NSNumber numberWithLong:samplingRateInMs]];
				if (nil == mRegressorList[eventNr]->regConvolKernel){
					[params release];
                    [expType release];
                    [regType release];
                    [f release];
					return error = [NSError errorWithDomain:@"generation of design kernel failed" code:CONVOLUTION_KERNEL_NOT_SPECIFIED userInfo:nil];
				}
				[params release];
			}
			else if ([hrfKernelName isEqualToString:[config getProp:[NSString stringWithFormat:@"$refFctsGamma[%d]/@refFctID",refNr+1]]]){
				GeneralGammaParams params;
                params.maxLengthHrfInMs = 0;
                params.peak1 = 0;
                params.peak2 = 2;
                params.scale1 = 1;
                params.scale2 = 1;
				mRegressorList[eventNr]->regConvolKernel = [[NEDesignKernel alloc] initWithGeneralGammaParams:params];
				if (nil == mRegressorList[eventNr]->regConvolKernel){
                    [expType release];
                    [regType release];
                    [f release];
					return error = [NSError errorWithDomain:@"generation of design kernel failed" code:CONVOLUTION_KERNEL_NOT_SPECIFIED userInfo:nil];
				}
			}
		}
	}
	
    self.mNumberRegressors = mNumberEvents + nrDerivs + 1;
    self.mNumberExplanatoryVariables = self.mNumberRegressors + self.mNumberCovariates;
	[f release];//temp for conversion purposes
	[expType release];
    [regType release];
	return error;
}


-(void)initRegressorValues
{
	for (unsigned int col = 0; col < self.mNumberRegressors; col++) {
        mRegressorValues[col] = (float*) malloc(sizeof(float) * self.mNumberTimesteps);
		for (unsigned int ts = 0; ts < self.mNumberTimesteps; ts++) {
			if (col == self.mNumberRegressors-1) {
				mRegressorValues[col][ts] = 1.0;
			} else {
				mRegressorValues[col][ts] = 0.0;
			}
		}
    }
}

-(void)initCovariateValues
{
	for (unsigned int cov = 0; cov < self.mNumberCovariates; cov++) {
		mCovariateValues[cov] = (float*) malloc(sizeof(float) * self.mNumberTimesteps);
		memset(mCovariateValues[cov], 0.0, sizeof(float) * self.mNumberTimesteps);
	}
}



-(NSError*)initDesign
{
    BOOL zeromean = YES;
	fprintf(stderr, " TR in ms = %ld\n", self.mRepetitionTimeInMs);
	
	mTimeOfRepetitionStartInMs = (double *) malloc(sizeof(double) * self.mNumberTimesteps);
	for (unsigned int i = 0; i < self.mNumberTimesteps; i++) {
		mTimeOfRepetitionStartInMs[i] = (double) (i) * self.mRepetitionTimeInMs;	}
    
    unsigned long maxExpLengthInMs = mTimeOfRepetitionStartInMs[0] + mTimeOfRepetitionStartInMs[self.mNumberTimesteps - 1] + self.mRepetitionTimeInMs;//+1 repetition to add time of last rep
    NSLog(@"Number timesteps: %ld,  experiment duration: %.2f min\n", self.mNumberTimesteps, maxExpLengthInMs / 60000.0);
    /*
     ** check amplitude: must have zero mean for parametric designs
	 ** for not parametric nothing will be corrected due to check of stddev
     */
    if (YES == zeromean) {
		[self correctForZeromean];
	}
    if (mNumberEvents < 1) {
        return [[NSError errorWithDomain:@"No events were found!" code:NO_EVENTS_FOUND userInfo:nil] retain];
    }
    
	/* alloc memory for all NEDesignDyn specific stuff*/
	
    mRegressorValues = (float** ) malloc(sizeof(float*) * (self.mNumberRegressors ));
    [self initRegressorValues];
    
	if (self.mNumberCovariates > 0) {
        mCovariateValues = (float**) malloc(sizeof(float*) * self.mNumberCovariates);
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

-(NSError*)updateDesign
{
    __block NSError* error = nil;
    dispatch_sync(serialDesignElementAccessQueue, ^{
        
        
        //reinit regressor result buffers
        [self initRegressorValues];
        
        
        dispatch_queue_t queue;       /* Global asyn. dispatch queue. */
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        /* For each event and trial do... */
        dispatch_apply(mNumberEvents, queue, ^(size_t eventNr) {
            memset(mBuffersForwardIn[eventNr], 0, sizeof(double) * mNumberSamplesForInit);
            
            /* get data */
            unsigned int trialcount = 0;
            double t0;
            double h;
            
            TrialList* currentTrial;
            currentTrial = mRegressorList[eventNr]->regTrialList;//mTrialList[eventNr];
            
            while (currentTrial != NULL) {
                trialcount++;
                
                t0 = currentTrial->trial.onset;
                double tmax = currentTrial->trial.onset + currentTrial->trial.duration;
                h  = currentTrial->trial.height;
                unsigned int k = t0 / samplingRateInMs;
                
                for (double t = t0; t <= tmax; t += samplingRateInMs) {
                    if (k >= mNumberSamplesForInit) {
                        break;
                    }
                    mBuffersForwardIn[eventNr][k++] += h;
                }
                
                currentTrial = currentTrial->next;
            }
            
            if ((NO == isDynamicDesign) && (trialcount < 1)) {
                NSString* errorString = [NSString stringWithFormat:@"No trials in event %ld, please re-number event-IDs!", eventNr + 1];
                error = [NSError errorWithDomain:errorString code:EVENT_NUMERATION userInfo:nil];
            }
            if (trialcount < 4) {
                NSLog(@"Warning: too few trials (%d) in event %lu. Statistics will be unreliable.",
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
        
        
    });
    return error;
}

-(NSError*)writeDesignFile:(NSString*) path
{
    
    if (YES == isDynamicDesign)
    {
        COSystemConfig* configCopy = [[COExperimentContext getInstance] systemConfig];
        
        /*******************************/
        // (1) the outer DesignStruct
        NSXMLElement* desStruct = [[NSXMLElement alloc] initWithName:@"gwDesignStruct"];
        
        //(2)
        for (NSUInteger i = 0; i < mNumberEvents; i++)
        {
            //(3)
            // get everything from RegressorList and set it to new node
            NSString* ref1 = @"false";
            NSString* ref2 = @"false";
            if (1 == mRegressorList[i]->regDerivations)
            {
                ref1 = @"true";
            }
            else if (2 == mRegressorList[i]->regDerivations)
            {
                ref1 = @"true";
                ref2 = @"true";
            }
            NSString* length = [NSString stringWithFormat:@"%lu", mRegressorList[i]->length];
            
            
            NSXMLElement* tRegressor = [[NSXMLElement alloc] initWithName:@"timeBasedRegressor"];
            
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"regressorID" stringValue:mRegressorList[i]->regID]];
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:mRegressorList[i]->regDescription]];
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"length" stringValue:length]];
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"useRefFct" stringValue:mRegressorList[i]->regRefFunction]];
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative" stringValue:ref1]];
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative" stringValue:ref2]];
            //TODO: CARE ABOUT THIS
            [tRegressor addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean" stringValue:@"false"]];
            
            // (4)
            NSXMLElement* tbrDesign = [[NSXMLElement alloc] initWithName:@"tbrDesign"];
            [tbrDesign addAttribute:[NSXMLNode attributeWithName:@"length" stringValue:length]];
            [tbrDesign addAttribute:[NSXMLNode attributeWithName:@"repetitions" stringValue:@"1"]];
            
            //replace dynamicTimeBasedRegressor with timebAsedRegressor
            //add tbrDesign
            // (5) add statEvents from Trials
            NSMutableArray *statEventsArray = [NSMutableArray arrayWithCapacity:100];
            
            TrialList* tl = mRegressorList[i]->regTrialList;
            
            while (NULL != tl)
            {
                NSString *ons = [NSString stringWithFormat:@"%.0f", tl->trial.onset];
                NSString *dur = [NSString stringWithFormat:@"%.0f", tl->trial.duration];
                NSString *hgt = [NSString stringWithFormat:@"%.1f", tl->trial.height];
                NSXMLElement *statEvent = [[NSXMLElement alloc] initWithName:@"statEvent"];
                [statEvent addAttribute:[NSXMLNode attributeWithName:@"time" stringValue:ons]];
                [statEvent addAttribute:[NSXMLNode attributeWithName:@"duration" stringValue:dur]];
                [statEvent addAttribute:[NSXMLNode attributeWithName:@"parametricScaleFactor" stringValue:hgt]];
                [statEventsArray addObject:statEvent];
                [statEvent release];
                tl = tl->next;
            }
            
            // (5) collect to complete description of the regressor
            [tbrDesign insertChildren:statEventsArray atIndex:0];
            [tRegressor insertChild:tbrDesign atIndex:0];
            [desStruct insertChild:tRegressor atIndex:i];
            [tbrDesign release];
            [tRegressor release];
            
        }
        //(6) now set it to the config (mostly: edl) file
        [configCopy replaceProp:@"$dynDesign" withNode:desStruct];
        /**********************/
        
        
        
        NSError *err = [configCopy writeToFile:path];
        [desStruct release];
        if (nil != err){
            NSLog(@"%@", err);
            return [NSError errorWithDomain:[err description] code:WRITE_OUTPUT userInfo:nil];
        }
    }
    else
    {
        
        NSError *err = [[[COExperimentContext getInstance] systemConfig] writeToFile:path];
        
        if (nil != err){
            NSLog(@"%@", err);
            return [NSError errorWithDomain:[err description] code:WRITE_OUTPUT userInfo:nil];
        }
    }
    return nil;
}

-(Complex)multiplComplex:(Complex)a withComplex:(Complex) b
{
    Complex w;
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
	Complex valueEventSeries;
    Complex valueGammaKernel;
    Complex multiplResult;
	
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
    for (unsigned int timestep = 0; timestep < self.mNumberTimesteps; timestep++) {
        j = (int) (mTimeOfRepetitionStartInMs[timestep] / samplingRateInMs + 0.5);
        
        if (j < mNumberSamplesForInit) {
			mRegressorValues[col][timestep] = mBuffersInverseOut[eventNr][j];
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


-(NSNumber*)getValueFromExplanatoryVariable:(NSUInteger)cov
                                 atTimestep:(NSUInteger)t
{
    __block NSNumber *value = nil;
    
    //__block BOOL designChanged = mDesignHasChanged;
    dispatch_sync(serialDesignElementAccessQueue, ^{
        
        // At first check if design is still valid or something has changed
        if (YES == mDesignHasChanged)
        {
            NSError *error = [self updateDesign];
            if (nil != error){
                NSLog(@"%@", error);
                return;
            }
        }
        if (cov < self.mNumberRegressors) {
            if (mRegressorValues != NULL) {
                //if (IMAGE_DATA_FLOAT == mImageDataType){
                value = [NSNumber numberWithFloat:mRegressorValues[cov][t]];
                //} else {
                //  NSLog(@"Cannot identify type of design image - no float");
                //}
            } else {
                NSLog(@"%@: generateDesign has not been called yet! (initial design information NULL)", self);
            }
        } else {
            int covIndex = cov - self.mNumberRegressors;
            value = [NSNumber numberWithFloat:mCovariateValues[covIndex][t]];
        }
    });
    return value;
    
}

-(void)setRegressor:(TrialList *)regressor
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        free(mRegressorList[regressor->trial.trialid -1]->regTrialList);
        mRegressorList[regressor->trial.trialid - 1]->regTrialList = regressor;
        mDesignHasChanged = YES;
    });
}

-(void)setRegressorTrial:(Trial)trial
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        //TODO: eine Logik falls sich Bereiche überschneiden in einem Eventtyp
        TrialList* newListEntry;
        newListEntry = (TrialList*) malloc(sizeof(TrialList));
        *newListEntry = TRIALLIST_INIT;
        newListEntry->trial = trial;
        
        if (NULL == mRegressorList[trial.trialid - 1]->regTrialList){
            mRegressorList[trial.trialid - 1]->regTrialList = newListEntry;
        } else {
            [self tl_append:mRegressorList[trial.trialid - 1]->regTrialList :newListEntry];
        }
        mDesignHasChanged = YES;
    });
    
}

-(void)setCovariate:(float*)covariate forCovariateID:(NSUInteger)covID
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        if (mCovariateValues != NULL) {
            free(mCovariateValues[covID - 1]);
            mCovariateValues[covID - 1] = NULL;
            mCovariateValues[covID - 1] = covariate;
        } else {
            NSLog(@"Could not set covariate values for CovariateID %ld because number of covariates is 0.", covID);
        }
    });
    
}

-(void)setCovariateValue:(float)value forCovariateID:(NSUInteger)covID atTimestep:(NSUInteger)timestep
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        if (mCovariateValues != NULL) {
            mCovariateValues[covID - 1][timestep] = value;
        } else {
            NSLog(@"Could not set covariate value %f for CovariateID %ld at timestep %ld because number of covariates is 0.", value, covID, timestep);
        }
    });
}

-(void)dealloc
{
    for (unsigned int col = 0; col < self.mNumberRegressors; col++) {
        free(mRegressorValues[col]);
    }
    free(mRegressorValues);
    
    if (mCovariateValues != NULL) {
        for (unsigned int cov = 0; cov < self.mNumberCovariates; cov++) {
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
		
        TrialList* node;
        TrialList* tmp;
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
    
    dispatch_release(serialDesignElementAccessQueue);
    [super dealloc];
}

-(NSError*)correctForZeromean
{
	for (unsigned int i = 0; i < mNumberEvents; i++) {
		float sum1 = 0.0;
		float sum2 = 0.0;
		float nx   = 0.0;
		
		TrialList* currentTrial;
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
