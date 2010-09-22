///*
// *  NEDesignElementReference.c
// *  BARTApplication
// *
// *  Created by Lydia Hellrung on 8/31/10.
// *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
// *
// */
//
//#include "NEDesignElementReference.h"
//
//
//
///****************************************************************
// *
// * Program: vgendesign
// *
// * Copyright (C) Max Planck Institute 
// * for Human Cognitive and Brain Sciences, Leipzig
// *
// * Author Gabriele Lohmann, 2007, <lipsia@cbs.mpg.de>
// *
// * This program is free software; you can redistribute it and/or
// * modify it under the terms of the GNU General Public License
// * as published by the Free Software Foundation; either version 2
// * of the License, or (at your option) any later version.
// * 
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// * GNU General Public License for more details.
// * 
// * You should have received a copy of the GNU General Public License
// * along with this program; if not, write to the Free Software
// * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
// * 
// * $Id: vgendesign.c 3253 2008-04-11 11:01:07Z karstenm $
// *
// *****************************************************************/
//
//#include <viaio/VImage.h>
//#include <viaio/Vlib.h>
//#include <viaio/mu.h>
//#include <viaio/option.h>
//
//#include <stdio.h>
//#include <string.h>
//#include <math.h>
//#include <stdlib.h>
//#include <ctype.h>
//
//#include <fftw3.h>
//
//#import <time.h>
//#import <sys/time.h>
//
//
//#define LEN     10000
//#define NTRIALS  5000
//
//typedef struct TrialStruct{
//    int   id;
//    float onset;
//    float duration;         // in seconds
//    float height;
//} Trial;
//
//
//typedef struct {
//	int		secs;
//	int		usecs;
//} TIME_DIFF;
//
//TIME_DIFF * my_difftime (struct timeval * start, struct timeval * end)
//{
//	TIME_DIFF * diff = (TIME_DIFF *) malloc ( sizeof (TIME_DIFF) );
//	
//	if (start->tv_sec == end->tv_sec) {
//		diff->secs = 0;
//		diff->usecs = end->tv_usec - start->tv_usec;
//	}
//	else {
//		diff->usecs = 1000000 - start->tv_usec;
//		diff->secs = end->tv_sec - (start->tv_sec + 1);
//		diff->usecs += end->tv_usec;
//		if (diff->usecs >= 1000000) {
//			diff->usecs -= 1000000;
//			diff->secs += 1;
//		}
//	}
//	
//	return diff;
//}
//
//
//Trial trial[NTRIALS];
//int ntrials=0;
//
///* standard parameter values for gamma function,Glover 99 */
//double a1 = 6;     
//double b1 = 0.9;
//double a2 = 12;
//double b2 = 0.9;
//double cc = 0.35;
//
//
//extern int VStringToken (char *,char *,int,int);
//
//typedef struct ComplexStruct {
//    double re;
//    double im;
//} Complex;
//
//
//Complex
//complex_mult(Complex a, Complex b)
//{
//    Complex w;
//    w.re = a.re * b.re  -  a.im * b.im;
//    w.im = a.re * b.im  +  a.im * b.re;
//    return w;
//}
//
//
//
///*
// ** Glover kernel, gamma function
// */
//double
//xgamma(double xx,double t0)
//{
//    double x,y,scale=20;
//    double y1,y2;
//    double d1,d2;
//    
//    x = xx - t0;
//    if (x < 0 || x > 50) return 0;
//    
//    d1=a1*b1;
//    d2=a2*b2;
//    
//    y1 = pow(x/d1,a1) * exp(-(x-d1)/b1);
//    y2 = pow(x/d2,a2) * exp(-(x-d2)/b2);
//    
//    y = y1 - cc*y2;
//    y /= scale;
//    return y;
//}
//
//
///*
// ** Glover kernel, gamma function, parameters changed for block designs
// */
//double
//bgamma(double xx,double t0)
//{
//    double x,y,scale=120;
//    double y1,y2;
//    double d1,d2;
//    
//    double aa1 = 6;     
//    double bb1 = 0.9;
//    double aa2 = 12;
//    double bb2 = 0.9;
//    double cx  = 0.1;
//    
//    x = xx - t0;
//    if (x < 0 || x > 50) return 0;
//    
//    d1=aa1*bb1;
//    d2=aa2*bb2;
//    
//    y1 = pow(x/d1,aa1) * exp(-(x-d1)/bb1);
//    y2 = pow(x/d2,aa2) * exp(-(x-d2)/bb2);
//    
//    y = y1 - cx*y2;
//    y /= scale;
//    return y;
//}
//
//
///* first derivative */
//double
//deriv1_gamma(double x,double t0)
//{
//    double d1,d2,y1,y2,y,xx;
//    double scale=20.0;
//    
//    xx = x - t0;
//    if (xx < 0 || xx > 50) return 0;
//    
//    d1=a1*b1;
//    d2=a2*b2;
//    
//    y1 = pow(d1,-a1)*a1*pow(xx,(a1-1.0)) * exp(-(xx-d1)/b1) 
//    - (pow((xx/d1),a1) * exp(-(xx-d1)/b1)) / b1;
//    
//    y2 = pow(d2,-a2)*a2*pow(xx,(a2-1.0)) * exp(-(xx-d2)/b2) 
//    - (pow((xx/d2),a2) * exp(-(xx-d2)/b2)) / b2;
//    
//    y = y1 - cc*y2;
//    y /= scale;
//    return y;
//}
//
//
///* second derivative */
//double
//deriv2_gamma(double x,double t0)
//{
//    double d1,d2,y1,y2,y3,y4,y,xx;
//    double scale=20.0;
//    
//    xx = x - t0;
//    if (xx < 0 || xx > 50) return 0;
//    
//    d1=a1*b1;
//    d2=a2*b2;
//    
//    y1 = pow(d1,-a1)*a1*(a1-1)*pow(xx,a1-2) * exp(-(xx-d1)/b1) 
//    - pow(d1,-a1)*a1*pow(xx,(a1-1)) * exp(-(xx-d1)/b1)/b1;
//    y2 = pow(d1,-a1)*a1*pow(xx,a1-1) * exp(-(xx-d1)/b1) / b1
//    - pow((xx/d1),a1) * exp(-(xx-d1)/b1) / (b1*b1);
//    y1 = y1 - y2;
//    
//    
//    y3 = pow(d2,-a2)*a2*(a2-1)*pow(xx,a2-2) * exp(-(xx-d2)/b2) 
//    - pow(d2,-a2)*a2*pow(xx,(a2-1)) * exp(-(xx-d2)/b2)/b2;
//    y4 = pow(d2,-a2)*a2*pow(xx,a2-1) * exp(-(xx-d2)/b2) / b2
//    - pow((xx/d2),a2) * exp(-(xx-d2)/b2) / (b2*b2);
//    y2 = y3 - y4;
//    
//    y = y1 - cc*y2;
//    y /= scale;
//    return y;
//}
//
//
//
///* Gaussian function */
//double 
//xgauss(double xx,double t0)
//{
//    double sigma = 1.0;
//    double scale = 20.0;
//    double x,y,z,a=2.506628273;
//    
//    x = (xx-t0);
//    z = x / sigma;
//    y = exp((double)-z*z*0.5)/(sigma * a);
//    y /= scale;
//    return y;
//}
//
//
//
//
//VImage
//Plot_gamma(VShort deriv)
//{
//    VImage dest=NULL;
//    int nrows,ncols,j;
//    double x,y0,y1,y2,t0=0,step=0.2;
//    
//    ncols = 28 / step;
//    nrows = deriv + 2;
//    dest = VCreateImage(1, nrows, ncols, VFloatRepn);
//    VFillImage(dest,VAllBands,0);
//    
//    j = 0;
//    for (x=0; x < 28; x+= step) {
//        if (j >= ncols) break;
//        y0 = xgamma(x,t0);
//        y1 = deriv1_gamma(x,t0);
//        y2 = deriv2_gamma(x,t0);
//        VPixel(dest,0,0,j,VFloat) = x;
//        VPixel(dest,0,1,j,VFloat) = y0;
//        if (deriv > 0) VPixel(dest,0,2,j,VFloat) = y1;
//        if (deriv > 1) VPixel(dest,0,3,j,VFloat) = y2;
//        j++;
//    }
//    return dest;
//}
//
//
//
//int
//test_ascii(int val)
//{
//    if (val >= 'a' && val <= 'z') return 1;
//    if (val >= 'A' && val <= 'Z') return 1;
//    if (val >= '0' && val <= '9') return 1;
//    if (val ==  ' ') return 1;
//    if (val == '\0') return 1;
//    if (val == '\n') return 1;
//    if (val == '\r') return 1;
//    if (val == '\t') return 1;
//    if (val == '\v') return 1;
//    return 0;
//}
//
//void
//Convolve(VImage dest,int col,fftw_plan iplan,double *xx,int ntimesteps,double delta,
//         fftw_complex *fkernel,double *ibuf,fftw_complex *nbuf,fftw_complex *obuf,
//         int n)
//{
//    Complex a,b,c;
//    int i,j,nc;
//    
//    nc  = (n / 2) + 1;
//    
//    
//    /* convolution   */
//    for (j=0; j<nc; j++) {
//        a.re = obuf[j][0];
//        a.im = obuf[j][1];
//        b.re = fkernel[j][0];
//        b.im = fkernel[j][1];
//        c = complex_mult(a,b);    
//        nbuf[j][0] = c.re;
//        nbuf[j][1] = c.im;
//    }
//    
//    /* inverse fft */
//    fftw_execute(iplan);
//    
//    
//    /* scaling */
//    for (j=0; j<n; j++) ibuf[j] /= (double)n;
//    
//    
//    /* sampling */
//    for (i=0; i<ntimesteps; i++) {
//        j = (int)(xx[i]/delta + 0.5);
//        if (j < 0 || j >= n) continue;
//        VPixel(dest,0,i,col,VFloat) = ibuf[j];    
//    }
//}
//
//void parseInputFile(FILE *in_file, char *buffer, int bufferLength, Trial *trial, int *numberTrials, int *numberEvents);
//
//int
//createDesign (int argc,char *argv[])
//{
//    static VFloat tr  = 0;
//    static VLong  ntimesteps = 0;
//    static VString filename = "";                          
//    static VFloat delay = 6;
//    static VFloat understrength = 0.35;
//    static VFloat undershoot = 12;
//    static VShort deriv = 1;
//    static VShort bkernel = 0;
//    static VBoolean zeromean = TRUE;
//    static VFloat  block_threshold = 10.0;  // in seconds
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
//    FILE *in_file = NULL;
//    FILE *out_file = NULL;
//    FILE *fp = NULL;
//    
//    VAttrList out_list = NULL;                         
//    VImage dest = NULL;                                     // Resulting design image.
//    VImage plot_image = NULL;
//    
//    char   buf[LEN];
//    double t,t0,t1,h,dt;
//    float  sum1,sum2,nx,mean,sigma,xmin;
//    int    i,j,k,n,m,nc,col,ncols,nevents=0;
//    //int    id=0;
//    int    trialcount = 0;
//    //float  onset,duration,height;
//    
//    //VBoolean *event_type = NULL;
//    VBoolean block = FALSE;
//    double  total_duration = 0.0;
//    double  delta = 0.0;
//    double *xx = NULL, u;
//    double *ibuf = NULL, *ibuf1 = NULL;
//    double *kernel0 = NULL, *kernel1 = NULL, *kernel2 = NULL, *block_kernel = NULL;
//    fftw_complex *obuf = NULL;                                // Resulting HRF.
//    fftw_complex *nbuf = NULL;
//    fftw_complex *fkernel0=NULL,*fkernel1=NULL,*fkernel2=NULL,*fkernelg=NULL;
//    fftw_plan p1,pinv,pk0,pk1,pk2,pkg;
//    
//    char prg_name[50];	
//    
//    fprintf (stderr, "%s\n", prg_name);
//    
//    VParseFilterCmd(VNumber(options),options,argc,argv,&in_file,&out_file);
//    /**************************************/
//    
//    struct timeval timeStart, timeEnd;
//	TIME_DIFF *	difference;
//    gettimeofday(&timeStart, NULL);
//    
//    /**************************************/
//    
//    /* check command line parameters */
//    if (understrength < 0)      VError(" understrength must be >= 0");
//    if (delay < 0)              VError(" delay must be >= 0");
//    if (deriv < 0 || deriv > 2) VError(" parameter 'deriv' must be < 3");
//    
//    
//    /*
//     ** constant TR
//     */
//    if (strlen(filename) < 3) {
//        if (tr > 100)       VWarning(" TR must be given in seconds, not milliseconds");
//        if (tr < 0.0001)    VError(" TR must be specified");
//        if (ntimesteps < 2) VError(" 'ntimesteps' must be specified");
//        fprintf(stderr, " TR = %.3f\n", tr);
//        
//        xx = (double *) VCalloc(ntimesteps, sizeof(double));
//        for (i = 0; i < ntimesteps; i++) {
//            xx[i] = (double) i * tr * 1000.0;
//        }
//    }
//    
//    /*
//     ** read scan times from file, non-constant TR
//     */
//    else {
//        fp = fopen(filename, "r");
//        if (!fp) VError(" error opening file %s", filename);
//        fprintf(stderr, " reading scan file: %s\n", filename);
//        i = 0;
//        while (!feof(fp)) {
//            for (j = 0; j < LEN; j++) buf[j] = '\0';
//            fgets(buf, LEN, fp);
//            if (buf[0] == '%' || buf[0] == '#') continue;
//            if (strlen(buf) < 2) continue;
//            if (!test_ascii((int)buf[0])) VError(" scan file must be a text file");
//            i++;
//        }
//        
//        rewind(fp);
//        ntimesteps = i;
//        xx = (double *) VCalloc(ntimesteps, sizeof(double));
//        i = 0;
//        while (!feof(fp)) {
//            for (j = 0; j < LEN; j++) buf[j] = '\0';
//            fgets(buf, LEN, fp);
//            if (buf[0] == '%' || buf[0] == '#') continue;
//            if (strlen(buf) < 2) continue;
//            if (sscanf(buf,"%lf",&u) != 1) VError(" line %d: illegal input format",i+1);
//            xx[i] = u*1000.0;
//            i++;
//        }
//        fclose(fp);
//    }
//    total_duration = (xx[0] + xx[ntimesteps-1]) / 1000.0;
//    fprintf(stderr,"# num timesteps: %d,  experiment duration: %.2f min\n",
//            ntimesteps,total_duration/60.0);
//    
//    
//    total_duration += 10.0; /* add 10 seconds to avoid FFT problems (wrap around) */
//    
//    
//    /*
//     ** set gamma function parameters
//     */
//    a1 = delay;
//    a2 = undershoot;
//    cc = understrength;
//    
//    
//    /*
//     ** parse input file, get number of timesteps, TR, number of events
//     */
//    parseInputFile(in_file, buf, LEN, trial, &ntrials, &nevents);
//    
//	//    i = ntrials = nevents = 0;
//	//    while (!feof(in_file)) {
//	//        for (j=0; j<LEN; j++) buf[j] = '\0';
//	//        fgets(buf,LEN,in_file);
//	//        if (strlen(buf) < 2) continue;
//	//        if (buf[0] == '%' || buf[0] == '#') continue;
//	//        if (! test_ascii((int)buf[0])) VError(" input file must be a text file");
//	//        
//	//        
//	//        /* remove non-alphanumeric characters */
//	//        for (j=0; j<strlen(buf); j++) {
//	//            k = (int)buf[j];
//	//            if (!isgraph(k) && buf[j] != '\n' && buf[j] != '\r' && buf[j] != '\0') {
//	//                buf[j] = ' ';
//	//            }
//	//            if (buf[j] == '\v') buf[j] = ' '; /* remove tabs */
//	//            if (buf[j] == '\t') buf[j] = ' ';
//	//        }
//	//        
//	//        if (sscanf(buf,"%d %f %f %f",&id,&onset,&duration,&height) != 4)
//	//            VError(" line %d: illegal input format",i+1);
//	//        
//	//        if (duration < 0.5 && duration >= -0.0001) duration = 0.5;
//	//        trial[i].id       = id-1;
//	//        trial[i].onset    = onset;
//	//        trial[i].duration = duration;
//	//        trial[i].height   = height;
//	//        i++;
//	//        if (i > NTRIALS) VError(" too many trials %d",i);
//	//        
//	//        if (id > nevents) nevents = id;
//	//    }
//	//    fclose(in_file);
//	//    
//	//    ntrials = i;
//    
//    /*
//     ** check amplitude: must have zero mean for parametric designs
//     */
//    if (zeromean) {
//        for (i=0; i<nevents; i++) {
//            sum1 = sum2 = nx = 0;
//            for (j=0; j<ntrials; j++) {
//                if (trial[j].id != i) continue;
//                sum1 += trial[j].height;
//                sum2 += trial[j].height * trial[j].height;
//                nx++;
//            }
//            if (nx < 1) continue;
//            mean  = sum1/nx;
//            if (nx < 1.5) continue;      /* sigma not computable       */
//            sigma =  sqrt((double)((sum2 - nx * mean * mean) / (nx - 1.0)));
//            if (sigma < 0.01) continue;  /* not a parametric covariate */
//            
//            /* correct for zero mean */
//            for (j = 0; j < ntrials; j++) {
//                if (trial[j].id != i) continue;
//                trial[j].height -= mean;
//            }
//        }
//    }
//    if (nevents < 1) {
//        VError(" no events found");
//    }
//    
//    
//    /*
//     ** create output design file in vista-format
//     */
//    
//    
//    /* get number of columns in design matrix, and event type (block) */
//    //event_type = (VBoolean *) VMalloc(sizeof(VBoolean) * nevents);
//    //for (i=0; i<nevents; i++) event_type[i] = FALSE;
//    
//    ncols = 0;
//    for (i = 0; i < nevents; i++) {
//        
//        xmin = VRepnMaxValue(VFloatRepn);
//        for (j = 0; j < ntrials; j++) {
//            if (trial[j].id != i) continue;
//            if (trial[j].duration < xmin) xmin = trial[j].duration; 
//        }
//        block = FALSE;
//        if (xmin >= block_threshold) block = TRUE;
//        //event_type[i] = block;
//        
//        //if (block || deriv == 0) ncols++;
//        if (0 == deriv) {
//            ncols++;
//        } else if (1 == deriv) {
//            ncols += 2;
//        } else if (2 == deriv) {
//            ncols += 3;
//        }
//    }
//    fprintf(stderr,"# number of events: %d,  num columns in design matrix: %d\n",nevents,ncols+1);
//    
//    dest = VCreateImage(1,ntimesteps,ncols+1,VFloatRepn);
//    VSetAttr(VImageAttrList(dest),"modality",NULL,VStringRepn,"X");
//    VSetAttr(VImageAttrList(dest),"name",NULL,VStringRepn,"X");
//    VSetAttr(VImageAttrList (dest),"repetition_time",NULL,VLongRepn,(VLong)(tr*1000.0));
//    VSetAttr(VImageAttrList (dest),"ntimesteps",NULL,VLongRepn,(VLong)ntimesteps);
//    
//    VSetAttr(VImageAttrList (dest),"derivatives",NULL,VShortRepn,deriv);
//    VSetAttr(VImageAttrList (dest),"delay",NULL,VFloatRepn,delay);
//    VSetAttr(VImageAttrList (dest),"undershoot",NULL,VFloatRepn,undershoot);
//    sprintf(buf,"%.3f",understrength);
//    VSetAttr(VImageAttrList (dest),"understrength",NULL,VStringRepn,&buf);
//    
//    VSetAttr(VImageAttrList(dest),"nsessions",NULL,VShortRepn,(VShort)1);
//    VSetAttr(VImageAttrList(dest),"designtype",NULL,VShortRepn,(VShort)1);
//    VFillImage(dest,VAllBands,0);
//    for (j=0; j<ntimesteps; j++) VPixel(dest,0,j,ncols,VFloat) = 1;
//    
//	
//    
//    /* alloc memory */
//    delta = 20.0;   /* temporal resolution for convolution is 20 ms */
//    n = (int)(total_duration * 1000.0 / delta);
//    
//    if (n > 300000) { /* reduce to 30 ms, if too big */
//        delta = 30.0;
//        n = (int)(total_duration * 1000.0 / delta);
//    }
//    nc  = (n / 2) + 1;
//    
//    ibuf  = (double *)fftw_malloc(sizeof(double) * n);
//    ibuf1 = (double *)fftw_malloc(sizeof(double) * n);
//    obuf  =  (fftw_complex *) fftw_malloc (sizeof (fftw_complex ) * nc);
//    nbuf  =  (fftw_complex *) fftw_malloc (sizeof (fftw_complex ) * nc);
//    memset(ibuf,0,sizeof(double) * n);
//    memset(ibuf1,0,sizeof(double) * n);
//    
//    
//    /* make plans */
//    p1    = fftw_plan_dft_r2c_1d (n,ibuf,obuf,FFTW_ESTIMATE);
//    pinv  = fftw_plan_dft_c2r_1d (n,nbuf,ibuf1,FFTW_ESTIMATE);
//    
//    
//    /* 
//     ** get kernel 
//     */
//    block_kernel  = (double *)fftw_malloc(sizeof(double) * n);
//    fkernelg = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
//    memset(block_kernel,0,sizeof(double) * n);
//    
//    kernel0  = (double *)fftw_malloc(sizeof(double) * n);
//    fkernel0 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
//    memset(kernel0,0,sizeof(double) * n);
//    
//    if (deriv >= 1) {
//        kernel1  = (double *)fftw_malloc(sizeof(double) * n);
//        fkernel1 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
//        memset(kernel1,0,sizeof(double) * n);
//    }
//    
//    if (deriv == 2) {
//        kernel2  = (double *)fftw_malloc(sizeof(double) * n);
//        fkernel2 = (fftw_complex *)fftw_malloc (sizeof (fftw_complex) * nc);
//        memset(kernel2,0,sizeof(double) * n);
//    }
//    
//    i = 0;
//    t1 = 30.0;  // HRF duration / Breite der HRF
//    dt = delta/1000.0;
//    
//    for (t=0; t<t1; t+= dt) {
//        if (i >= n) break;
//        
//        /* Gauss kernel for block designs */
//        if (bkernel == 0)
//            block_kernel[i] = bgamma(t,0);
//        else if (bkernel == 1)
//            block_kernel[i] = bgamma(t,0); 
//        
//        kernel0[i] = xgamma(t,0);
//        if (deriv >= 1) kernel1[i] = deriv1_gamma(t,0);
//        if (deriv == 2) kernel2[i] = deriv2_gamma(t,0);
//        i++;
//    }
//    
//    /* fft for kernels */
//    pkg = fftw_plan_dft_r2c_1d (n,block_kernel,fkernelg,FFTW_ESTIMATE);
//    fftw_execute(pkg);
//    
//    pk0 = fftw_plan_dft_r2c_1d (n,kernel0,fkernel0,FFTW_ESTIMATE);
//    fftw_execute(pk0);
//    
//    if (deriv >= 1) {
//        pk1 = fftw_plan_dft_r2c_1d (n,kernel1,fkernel1,FFTW_ESTIMATE);
//        fftw_execute(pk1);
//    }
//    
//    if (deriv == 2) {
//        pk2 = fftw_plan_dft_r2c_1d (n,kernel2,fkernel2,FFTW_ESTIMATE);
//        fftw_execute(pk2);
//    }
//    
//    /* 
//     ** for each trial,event, do... 
//     */
//    m = deriv + 1;
//    col = 0;
//    for (i=0; i<nevents; i++) {
//        memset(ibuf,0,sizeof(double)*n);
//        
//        /* get data */
//        trialcount = 0;
//        float minTrialDuration = block_threshold;
//        
//        for (j=0; j<ntrials; j++) {
//            if (trial[j].id == i) {
//                trialcount++;
//                
//                //block = event_type[i];
//                if (trial[j].duration < minTrialDuration) {
//                    minTrialDuration = trial[j].duration;
//                }
//                t0 = trial[j].onset;
//                t1 = trial[j].onset + trial[j].duration;
//                h  = trial[j].height;
//                
//                t0 *= 1000.0;
//                t1 *= 1000.0;
//                
//                k = t0 / delta;
//                for (t=t0; t<=t1; t+=delta) {
//                    if (k >= n) {
//                        break;
//                    }
//                    ibuf[k++] += h;
//                }
//            }
//        }
//        if (trialcount < 1) 
//            VError(" no trials in event %d, please re-number event-ids", i + 1);
//        if (trialcount < 4) 
//            VWarning(" too few trials (%d) in event %d. Statistics will be unreliable.",
//                     trialcount,i+1);
//        
//        
//        
//        /*  fft */
//        fftw_execute(p1);
//        
//		
//        
//        if (minTrialDuration >= block_threshold) {
//            Convolve(dest,col,pinv,xx,ntimesteps,delta,fkernelg,ibuf1,nbuf,obuf,n);
//        } else {
//            Convolve(dest,col,pinv,xx,ntimesteps,delta,fkernel0,ibuf1,nbuf,obuf,n);
//        }
//        
//        col++;
//        
//        if (deriv >= 1) { //if (deriv >= 1 && !block) {
//            Convolve(dest,col,pinv,xx,ntimesteps,delta,fkernel1,ibuf1,nbuf,obuf,n);
//            col++;
//        }
//        
//        if (deriv == 2) { //if (deriv == 2 && !block) {
//            Convolve(dest,col,pinv,xx,ntimesteps,delta,fkernel2,ibuf1,nbuf,obuf,n);
//            col++;
//        }
//    }
//	
//    /***************************************************************/
//    gettimeofday(&timeEnd, NULL);
//    difference = my_difftime(&timeStart, &timeEnd);
//    printf("Time fftw3_fft: %3d.%6d sec. \n", difference->secs, difference->usecs);
//    /***************************************************************/
//    
//	
//    out_list = VCreateAttrList();
//    VAppendAttr (out_list, "image", NULL, VImageRepn,dest);
//    
//	// plot_image = Plot_gamma(deriv);
//	//    VAppendAttr (out_list, "plot_gamma",NULL,VImageRepn,plot_image);
//    
//    if (! VWriteFile (out_file, out_list)) exit (1);
//    fprintf(stderr," %s: done.\n",argv[0]);
//    return 0;
//}
//
//void parseInputFile(FILE *in_file, char *buffer, int bufferLength, Trial *trial, int *numberTrials, int *numberEvents) {
//	
//    int character;
//    int id = 0;
//    float onset = 0.0;
//    float duration = 0.0;
//    float height = 0.0;
//    
//    *numberTrials = 0;
//    *numberEvents = 0;
//    printf("nT: %d\n", *numberTrials);
//    
//    while (!feof(in_file)) {
//        for (int j = 0; j < bufferLength; j++) {
//            buffer[j] = '\0';
//        }
//        fgets(buffer, bufferLength, in_file);
//        if (strlen(buffer) >= 2) {
//            if (!test_ascii((int) buffer[0])) {
//                VError(" input file must be a text file");
//            }
//			
//            if (buffer[0] != '%' && buffer[0] != '#') {
//                /* remove non-alphanumeric characters */
//                for (int j = 0; j < strlen(buffer); j++) {
//                    character = (int) buffer[j];
//                    if (!isgraph(character) && buffer[j] != '\n' && buffer[j] != '\r' && buffer[j] != '\0') {
//                        buffer[j] = ' ';
//                    }
//                    
//                    /* remove tabs */
//                    if (buffer[j] == '\v') {
//                        buffer[j] = ' ';
//                    }
//                    if (buffer[j] == '\t') {
//                        buffer[j] = ' ';
//                    }
//                }
//                
//                if (sscanf(buffer, "%d %f %f %f", &id, &onset, &duration, &height) != 4) {
//                    VError(" line %d: illegal input format", ntrials + 1);
//                }
//                
//                if (duration < 0.5 && duration >= -0.0001) {
//                    duration = 0.5;
//                }
//                trial[*numberTrials].id       = id - 1;
//                trial[*numberTrials].onset    = onset;
//                trial[*numberTrials].duration = duration;
//                trial[*numberTrials].height   = height;
//                (*numberTrials)++;
//                
//                if (*numberTrials > NTRIALS) {
//                    VError(" too many trials %d", *numberTrials);
//                }
//                
//                if (id > *numberEvents) {
//                    *numberEvents = id;
//                }
//            }
//        }
//    }
//    fclose(in_file);
//}
