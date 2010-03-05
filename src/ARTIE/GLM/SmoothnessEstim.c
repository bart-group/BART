/*
** smoothness estimation based on
**    Forman et al (1995), MRM, 33:636-647
**
** G.Lohmann, Aug. 2007
*/

#include <viaio/Vlib.h>
#include <viaio/VImage.h>
#include <viaio/mu.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>



#define SQR(x) ((x)*(x))
#define ABS(x) ((x) > 0 ? (x) : -(x))

extern int isnanf(float);
extern float cbrtf(float);



float
VSmoothnessEstim(VImage *resmap,int ntimesteps)
{
  int   j,b,r,c,nbands,nrows,ncols,wn;
  float tiny=1.0e-20;
  float u,ux,uy,uz,v,vx,vy,vz;
  float sumu,sumx,sumy,sumz,nx;
  float sx,sy,sz;
  float f=0;
  float mx,tsumu,tsumx,tsumy,tsumz;

  nbands = VImageNBands(resmap[0]);
  nrows  = VImageNRows(resmap[0]);
  ncols  = VImageNColumns(resmap[0]);


  /*
  ** get variances
  */
  mx = (float) ntimesteps;
  sumu = sumx = sumy = sumz = nx = 0;

  wn = 1;
  for (b=wn; b<nbands-wn; b++) {
    for (r=wn; r<nrows-wn; r++) {
      for (c=wn; c<ncols-wn; c++) {

	tsumu = tsumx = tsumy = tsumz = 0;
	for (j=0; j<ntimesteps; j++) {
          u  = VPixel(resmap[j],b,r,c,VFloat);
          ux = VPixel(resmap[j],b,r,c+1,VFloat);
          uy = VPixel(resmap[j],b,r+1,c,VFloat);
	  uz = VPixel(resmap[j],b+1,r,c,VFloat);

	  tsumu += u*u;
	  tsumx += (ux-u)*(ux-u);
	  tsumy += (ux-u)*(ux-u);
	  tsumz += (uz-u)*(uz-u);
	}
        if (ABS(tsumu) < tiny) continue;
        if (ABS(tsumx) < tiny) continue;
        if (ABS(tsumy) < tiny) continue;
        if (ABS(tsumz) < tiny) continue;

	sumu += tsumu/mx;
	sumx += tsumx/mx;
	sumy += tsumy/mx;
	sumz += tsumz/mx;

	nx++;
      }
    }
  }
  if (nx < 2) {
    VWarning(" smoothness estimation failed: no voxels found");
    return 0;
  }

  v  = sumu / nx;
  vx = sumx / nx;
  vy = sumy / nx;
  vz = sumz / nx;

  f = -2.0*log(2.0);
  sx = sqrt(f / log(1.0 - vx/(2.0*v)));
  sy = sqrt(f / log(1.0 - vy/(2.0*v)));
  sz = sqrt(f / log(1.0 - vz/(2.0*v)));

  u = (sx + sy + sz)/3.0f;
  return u;
}
