
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

#include <viaio/Vlib.h>
#include <viaio/mu.h>
#include <viaio/option.h>
#include <viaio/VImage.h>
#include <viaio/headerinfo.h>

#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */
#define NCON     64   /* max number of contrasts */


typedef struct ListStruct {  
    int ntimesteps;
    int nrows;
    int ncols;
    int nslices;
    int itr;
    VRepnKind repn;
    int zero[NSLICES];
    VString filename;
    VImageInfo info[NSLICES];
} ListInfo;

VAttrList
GetListInfo(VString in_filename,ListInfo *linfo);