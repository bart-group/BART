/*
 *  NEDesignGloverKernelReference.c
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 4/23/10.
 *  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */

#include "NEDesignGloverKernelReference.h"
#include <math.h>

/*
 ** Glover kernel, gamma function, parameters changed for block designs
 */

/* standard parameter values for gamma function,Glover 99 */
double a1 = 6.0;     
double b1 = 0.9;
double a2 = 12.0;
double b2 = 0.9;
double cc = 0.35;

 
double 
bgamma(double xx,double t0)
{
    double x,y,scale=120;
    double y1,y2;
    double d1,d2;
    
    double aa1 = 6;     
    double bb1 = 0.9;
    double aa2 = 12;
    double bb2 = 0.9;
    double cx  = 0.1;
    
    x = xx - t0;
    if (x < 0 || x > 50) return 0;
    
    d1=aa1*bb1;
    d2=aa2*bb2;
    
    y1 = pow(x/d1,aa1) * exp(-(x-d1)/bb1);
    y2 = pow(x/d2,aa2) * exp(-(x-d2)/bb2);
    
    y = y1 - cx*y2;
    y /= scale;
    return y;
}

double
xgamma(double xx,double t0)
{
    double x,y,scale=20;
    double y1,y2;
    double d1,d2;
    
    x = xx - t0;
    if (x < 0 || x > 50) return 0;
    
    d1=a1*b1;
    d2=a2*b2;
    
    y1 = pow(x/d1,a1) * exp(-(x-d1)/b1);
    y2 = pow(x/d2,a2) * exp(-(x-d2)/b2);
    
    y = y1 - cc*y2;
    y /= scale;
    return y;
}


/* first derivative */
double
deriv1_gamma(double x,double t0)
{
    double d1,d2,y1,y2,y,xx;
    double scale=20.0;
    
    xx = x - t0;
    if (xx < 0 || xx > 50) return 0;
    
    d1=a1*b1;
    d2=a2*b2;
    
    y1 = pow(d1,-a1)*a1*pow(xx,(a1-1.0)) * exp(-(xx-d1)/b1) 
    - (pow((xx/d1),a1) * exp(-(xx-d1)/b1)) / b1;
    
    y2 = pow(d2,-a2)*a2*pow(xx,(a2-1.0)) * exp(-(xx-d2)/b2) 
    - (pow((xx/d2),a2) * exp(-(xx-d2)/b2)) / b2;
    
    y = y1 - cc*y2;
    y /= scale;
    return y;
}


/* second derivative */
double
deriv2_gamma(double x,double t0)
{
    double d1,d2,y1,y2,y3,y4,y,xx;
    double scale=20.0;
    
    xx = x - t0;
    if (xx < 0 || xx > 50) return 0;
    
    d1=a1*b1;
    d2=a2*b2;
    
    y1 = pow(d1,-a1)*a1*(a1-1)*pow(xx,a1-2) * exp(-(xx-d1)/b1) 
    - pow(d1,-a1)*a1*pow(xx,(a1-1)) * exp(-(xx-d1)/b1)/b1;
    y2 = pow(d1,-a1)*a1*pow(xx,a1-1) * exp(-(xx-d1)/b1) / b1
    - pow((xx/d1),a1) * exp(-(xx-d1)/b1) / (b1*b1);
    y1 = y1 - y2;
    
    
    y3 = pow(d2,-a2)*a2*(a2-1)*pow(xx,a2-2) * exp(-(xx-d2)/b2) 
    - pow(d2,-a2)*a2*pow(xx,(a2-1)) * exp(-(xx-d2)/b2)/b2;
    y4 = pow(d2,-a2)*a2*pow(xx,a2-1) * exp(-(xx-d2)/b2) / b2
    - pow((xx/d2),a2) * exp(-(xx-d2)/b2) / (b2*b2);
    y2 = y3 - y4;
    
    y = y1 - cc*y2;
    y /= scale;
    return y;
}
