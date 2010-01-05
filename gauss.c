
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <gsl/gsl_cblas.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include "gsl_utils.h"




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
int
main(int argc, char *argv[])
{
  double sigma;
  gsl_vector *kernel;
  double fwhm = 4.0;
  double tr = 0.625;

  sigma = fwhm/sqrt(8*log(2)) / tr;
  kernel = GaussKernel(sigma);
  exit(0);
}
*/
