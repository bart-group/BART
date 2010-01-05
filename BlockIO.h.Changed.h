/*
 * =====================================================================================
 * 
 *       Filename:  BlockIO.h
 * 
 *    Description:  NULL
 * 
 *        Version:  1.0
 *        Created:  09/19/07 15:24:35 CEST
 *       Revision:  none
 *       Compiler:  gcc
 * 
 *         Author: Thomas Proeger 
 *        Company:  
 * 
 * =====================================================================================
 */

#ifndef  BLOCKIO_INC
#define  BLOCKIO_INC

#define NSLICES 256   /* max number of image slices */
#define MBETA    64   /* max number of covariates */
#define NCON     64   /* max number of contrasts */
#include <viaio/headerinfo.h>

typedef struct ListStruct {  
    int ntimesteps;
    int nrows;
    int ncols;
    int nslices;
    int itr;
    VRepnKind repn;
    int zero[NSLICES];
    VString filename;
    VString voxel;
    VImageInfo info[NSLICES];
} ListInfo;


VAttrList
GetListInfo(VString in_filename,ListInfo *linfo);

#endif   /* ----- #ifndef BLOCKIO_INC  ----- */

