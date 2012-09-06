//
//  BAAnalyzerGLMReference.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/31/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "ARAnalyzerGLMReference.h"


/***********************************************
 C Part
 ************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#import "gsl/gsl_cblas.h"
#import "gsl/gsl_matrix.h"
#import "gsl/gsl_vector.h"
#import "gsl/gsl_blas.h"
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_sort_vector.h>

#define dvset gsl_vector_set 
#define dvget gsl_vector_get 
#define dmset gsl_matrix_set 
#define dmget gsl_matrix_get

#define fvset gsl_vector_float_set 
#define fvget gsl_vector_float_get 
#define fmset gsl_matrix_float_set 
#define fmget gsl_matrix_float_get

/* Gaussian function */
double gauss(double x,double sigma)
{
	double y,z,a=2.506628273;
	z = x / sigma;
	y = exp((double)-z*z*0.5)/(sigma * a);
	return y;
}

/* create a Gaussian kernel for convolution */
gsl_vector *
GaussKernel(double sigma)
{
	int i,dim,n;
	double x,u,step;
	gsl_vector *kernel;
	
	/* no temporal smoothing */
	if (sigma < 0.001) return NULL;
	
	dim  = 4.0 * sigma + 1;
	n    = 2*dim+1;
	step = 1;
	
	kernel = gsl_vector_alloc(n);
	
	x = -(float)dim;
	for (i=0; i<n; i++) {
		u = gauss(x,sigma);
		dvset(kernel,i,u);
		x += step;
	}
	return kernel;
}



/* create a Gaussian convolution matrix */
void
GaussMatrix(double sigma,gsl_matrix_float *S)
{
	int i,j,k,m,dim;
	float x,sum;
	gsl_vector *kernel;
	
	/* no pre-coloring */
	if (sigma < 0.001) {
		gsl_matrix_float_set_identity(S);
		return;
	}
	
	
	m = S->size1;
	kernel = GaussKernel(sigma);
	dim = kernel->size/2;
	
	gsl_matrix_float_set_zero(S);
	for (i=0; i<m; i++) {
		sum = 0;
		for (j=0; j<m; j++) {
			k = i-j+dim;
			if (k < 0 || k >= kernel->size) continue;
			x = dvget(kernel,k);
			sum += x;
			fmset(S,i,j,x);
		}
		/* normalize */
		for (j=0; j<m; j++) {
			x = fmget(S,i,j);
			fmset(S,i,j,x/sum);
		}
	}
}


gsl_vector_float *
VectorConvolve(gsl_vector_float *src,gsl_vector_float *dst,gsl_vector *kernel)
{
	int i,j,len,n,dim;
	double sum;
	float *ptr0,*ptr1;
	double *ptr2;
	
	
	if (dst == NULL)
		dst = gsl_vector_float_alloc(src->size);
	
	if (kernel == NULL) {   /* return copy of src vector, if src == 0 */
		gsl_vector_float_memcpy(dst,src);
		return dst;
	}
	
	
	dim = kernel->size/2;
	len = src->size;
	n   = len - dim;
	
	ptr0 = gsl_vector_float_ptr(dst,dim);
	
	for (i=dim; i<n; i++) {
		sum = 0;
		ptr1 = gsl_vector_float_ptr(src,i-dim);
		ptr2 = kernel->data;
		for (j=i-dim; j<=i+dim; j++) {
			sum += (*ptr1++) * (*ptr2++);
		}
		*ptr0++ = sum;
	}
	
	/* Randbehandlung */
	ptr0 = src->data;
	ptr1 = dst->data;
	for (i=0; i<dim; i++) {
		*ptr1++ = *ptr0++;
	}
	
	ptr0 = gsl_vector_float_ptr(src,n);
	ptr1 = gsl_vector_float_ptr(dst,n);
	for (i=n; i<len; i++) {
		*ptr1++ = *ptr0++;
	}
	
	return dst;
}


/*
 ** y = Ax
 */
gsl_vector_float *
fmat_x_vector(gsl_matrix_float *A, gsl_vector_float *x, gsl_vector_float *y)
{
	if (y == NULL) {
		y = gsl_vector_float_alloc (A->size1);
	}
	
	gsl_blas_sgemv(CblasNoTrans, 1.0, A, x, 0.0, y);
	
	return y;
}


/*
 **    C = A x B^T
 */
gsl_matrix_float *
fmat_x_matT(gsl_matrix_float *A,gsl_matrix_float *B,gsl_matrix_float *C)
{
	if (C == NULL) {
		C = gsl_matrix_float_alloc( A->size1, B->size1 );
	}
	
	gsl_blas_sgemm( CblasNoTrans, CblasTrans, 1.0, A, B, 0.0, C );
	
	return C;
}

/*
 **    C = A x B
 */
gsl_matrix_float *
fmat_x_mat(gsl_matrix_float *A,gsl_matrix_float *B,gsl_matrix_float *C)
{
	if (C == NULL) {
		C = gsl_matrix_float_alloc( A->size1, B->size2 );
	}
	
	gsl_blas_sgemm( CblasNoTrans, CblasNoTrans, 1.0, A, B, 0.0, C );
	
	return C;
}


/*
 **  z = x^T y
 */
float
fskalarproduct(gsl_vector_float *x,gsl_vector_float *y)
{
	size_t i,n;
	float *ptr1,*ptr2,sum;
	
	n = x->size;
	if (y->size != n) {
		exit(0);
	}
	
	ptr1 = x->data;
	ptr2 = y->data;
	sum = 0;
	for (i=0; i<n; i++) {
		sum += (*ptr1) * (*ptr2);
		ptr1++;
		ptr2++;
	}
	return sum;
}


/*
 **    B = A^-1 = A^+
 */
gsl_matrix_float *
fmat_PseudoInv(gsl_matrix_float *A,gsl_matrix_float *B)
{
	int i,j,k,l,n,m;
	double u,x;
	double *dbl_pp;
	float *flt_pp;
	static gsl_matrix *U=NULL,*V=NULL,*X=NULL;
	static gsl_vector *w=NULL, *work=NULL;
	
	m = A->size1;
	n = A->size2;
	
	if (B == NULL) {
		B = gsl_matrix_float_alloc (n,m);
	}
	else if (B->size1 != n || B->size2 != m) {
		gsl_matrix_float_free(B);
		B = gsl_matrix_float_alloc (n, m);
	}
	
	if (U == NULL) {
		U = gsl_matrix_alloc (m, n);
		V = gsl_matrix_alloc (n, n);
		X = gsl_matrix_alloc (n, n);
		w = gsl_vector_alloc (n);
		work = gsl_vector_alloc (n);
	}
	else if (U->size1 != m || w->size != n) {
		gsl_matrix_free(U);
		gsl_matrix_free(V);
		gsl_matrix_free(X);
		gsl_vector_free(w);
		gsl_vector_free(work);
		U = gsl_matrix_alloc (m, n);
		V = gsl_matrix_alloc (n, n);
		X = gsl_matrix_alloc (n, n);
		w = gsl_vector_alloc (n);
		work = gsl_vector_alloc (n);
	}
	
	/* singular value decomposition */
	flt_pp = A->data;
	dbl_pp = U->data;
	for (i=0; i<A->size1 * A->size2; i++) 
		*dbl_pp++ = *flt_pp++;
	
	/* gsl_linalg_SV_decomp_jacobi(U,V,w); */
	gsl_linalg_SV_decomp_mod (U,X,V,w,work);
	
	/* exception from Gaby */
	int j0 = 0;
	double xmin, xmax, tiny=10.0e-6;
	xmax = gsl_vector_get(w,0);
	xmin = tiny;
	for (j=n-1; j >= 0; j--) {
		u = gsl_vector_get(w,j);
		if (u > 0 && u/xmax > tiny) {
			j0 = j;
			goto skip;
		}
	}
skip: ;
	if (j0 < n-1) {
		xmin = gsl_vector_get(w,j0) - tiny;
		if (xmin < 0) xmin = 0;
	}
	
	/* Fill the result */
	gsl_matrix_float_set_zero(B);
	for (k=0; k<n; k++) {
		for (l=0; l<m; l++) {
			x = fmget(B,k,l);
			for (j=0; j<n; j++) {
				u = dvget(w,j);
				if (ABS(u) > xmin) {
					x += dmget(V,k,j)*dmget(U,l,j)/u;
				}
				else {
					/* because of the sorting of the  sv-vector u, 
					 * we can skip here */ 
					break;
				}
			}
			fmset(B,k,l,x);
		}
	}
	return B;
}




/***********************************************
 BAAnalyzerGLMReference
 ************************************************/

@interface ARAnalyzerGLMReference (PrivateMethods)

-(void)Regression:(short)minval
                 :(int)sliding_window_size
                 :(int)last_timestep;

-(float_t)CalcSigma:(float_t)fwhm;

-(void)createOutputImages;

@end


@implementation ARAnalyzerGLMReference


@synthesize mSlidingWindowAnalysis;
@synthesize mFwhm;
@synthesize mMinval;
@synthesize mSlidingWindowSize;


-(id)initWithFwhm:(uint) fwhm andMinval:(uint)minval forSlidingAnalysis:(BOOL)swa withSize:(uint)sws
{
    if (self = [super init]) {
        mSlidingWindowSize = sws;
        mSlidingWindowAnalysis = swa;
		mFwhm = fwhm;
		mMinval = minval;
    }
    return self;
}

-(EDDataElement*)anaylzeTheData:(EDDataElement*)data 
                     withDesign:(NEDesignElement*)design
             andCurrentTimestep:(size_t)timestep
{
    mDesign = design;
    mData = data;
    /*
     * create output images
     */
    [self createOutputImages];
    
    int index = 0;
    if (mSlidingWindowAnalysis){
        index = mSlidingWindowSize;
    } else {
        index = timestep;
    }
    
    [self Regression:mMinval 
                    :index // sw: mSlidingWindowSize akk: indexForTimestep
                    :timestep];
	
	[mBetaOutput release];
	[mResOutput release];
	[mBCOVOutput release];
	[mDesign release];
    return [mResMap autorelease];
	
}

-(void)dealloc
{
    [mBetaOutput release];
    [mResOutput release];
    [mBCOVOutput release];
	[mDesign release];;
    [super dealloc];
}

-(void)Regression:(short)minval
                 :(int)sliding_window_size
                 :(int)lastTimestep {
    
    if (sliding_window_size <= lastTimestep) { 
        
        BARTImageSize *imSize = [[mData getImageSize] copy];
		//unsigned int numberBands = imSize.timesteps;
        unsigned int numberSlices = imSize.slices;
        unsigned int numberRows = imSize.rows;
        unsigned int numberCols = imSize.columns;
        unsigned int numberExplanatoryVariables = mDesign.mNumberExplanatoryVariables;
        [imSize release];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); /* Global asyn. dispatch queue. */
        
        gsl_set_error_handler_off();
        
        /* Read design matrix. */
        gsl_matrix_float *X = NULL; /* mDesign matrix. */
        X = gsl_matrix_float_alloc(sliding_window_size, numberExplanatoryVariables);
        double x; /* One entry of matrix X. */
        for (int timestep = (lastTimestep - sliding_window_size); timestep < lastTimestep; timestep++) {
            for (unsigned int covariate = 0; covariate < numberExplanatoryVariables; covariate++) {
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
        //float fwhm = 4.0;
        float_t sigma = [self CalcSigma:mFwhm];
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
        for (size_t row = 0; row < numberExplanatoryVariables; row++) {
            for (size_t col = 0; col < numberExplanatoryVariables; col++) {
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
        for (size_t row = 0; row < numberExplanatoryVariables; row++) {
            for (size_t col = 0; col < numberExplanatoryVariables; col++) {
                *fPointer++ = [mBCOVOutput getFloatVoxelValueAtRow:row col:col slice:0 timestep:0];
            }
        }
        gsl_matrix_float_transpose(betaCovariates);
        
		float contrast[mDesign.mNumberExplanatoryVariables];
		//TODO
		//for (int i = 0; i < mDesign.numberExplanatoryVariables; i++){
		contrast[0] = 1.0;
		contrast[1] = 0.0;
		contrast[2] = 0.0;
        //float contrast[3] = {1.0, -1.0, 0.0};
        gsl_vector_float *contrastVector;
        contrastVector = gsl_vector_float_alloc(mDesign.mNumberExplanatoryVariables);
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
        for (size_t slice = 0; slice < numberSlices; slice++) {
            
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
                            size_t i;
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
                                [mResOutput setVoxelValue:val atRow:row col:col slice:slice timestep:0];
                                
                                /* Write beta output. */
                                ptr1 = beta->data;
                                for (i = 0; i < numberExplanatoryVariables; i++) {
                                    val = [NSNumber numberWithFloat:(*ptr1)];
                                    [mBetaOutput setVoxelValue: val atRow:row col:col slice:slice timestep:i];
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
                                    *ptr1++ = [mBetaOutput getFloatVoxelValueAtRow:row col:col slice:slice timestep:i];
                                }
                                sum = fskalarproduct(beta, contrastVector);
                                if (fabs(sum) >= 1.0e-10) {
                                    s = [mResOutput getFloatVoxelValueAtRow:row col:col slice:slice timestep:0];
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
                                    [mResMap setVoxelValue:val atRow:row col:col slice:slice timestep:0];
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
        
        }
    }
//}


-(float_t)CalcSigma:(float_t)fwhm
{
    float sigma = 0.0;
    float repetitionTime = (float) mDesign.mRepetitionTimeInMs/1000;
    
	if (repetitionTime > 0.001 && fwhm > 0.001) {
		sigma = fwhm / 2.35482;
		sigma /= repetitionTime;
		if (sigma < 0.1) {
			sigma = 0.0;
		}
	}
    return sigma;
}


- (void)createOutputImages
{
	BARTImageSize *s = [[mData mImageSize] copy];
	s.timesteps = mDesign.mNumberExplanatoryVariables;
	mBetaOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_BETAS];
	s.timesteps = 1;
    mResOutput = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
	mResMap = [[EDDataElement alloc] initEmptyWithSize:s ofImageType:IMAGE_TMAP];
	mBCOVOutput = [[EDDataElement alloc] initEmptyWithSize:[[BARTImageSize alloc] initWithRows:mDesign.mNumberExplanatoryVariables andCols:mDesign.mNumberExplanatoryVariables andSlices:1 andTimesteps:1] ofImageType:IMAGE_UNKNOWN];
	[s release];	   
	
}




@end
