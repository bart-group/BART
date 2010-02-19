//
//  BADesignElementDyn.m
//  BARTApplication
//
//  Created by FirstLast on 1/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BADesignElementDyn.h"

#import <fftw3.h>

#include <viaio/VImage.h>

extern int VStringToken (char *, char *, int, int);

// komische Konstanten erstmal aus vgendesign.c (Lipsia) uebernommen
static const int BUFFER_LENGTH = 10000;
static const int MAX_NUMBER_TRIALS = 5000;
static const int MAX_NUMBER_EVENTS = 4;
const TrialList TRIALLIST_INIT = { {0,0,0,0}, NULL};

@interface BADesignElementDyn (PrivateMethods)

/* Standard parameter values for gamma function, Glover 99. */
double a1 = 6.0;     
double b1 = 0.9;
double a2 = 12.0;
double b2 = 0.9;
double cc = 0.35;

/* Generated design information/resulting design image. */
//VImage mDesign = NULL;
float** mDesign = NULL;

/* Attributes that should be modifiable (were once CLI parameters). */
//VShort bkernel = 0;
short bkernel = 0;
//VShort deriv = 0;
short deriv = 0;
//VFloat block_threshold = 10.0; // in seconds
float block_threshold = 10.0; // in seconds
//VLong  ntimesteps = 396;       // Must be set to a different value!
int ntimesteps = 396;       // Must be set to a different value!
//VFloat tr = 2.0;               // Must be set to a different value!
float tr = 2.0;               // Must be set to a different value!

/* Other Attributes set up by initDesign. Main use in generate Design. */
int numberSamples;
double delta = 20.0;           /* Temporal resolution for convolution is 20 ms. */
double t1 = 30.0;              /* HRF duration / Breite der HRF.                */

fftw_complex *fkernelg = NULL;
fftw_complex *fkernel0 = NULL;
fftw_complex *fkernel1 = NULL;
fftw_complex *fkernel2 = NULL;

double **forwardInBuffers = NULL;
fftw_plan *forwardFFTplans;
fftw_plan *inverseFFTplans;
double *xx = NULL;
double **inverseOutBuffers = NULL;
fftw_complex **forwardOutBuffers = NULL; // Resulting HRFs (one per Event).
fftw_complex **inverseInBuffers = NULL;
/* Other Attributes END. */

-(void)parseInputFile:(NSString*)path;
-(void)initDesign;

-(Complex)complex_mult:(Complex)a :(Complex)b;
-(double)xgamma:(double)xx :(double)t0;
-(double)bgamma:(double)xx :(double)t0;
-(double)deriv1_gamma:(double)x :(double)t0;
-(double)deriv2_gamma:(double)x :(double)t0;
-(double)xgauss:(double)xx :(double)t0;
//-(VImage)Plot_gamma:(VShort)deriv;
-(float**)Plot_gamma:(short)deriv;
-(BOOL)test_ascii:(int)val;
-(void)Convolve:(int)col
               :(fftw_complex *)local_nbuf
               :(fftw_complex *)forwardOutBuffer
               :(double *)inverseOutBuffer
               :(fftw_plan)planInverseFFT
               :(fftw_complex *)fkernel;
/**
 * Utility function for TrialList.
 */
-(void)tl_append:(TrialList*)head
                :(TrialList*)newLast;

@end

@implementation BADesignElementDyn

// TODO: check if imageDataType still needed (here: float)
-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    self = [super init];
    
    if (type == IMAGE_DATA_FLOAT) {
        imageDataType = type;
    } else {
        NSLog(@" BADesignElementDyn.initWithFile: defaulting to IMAGE_DATA_FLOAT (other values are not supported)!");
        imageDataType = IMAGE_DATA_FLOAT;
    }
    
    trials = (TrialList**) malloc(sizeof(TrialList*) * MAX_NUMBER_EVENTS);
    for (int i = 0; i < MAX_NUMBER_EVENTS; i++) {
        trials[i] = NULL;
    }
    
    NSLog(@"GenDesign GCD: START");
    @try {
        [self parseInputFile:path];
    }
    @catch (NSException * e) {
        NSLog(@"%s: %s", e.name, e.reason);
        exit(1);
    }
    
    [self initDesign];
    [self generateDesign];
    NSLog(@"GenDesign GCD: END");
    
    numberCovariates = numberEvents * (deriv + 1) + 1;
    numberTimesteps = ntimesteps;
    repetitionTimeInMs = tr * 1000;

    [self writeDesignFile:@"/tmp/testDesign.v"];
    
    return self;
}

-(void)initDesign
{
    // TODO: parameterize or/and use config
    static char* filename = ""; // for file with scan times (scanfile)    
    static float delay = 6.0;              
    static float understrength = 0.35;
    static float undershoot = 12.0;
    
    static bool zeromean = YES;
    
    //    static VOptionDescRec  options[] = {
    //        {"tr",VFloatRepn,1,(VPointer) &tr,VOptionalOpt,NULL,"repetition_time in seconds"},
    //        {"ntimesteps",VLongRepn,1,(VPointer) &ntimesteps,VOptionalOpt,NULL,
    //            "number of timesteps"},
    //        {"scanfile",VStringRepn,1,(VPointer) &filename,VOptionalOpt,NULL,
    //            "ASCII file containing scan times in seconds"},
    //        {"delay",VFloatRepn,1,(VPointer) &delay,VOptionalOpt,NULL,"Response delay in seconds"},
    //        {"block",VFloatRepn,1,(VPointer) &block_threshold,VOptionalOpt,NULL,
    //            "Threshold for block in seconds"},
    //        {"bkernel",VShortRepn,1,(VPointer) &bkernel,VOptionalOpt,NULL,
    //            "Type of kernel for block events (0:gauss, 1:gamma)"},
    //        {"understrength",VFloatRepn,1,(VPointer) &understrength,VOptionalOpt,NULL,
    //            "Strength of undershoot"},
    //        {"undershoot",VFloatRepn,1,(VPointer) &undershoot,VOptionalOpt,NULL,"Undershoot"},
    //        {"deriv",VShortRepn,1,(VPointer) &deriv,VOptionalOpt,NULL,
    //            "Which derivatives to include (0:none, 1:1st, 2:2nd)"},
    //        {"zeromean",VBooleanRepn,1,(VPointer) &zeromean,VOptionalOpt,NULL,
    //            "Whether to set mean of parametric covariates to zero"}
    //    };
    
    int i;
    int j;
    char buf[BUFFER_LENGTH];

    double total_duration = 0.0;
    double u;

    //VParseFilterCmd(VNumber(options),options,argc,argv,&in_file,&out_file);
    
    /* check command line parameters */
    //    if (understrength < 0)      VError(" understrength must be >= 0");
    //    if (delay < 0)              VError(" delay must be >= 0");
    //    if (deriv < 0 || deriv > 2) VError(" parameter 'deriv' must be < 3");
    
    /* constant TR */
    if (strlen(filename) < 3) {
//        if (tr > 100)       VWarning(" TR must be given in seconds, not milliseconds");
//        if (tr < 0.0001)    VError(" TR must be specified");
//        if (ntimesteps < 2) VError(" 'ntimesteps' must be specified");
        if (tr > 100) {
            NSLog(@" Warning: TR must be given in seconds, not milliseconds!");
        }
        if (tr < 0.0001) {
            NSLog(@" Error: TR must be specified!");
        }
        if (ntimesteps < 2) {
            NSLog(@" Error: 'ntimesteps' must be specified!");
        }
        fprintf(stderr, " TR = %.3f\n", tr);
        
        xx = (double *) malloc(sizeof(double) * ntimesteps);
        for (i = 0; i < ntimesteps; i++) {
            xx[i] = (double) i * tr * 1000.0;
        }
    }
    /* read scan times from file, non-constant TR */
    else {
        FILE *fp = NULL;
        fp = fopen(filename, "r");
        if (!fp) {
            NSLog(@" error opening file %s", filename);
        }
        fprintf(stderr, " reading scan file: %s\n", filename);
        
        i = 0;
        while (!feof(fp)) {
            for (j = 0; j < BUFFER_LENGTH; j++) buf[j] = '\0';
            fgets(buf, BUFFER_LENGTH, fp);
            if (buf[0] == '%' || buf[0] == '#') continue;
            if (strlen(buf) < 2) continue;
//            if (![self test_ascii:((int) buf[0])]) VError(" scan file must be a text file");
            if (![self test_ascii:((int) buf[0])]) {
                NSLog(@" Error: scan file must be a text file");
            }
            i++;
        }
        
        rewind(fp);
        ntimesteps = i;
//        xx = (double *) VCalloc(ntimesteps, sizeof(double));
        xx = (double *) malloc(sizeof(double) * ntimesteps);
        i = 0;
        while (!feof(fp)) {
            for (j = 0; j < BUFFER_LENGTH; j++) buf[j] = '\0';
            fgets(buf, BUFFER_LENGTH, fp);
            if (buf[0] == '%' || buf[0] == '#') continue;
            if (strlen(buf) < 2) continue;
//            if (sscanf(buf, "%lf", &u) != 1) VError(" line %d: illegal input format", i + 1);
            if (sscanf(buf, "%lf", &u) != 1) {
                NSLog(@" Error: line %d: illegal input format", i + 1);
            }
            xx[i] = u * 1000.0;
            i++;
        }
        fclose(fp);
    }
    total_duration = (xx[0] + xx[ntimesteps - 1]) / 1000.0;
    fprintf(stderr, "# num timesteps: %d,  experiment duration: %.2f min\n",
            ntimesteps, total_duration / 60.0);
    
    total_duration += 10.0; /* add 10 seconds to avoid FFT problems (wrap around) */
    
    /* set gamma function parameters */
    a1 = delay;
    a2 = undershoot;
    cc = understrength;
    
    /*
     ** check amplitude: must have zero mean for parametric designs
     */
    if (zeromean) {
        
        float sum1;
        float sum2;
        float nx;
        float mean;
        float sigma;
        
        for (i = 0; i < numberEvents; i++) {
            sum1 = 0.0;
            sum2 = 0.0;
            nx   = 0.0;
            
            TrialList* currentTrial;
            currentTrial = trials[i];
            
            while (currentTrial != NULL) {
                sum1 += currentTrial->trial.height;
                sum2 += currentTrial->trial.height * currentTrial->trial.height;
                nx++;
                currentTrial = currentTrial->next;
            }
            
            if (nx >= 1) {
                mean  = sum1 / nx;
                if (nx < 1.5) continue;      /* sigma not computable       */
                sigma =  sqrt((double)((sum2 - nx * mean * mean) / (nx - 1.0)));
                if (sigma < 0.01) continue;  /* not a parametric covariate */
                
                /* correct for zero mean */
                currentTrial = trials[i];
                
                while (currentTrial != NULL) {
                    currentTrial->trial.height -= mean;
                    currentTrial = currentTrial->next;
                }
            }
        }
    }
    if (numberEvents < 1) {
//        VError(" no events found");
        //TODO: create real error object and pass it to the calling method/instance.
        NSLog(@" Error: no events founds!");
    }
    
    
    /*
     ** create output design file in vista-format
     */
    
    
    /* get number of columns in design matrix, and event type (block) */
    //event_type = (VBoolean *) VMalloc(sizeof(VBoolean) * nevents);
    //for (i=0; i<nevents; i++) event_type[i] = FALSE;
    
    float xmin;
    int ncols = 0;
    //VBoolean block = FALSE;
    for (i = 0; i < numberEvents; i++) {
        
//        xmin = VRepnMaxValue(VFloatRepn);
        xmin = FLT_MAX;
        
        TrialList* currentTrial;
        currentTrial = trials[i];
        
        while (currentTrial != NULL) {
            if (currentTrial->trial.duration < xmin) {
                xmin = currentTrial->trial.duration;
            }
            currentTrial = currentTrial->next;
        }
        
//        block = FALSE;
//        if (xmin >= block_threshold) {
//            block = TRUE;
//        }
//        event_type[i] = block;
        
        //if (block || deriv == 0) ncols++;
        if (0 == deriv) {
            ncols++;
        } else if (1 == deriv) {
            ncols += 2;
        } else if (2 == deriv) {
            ncols += 3;
        }
    }
    fprintf(stderr, "# number of events: %d,  num columns in design matrix: %d\n", numberEvents, ncols + 1);
    
//    mDesign = VCreateImage(1, ntimesteps, ncols + 1, VFloatRepn);
    mDesign = (float**) malloc(sizeof(float*) * (ncols + 1));
    for (int col = 0; col < ncols + 1; col++) {
        mDesign[col] = (float*) malloc(sizeof(float) * ntimesteps);
         for (int ts = 0; ts < ntimesteps; ts++) {
             if (col == ncols) {
                 mDesign[col][ts] = 1.0;
             } else {
                 mDesign[col][ts] = 0.0;
             }
         }
    }
//    VSetAttr(VImageAttrList(mDesign), "modality", NULL, VStringRepn, "X");
//    VSetAttr(VImageAttrList(mDesign), "name", NULL, VStringRepn, "X");
//    VSetAttr(VImageAttrList(mDesign), "repetition_time", NULL, VLongRepn, (VLong) (tr * 1000.0));
//    VSetAttr(VImageAttrList(mDesign), "ntimesteps", NULL, VLongRepn, (VLong) ntimesteps);
//    
//    VSetAttr(VImageAttrList(mDesign), "derivatives", NULL, VShortRepn, deriv);
//    VSetAttr(VImageAttrList(mDesign), "delay", NULL, VFloatRepn, delay);
//    VSetAttr(VImageAttrList(mDesign), "undershoot", NULL, VFloatRepn, undershoot);
//    sprintf(buf, "%.3f", understrength);
//    VSetAttr(VImageAttrList(mDesign), "understrength", NULL, VStringRepn, &buf);
//    
//    VSetAttr(VImageAttrList(mDesign), "nsessions", NULL, VShortRepn, (VShort) 1);
//    VSetAttr(VImageAttrList(mDesign), "designtype", NULL, VShortRepn, (VShort) 1);
//    VFillImage(mDesign, VAllBands, 0);
    
//    for (j = 0; j < ntimesteps; j++) {
//        VPixel(mDesign, 0, j, ncols, VFloat) = 1;
//    }
    
    /* alloc memory */
    numberSamples = (int) (total_duration * 1000.0 / delta);
    
    //    if (n > 300000) { /* reduce to 30 ms, if too big */
    //        delta = 30.0;
    //        n = (int) (total_duration * 1000.0 / delta);
    //    }
    
    int nc = (numberSamples / 2) + 1;

    /* make plans */
    forwardFFTplans = (fftw_plan *) malloc(sizeof(fftw_plan) * numberEvents);
    inverseFFTplans = (fftw_plan *) malloc(sizeof(fftw_plan) * numberEvents);
    
    forwardInBuffers = (double **) malloc(sizeof(double *) * numberEvents);
    forwardOutBuffers = (fftw_complex **) malloc(sizeof(fftw_complex *) * numberEvents);
    inverseInBuffers = (fftw_complex **) malloc(sizeof(fftw_complex *) * numberEvents);
    inverseOutBuffers = (double **) malloc(sizeof(double *) * numberEvents);
    
    for (int eventNr = 0; eventNr < numberEvents; eventNr++) {
        
        forwardInBuffers[eventNr] = (double *) fftw_malloc(sizeof(double) * numberSamples);
        forwardOutBuffers[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * nc);
        memset(forwardInBuffers[eventNr], 0, sizeof(double) * numberSamples);
        
        inverseInBuffers[eventNr] = (fftw_complex *) fftw_malloc(sizeof(fftw_complex) * nc);
        inverseOutBuffers[eventNr] = (double *) fftw_malloc(sizeof(double) * numberSamples);
        memset(inverseOutBuffers[eventNr], 0, sizeof(double) * numberSamples);

        forwardFFTplans[eventNr] = fftw_plan_dft_r2c_1d(numberSamples, forwardInBuffers[eventNr], forwardOutBuffers[eventNr], FFTW_ESTIMATE);
        inverseFFTplans[eventNr] = fftw_plan_dft_c2r_1d(numberSamples, inverseInBuffers[eventNr], inverseOutBuffers[eventNr], FFTW_ESTIMATE);
    }
    
    /* get kernel */
    double *block_kernel = NULL;
    block_kernel = (double *) fftw_malloc(sizeof(double) * numberSamples);
    fkernelg = (fftw_complex *) fftw_malloc (sizeof(fftw_complex) * nc);
    memset(block_kernel, 0, sizeof(double) * numberSamples);
    
    double *kernel0 = NULL;
    kernel0  = (double *)fftw_malloc(sizeof(double) * numberSamples);
    fkernel0 = (fftw_complex *)fftw_malloc (sizeof(fftw_complex) * nc);
    memset(kernel0, 0, sizeof(double) * numberSamples);
    
    double *kernel1 = NULL;
    if (deriv >= 1) {
        kernel1  = (double *)fftw_malloc(sizeof(double) * numberSamples);
        fkernel1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
        memset(kernel1,0,sizeof(double) * numberSamples);
    }
    
    double *kernel2 = NULL;
    if (deriv == 2) {
        kernel2  = (double *)fftw_malloc(sizeof(double) * numberSamples);
        fkernel2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
        memset(kernel2,0,sizeof(double) * numberSamples);
    }
    
    i = 0;
    double t;
    double dt = delta / 1000.0; /* Delta (temporal resolution) in seconds. */
    for (t = 0.0; t < t1; t += dt) {
        if (i >= numberSamples) break;
        
        /* Gauss kernel for block designs */
        if (bkernel == 0) {
            block_kernel[i] = [self xgauss:t :5.0];
        } else if (bkernel == 1) {
            block_kernel[i] = [self bgamma:t :0.0];
        }
        
        kernel0[i] = [self xgamma:t :0];
        if (deriv >= 1) {
            kernel1[i] = [self deriv1_gamma:t :0.0];
        }
        if (deriv == 2) {
            kernel2[i] = [self deriv2_gamma:t :0.0];
        }
        i++;
    }
    
    /* fft for kernels */
    fftw_plan pkg;
    pkg = fftw_plan_dft_r2c_1d(numberSamples, block_kernel, fkernelg, FFTW_ESTIMATE);
    fftw_execute(pkg);
    
    fftw_plan pk0;
    pk0 = fftw_plan_dft_r2c_1d(numberSamples, kernel0, fkernel0, FFTW_ESTIMATE);
    fftw_execute(pk0);
    
    fftw_plan pk1;
    if (deriv >= 1) {
        pk1 = fftw_plan_dft_r2c_1d(numberSamples, kernel1, fkernel1, FFTW_ESTIMATE);
        fftw_execute(pk1);
    }
    
    fftw_plan pk2;
    if (deriv == 2) {
        pk2 = fftw_plan_dft_r2c_1d(numberSamples, kernel2, fkernel2, FFTW_ESTIMATE);
        fftw_execute(pk2);
    }
    
    fftw_free(block_kernel);
    fftw_free(kernel0);
    fftw_free(kernel1);
    fftw_free(kernel2);
}

-(void)generateDesign
{
    
    dispatch_queue_t queue;       /* Global asyn. dispatch queue. */
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    /* For each event and trial do... */
    dispatch_apply(numberEvents, queue, ^(size_t eventNr) {
        memset(forwardInBuffers[eventNr], 0, sizeof(double) * numberSamples);
        
        /* get data */
        int trialcount = 0;
        double t0;
        double h;
        float minTrialDuration = block_threshold;
        
        TrialList* currentTrial;
        currentTrial = trials[eventNr];
        
        while (currentTrial != NULL) {
            trialcount++;
            
            //block = event_type[eventNr];
            if (currentTrial->trial.duration < minTrialDuration) {
                minTrialDuration = currentTrial->trial.duration;
            }
            t0 = currentTrial->trial.onset;
            double tmax = currentTrial->trial.onset + currentTrial->trial.duration;
            h  = currentTrial->trial.height;
            
            t0 *= 1000.0;
            tmax *= 1000.0;
            
            int k = t0 / delta;
            
            for (double t = t0; t <= tmax; t += delta) {
                if (k >= numberSamples) {
                    break;
                }
                forwardInBuffers[eventNr][k++] += h;
            }
            
            currentTrial = currentTrial->next;
        }
        
        if (trialcount < 1) {
            NSLog(@" no trials in event %d, please re-number event-ids. Aborting program.", eventNr + 1);
            exit(1);
        }
        if (trialcount < 4) {
            NSLog(@" Warning: too few trials (%d) in event %d. Statistics will be unreliable.",
                  trialcount, eventNr + 1);
        }
        
        /* fft */
        fftw_execute(forwardFFTplans[eventNr]);
        
        int col = eventNr * (deriv + 1);
        
        if (minTrialDuration >= block_threshold) {
            [self Convolve:col 
                          :inverseInBuffers[eventNr]
                          :forwardOutBuffers[eventNr]
                          :inverseOutBuffers[eventNr]
                          :inverseFFTplans[eventNr]
                          :fkernelg];
        } else {
            [self Convolve:col
                          :inverseInBuffers[eventNr]
                          :forwardOutBuffers[eventNr]
                          :inverseOutBuffers[eventNr]
                          :inverseFFTplans[eventNr]
                          :fkernel0];
        }
        
        col++;
        
        if (deriv >= 1) {
            [self Convolve:col
                          :inverseInBuffers[eventNr]
                          :forwardOutBuffers[eventNr]
                          :inverseOutBuffers[eventNr]
                          :inverseFFTplans[eventNr]
                          :fkernel1];
            col++;
        }
        
        if (deriv == 2) {
            [self Convolve:col
                          :inverseInBuffers[eventNr]
                          :forwardOutBuffers[eventNr]
                          :inverseOutBuffers[eventNr]
                          :inverseFFTplans[eventNr]
                          :fkernel2];
        }
    });
    
//    VAttrList out_list = NULL;                         
//    out_list = VCreateAttrList();
//    VAppendAttr (out_list, "image", NULL, VImageRepn, mDesign);
//    
//    VImage plot_image = NULL;
//    plot_image = [self Plot_gamma:deriv];
//    VAppendAttr (out_list, "plot_gamma", NULL, VImageRepn, plot_image);
//    
//    FILE *out_file = fopen("/tmp/testDesign.v", "w");
//    
//    if (!VWriteFile(out_file, out_list)) {
//        exit(1);
//    }
//    fclose(out_file);
}

-(void)parseInputFile:(NSString *)path
{
    
    int character;
    int trialID    = 0;
    float onset    = 0.0;
    float duration = 0.0;
    float height   = 0.0;
    
    numberTrials = 0;
    numberEvents = 0;
    NSLog(@" numberTrials: %d\n", numberTrials);
    
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
                for (int j = 0; j < strlen(buffer); j++) {
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
//                    VError(" line %d: illegal input format", numberTrials + 1);
                    NSLog(@" line %d: illegal input format", numberTrials + 1);
                    NSException *e = [NSException exceptionWithName:@"DesignFileFormatException" 
                                                             reason:@"Illegal design file input format! Expected format: one entry per line and columns separated by tabs." 
                                                           userInfo:nil];
                    @throw e;
                    
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
                
                if (trials[trialID - 1] == NULL) {
                    trials[trialID - 1] = newListEntry;
                    numberEvents++;
                } else {
                    [self tl_append:trials[trialID - 1] :newListEntry];
                }
                
                numberTrials++;
                
                if (numberTrials > MAX_NUMBER_TRIALS) {
                    NSLog(@" too many trials %d. Aborting program.\n", numberTrials);
                    exit(1);
                }
            }
        }
    }
    fclose(inFile);  
    free(inputFilename);
}

-(void)writeDesignFile:(NSString*) path 
{
    VImage outDesign = NULL;
    outDesign = VCreateImage(1, ntimesteps, numberCovariates, VFloatRepn);
    
    VSetAttr(VImageAttrList(outDesign), "modality", NULL, VStringRepn, "X");
    VSetAttr(VImageAttrList(outDesign), "name", NULL, VStringRepn, "X");
    VSetAttr(VImageAttrList(outDesign), "repetition_time", NULL, VLongRepn, (VLong) (tr * 1000.0));
    VSetAttr(VImageAttrList(outDesign), "ntimesteps", NULL, VLongRepn, (VLong) ntimesteps);
    
    VSetAttr(VImageAttrList(outDesign), "derivatives", NULL, VShortRepn, deriv);
    
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
    
    for (int col = 0; col < numberCovariates; col++) {
        for (int ts = 0; ts < ntimesteps; ts++) {
            VPixel(outDesign, 0, ts, col, VFloat) = (VFloat) mDesign[col][ts];
        }
    }
    
    
    VAttrList out_list = NULL;                         
    out_list = VCreateAttrList();
    VAppendAttr(out_list, "image", NULL, VImageRepn, outDesign);
    
    // Numbers taken from Plot_gamma()
    int ncols = (int) (28.0 / 0.2);
    int nrows = deriv + 2;
    VImage plot_image = NULL;
    plot_image = VCreateImage(1, nrows, ncols, VFloatRepn);
    float** plot_image_raw = NULL;
    plot_image_raw = [self Plot_gamma:deriv];
    
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
        exit(1);
    }
    
    fclose(out_file);
    free(outputFilename);
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
    
    double x = xx - t0;
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
-(double)deriv2_gamma:(double) x
                     :(double) t0
{
    double d1;
    double d2;
    double y1;
    double y2;
    double y3;
    double y4;
    double y;
    double xx;
    
    double scale=20.0;
    
    xx = x - t0;
    if (xx < 0 || xx > 50) {
        return 0;
    }
    
    d1 = a1 * b1;
    d2 = a2 * b2;
    
    y1 = pow(d1, -a1) * a1 * (a1 - 1) * pow(xx, a1 - 2) * exp(-(xx - d1) / b1) 
                - pow(d1, -a1) * a1 * pow(xx, (a1 - 1)) * exp(-(xx - d1) / b1) / b1;
    y2 = pow(d1, -a1) * a1 * pow(xx, a1 - 1) * exp(-(xx - d1) / b1) / b1
                - pow((xx / d1), a1) * exp(-(xx - d1) / b1) / (b1 * b1);
    y1 = y1 - y2;
    
    y3 = pow(d2, -a2) * a2 * (a2 - 1) * pow(xx, a2 - 2) * exp(-(xx - d2) / b2) 
                - pow(d2, -a2) * a2 * pow(xx, (a2 - 1)) * exp(-(xx - d2) / b2) / b2;
    y4 = pow(d2, -a2) * a2 * pow(xx, a2 - 1) * exp(-(xx - d2) / b2) / b2
                - pow((xx / d2), a2) * exp(-(xx - d2) / b2) / (b2 * b2);
    y2 = y3 - y4;
    
    y = y1 - cc * y2;
    y /= scale;
    
    return y;
}

/* Gaussian function. */
-(double)xgauss:(double)xx
               :(double)t0
{
    double sigma = 1.0;
    double scale = 20.0;
    double x;
    double y;
    double z;
    double a=2.506628273;
    
    x = (xx - t0);
    z = x / sigma;
    y = exp((double) - z * z * 0.5) / (sigma * a);
    y /= scale;
    return y;
}

// TODO: VImage entfernen, einfache float-Matrix wuerde es auch tun
//-(VImage)Plot_gamma:(VShort)deriv
-(float**)Plot_gamma:(short)deriv
{
    double y0;
    double y1;
    double y2;
    double t0 = 0.0;
    double step = 0.2;
    
    int ncols = (int) (28.0 / step);
    int nrows = deriv + 2;
    
//    VImage dest = NULL;
//    dest = VCreateImage(1, nrows, ncols, VFloatRepn);
    float** dest = (float**) malloc(sizeof(float*) * ncols);
    for (int col = 0; col < ncols; col++) {
        
        dest[col] = (float*) malloc(sizeof(float) * nrows);
        for (int row = 0; row < nrows; row++) {
            dest[col][row] = 0.0;
        }
    }
    
//    VFillImage(dest, VAllBands, 0);
    
    int j = 0;
    for (double x = 0.0; x < 28.0; x += step) {
        if (j >= ncols) {
            break;
        }
        y0 = [self xgamma:x :t0];
        y1 = [self deriv1_gamma:x :t0];
        y2 = [self deriv2_gamma:x :t0];
//        VPixel(dest, 0, 0, j, VFloat) = x;
//        VPixel(dest, 0, 1, j, VFloat) = y0;
        dest[j][0] = x;
        dest[j][1] = y0;
        if (deriv > 0) {
//            VPixel(dest, 0, 2, j, VFloat) = y1;
            dest[j][2] = y1;
        }
        if (deriv > 1) {
//            VPixel(dest, 0, 3, j, VFloat) = y2;
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

-(void)Convolve:(int)col
               :(fftw_complex *)local_nbuf
               :(fftw_complex *)forwardOutBuffer
               :(double *)inverseOutBuffer
               :(fftw_plan)planInverseFFT
               :(fftw_complex *)fkernel
{
    Complex a;
    Complex b;
    Complex c;
    
    int nc = (numberSamples / 2) + 1;
    
    /* convolution */
    int j;
    for (j = 0; j < nc; j++) {
        a.re = forwardOutBuffer[j][0];
        a.im = forwardOutBuffer[j][1];
        b.re = fkernel[j][0];
        b.im = fkernel[j][1];
        c = [self complex_mult:a :b];    
        local_nbuf[j][0] = c.re;
        local_nbuf[j][1] = c.im;
    }
    
    /* inverse fft */
    fftw_execute(planInverseFFT);
    
    /* scaling */
    for (j = 0; j < numberSamples; j++) {
        inverseOutBuffer[j] /= (double) numberSamples;
    }
    
    /* sampling */
    for (int timestep = 0; timestep < ntimesteps; timestep++) {
        j = (int) (xx[timestep] / delta + 0.5);
        
        if (j >= 0 && j < numberSamples) {
//            VPixel(mDesign, 0, timestep, col, VFloat) = inverseOutBuffer[j];
            mDesign[col][timestep] = inverseOutBuffer[j];
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


-(NSNumber*)getValueFromCovariate:(int)cov 
                       atTimestep:(int)t 
{
    NSNumber *value = nil;
    if (mDesign != NULL) {
        if (IMAGE_DATA_FLOAT == imageDataType){
//            value = [NSNumber numberWithFloat:VGetPixel(mDesign, 0, t, cov)];
            value = [NSNumber numberWithFloat:mDesign[cov][t]];
        } else {
            NSLog(@"Cannot identify type of design image - no float");
        }
    } else {
        NSLog(@"%@: generateDesign has not been called yet! (initial design information NULL)", self);
    }
    
    return value;
}

-(void)setRegressor:(TrialList *)regressor
{
    trials[regressor->trial.id - 1] = regressor;
    
    [self generateDesign];
}

-(void)dealloc
{
    //VFree(mDesign);
    for (int col = 0; col < numberCovariates; col++) {
        free(mDesign[col]);
    }
    free(mDesign);
    
    free(xx);
    
    for (int eventNr = 0; eventNr < numberEvents; eventNr++) {
        fftw_free(forwardInBuffers[eventNr]);
        fftw_free(forwardOutBuffers[eventNr]);
        fftw_free(inverseInBuffers[eventNr]);
        fftw_free(inverseOutBuffers[eventNr]);
        
        TrialList* node;
        TrialList* tmp;
        node = trials[eventNr];
        while (node != NULL) {
            tmp = node;
            node = node -> next;
            free(tmp);
        }
    }
    
    free(trials);
    free(forwardInBuffers);
    fftw_free(forwardOutBuffers);
    fftw_free(inverseInBuffers);
    free(inverseOutBuffers);
    fftw_free(fkernelg);
    fftw_free(fkernel0);
    fftw_free(fkernel1);
    fftw_free(fkernel2);
    
    free(forwardFFTplans);
    free(inverseFFTplans);

    [super dealloc];
}

@end
