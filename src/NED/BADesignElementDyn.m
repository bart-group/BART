//
//  BADesignElementDyn.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 1/29/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BADesignElementDyn.h"
#import "COSystemConfig.h"

// just as long as it will be written as .v
#include <viaio/VImage.h>

@implementation BADesignElementDyn

const int BUFFER_LENGTH = 10000;
const int MAX_NUMBER_EVENTS = 100;
double samplingRateInMs = 20.0;           /* Temporal resolution for convolution is 20 ms. */
double t1 = 30.0;              /* HRF duration / Breite der HRF.                */
const TrialList TRIALLIST_INIT = { {0,0,0,0}, NULL};


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
	NSError* error = nil;
	
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
		error = [NSError errorWithDomain:errorString code:EVENT_NUMERATION userInfo:nil];
		NSLog(@"%@", errorString); 
	}

	
	NSString* config_tr = [config getProp:@"$TR"];
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	//TODO : Abfrage Einheit der repetition Time
	mRepetitionTimeInMs = [[f numberFromString:config_tr] intValue];
	NSString* config_nrTimesteps = [config getProp:@"$nrTimesteps"];

	mNumberTimesteps = [[f numberFromString:config_nrTimesteps] intValue];
	NSLog(@"length of Exp: %d", mNumberTimesteps);
	//mNumberTimesteps = 720;//[[f numberFromString:config_nrTimesteps] intValue]; //TODO get from config
	
	mNumberRegressors = [config countNodes:@"$gwDesign/timeBasedRegressor"];
	NSLog(@"Regressors: %d", mNumberRegressors);
	mNumberCovariates = [config countNodes:@"$gwDesign/timeBasedRegressor"];     // TODO: get from config  
	
	NSString *time = [config getProp:@"$gwDesign/timeBasedRegressor[1]/tbrDesign[1]/statEvent[1]/@time" ];
	NSString* t = [NSString stringWithFormat:@"%d", 5];
	
	NSUInteger nrEvents = [config countNodes:@"$gwDesign/timeBasedRegressor[1]/tbrDesign[1]/statEvent" ];
	NSLog(@"Time: %d", nrEvents);
	
	
	/**********************************/
		
	for (unsigned int i = 0; i < mNumberRegressors; i++)
	{
		NSString *requestTrialsInReg = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign[%d]/statEvent", i+1];
		NSUInteger nrTrialsInRegr = [config countNodes:requestTrialsInReg ];
		unsigned int trialID = i+1;

		for (unsigned int k = 0; k < nrTrialsInRegr; k++)
		{
			NSString *requestTrialTime = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign[%d]/statEvent[%d]/@time", k+1];
			NSString *requestTrialDuration = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign[%d]/statEvent[%d]/@duration", k+1];
			NSString *requestTrialHeight = [NSString stringWithFormat:@"$gwDesign/timeBasedRegressor[%d]/tbrDesign[%d]/statEvent[%d]/@height", k+1];
			float onset = [[f numberFromString:requestTrialTime] floatValue];
			float duration = [[f numberFromString:requestTrialDuration] floatValue];
			float height = [[f numberFromString:requestTrialHeight] floatValue];
				
			if (0.0 >= duration) {//if not set or negative
				duration = 1.0;
			}
			if (0.0 >= height){//if not set
				height = 1.0;}
			
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
			
		}		mNumberTrials++;
	
	}
	
	
	/**********************************/
	
	
	mDerivationsHrf = 0;
	[f release];//temp for conversion purposes
	mNumberSamplesForInit = (mNumberTimesteps * mRepetitionTimeInMs) / samplingRateInMs + 10000;//add some seconds to avoid wrap around problems with fft, here defined as 10s
	
	
	return error;
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
    
    mDesign = (float** ) malloc(sizeof(float*) * (ncols + 1));
    for (int col = 0; col < ncols + 1; col++) {
        mDesign[col] = (float*) malloc(sizeof(float) * mNumberTimesteps);
         for (unsigned int ts = 0; ts < mNumberTimesteps; ts++) {
             if (col == ncols) {
                 mDesign[col][ts] = 1.0;
             } else {
                 mDesign[col][ts] = 0.0;
             }
         }
    }
	
    /* alloc memory */
         
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
	mConvolutionKernels = (NEDesignKernel **) malloc(sizeof(NEDesignKernel*) * mNumberEvents);
    
    for (unsigned int eventNr = 0; eventNr < mNumberEvents; eventNr++) {
        
        mBuffersForwardIn[eventNr] = (double *) fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        mBuffersForwardOut[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * numberSamplesInResult);
        memset(mBuffersForwardIn[eventNr], 0, sizeof(double) * mNumberSamplesForInit);
        
        mBuffersInverseIn[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * numberSamplesInResult);
        mBuffersInverseOut[eventNr] = (double *) fftw_malloc(sizeof(double) * mNumberSamplesForInit);
        memset(mBuffersInverseOut[eventNr], 0, sizeof(double) * mNumberSamplesForInit);

        mFftPlanForward[eventNr] = fftw_plan_dft_r2c_1d(mNumberSamplesForInit, mBuffersForwardIn[eventNr], mBuffersForwardOut[eventNr], FFTW_ESTIMATE);
        mFftPlanInverse[eventNr] = fftw_plan_dft_c2r_1d(mNumberSamplesForInit, mBuffersInverseIn[eventNr], mBuffersInverseOut[eventNr], FFTW_ESTIMATE);
		
		//TODO get per event from config!!!!
		GloverParams params; //TODO everything in ms!!!!
		params.maxLengthHrfInMs = 30000;
		params.peak1 = 6.0;
		params.scale1 = 0.9;
		params.peak2 = 12.0;
		params.scale2 = 0.9;
		params.offset = 0.0;
		params.relationP1P2 = 0.1;
		params.heightScale = 120;
		
		mConvolutionKernels[eventNr] = [[NEDesignKernel alloc] initWithGloverParams:params andNumberSamples:mNumberSamplesForInit];
    }

    
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
        unsigned int trialcount = 0;
        double t0;
        double h;
		        
        TrialList* currentTrial;
        currentTrial = mTrialList[eventNr];
        
        while (currentTrial != NULL) {
            trialcount++;
        
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
  		[self Convolve:col
					  :eventNr
					  :mConvolutionKernels[eventNr].mKernelDeriv0];
        
        col++;
        
        if (1 <= mDerivationsHrf) {
            [self Convolve:col
						  :eventNr
                          :mConvolutionKernels[eventNr].mKernelDeriv1];
            col++;
        }
        
        if (2 == mDerivationsHrf) {
            [self Convolve:col
						  :eventNr
						  :mConvolutionKernels[eventNr].mKernelDeriv2];
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
    float delay = 6.0;              
    float understrength = 0.35;
    float undershoot = 12.0;
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
    plot_image_raw = [mConvolutionKernels[0] plotGammaWithDerivs:mDerivationsHrf];//take first event, here just one fct possible
    
    for (int col = 0; col < ncols; col++) {
        for (int row = 0; row < nrows; row++) {
            VPixel(plot_image, 0, row, col, VFloat) = (VFloat) plot_image_raw[col][row];
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
        j = (int) (mTimeOfRepetitionStartInMs[timestep] / samplingRateInMs + 0.5);
        
        if (j >= 0 && j < mNumberSamplesForInit) {
            mDesign[col][timestep] = mBuffersInverseOut[eventNr][j];
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
		free(mConvolutionKernels[eventNr]);
        
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
	free(mConvolutionKernels);
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
