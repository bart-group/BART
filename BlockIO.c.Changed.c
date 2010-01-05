
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


#include "BlockIO.h"


extern void VImageInfoIni(VImageInfo *);
extern VBoolean ReadHeader(FILE*);
extern VBoolean VGetImageInfo(FILE *,VAttrList,int,VImageInfo *);
extern VAttrList ReadAttrList (FILE *);


VAttrList
GetListInfo(VString in_filename,ListInfo *linfo)
{
    VAttrList list=NULL;
    VAttrListPosn posn;
    FILE *in_file=NULL;
    VString str, voxel=NULL;
    VRepnKind repn=VShortRepn;
    int ntimesteps,nrows,ncols;
    int id,j,itr,found,nobject,nbands;
    VImageInfo *imageInfo=NULL;
    
    
    in_file = VOpenInputFile (in_filename, TRUE);
    if (!in_file) VError("error opening file %s",in_filename);
    if (! ReadHeader (in_file)) VError("error reading header");
    if (! (list = ReadAttrList (in_file))) VError("error reading attr list");
    
    
    j = 0;
    for (VFirstAttr (list, & posn); VAttrExists (& posn); VNextAttr (& posn)) {
        j++;
    }
    imageInfo = (VImageInfo *) VMalloc(sizeof(VImageInfo) * (j+1));
    
    
    itr = ntimesteps = nrows = ncols = 0;
    nobject = nbands = found = id = 0;
    for (VFirstAttr (list, & posn); VAttrExists (& posn); VNextAttr (& posn)) {
        
        str = VGetAttrName(&posn);
        if (strncmp(str,"history", 7) == 0) {
            nobject++;
            continue;
        }
        
        VImageInfoIni(&imageInfo[nbands]);
        if (! VGetImageInfo(in_file,list,nobject,&imageInfo[nbands]))
            VError(" error reading image info");
        
        linfo->ntimesteps = linfo->nrows = linfo->ncols = 0;
        
        if (imageInfo[nbands].repn == VShortRepn) {
            
            found = 1;
            repn = imageInfo[nbands].repn;
            
            if (imageInfo[nbands].nbands > ntimesteps)
                ntimesteps = imageInfo[nbands].nbands;
            
            if (imageInfo[nbands].nrows > nrows)
                nrows = imageInfo[nbands].nrows;
            
            if (imageInfo[nbands].ncolumns > ncols)
                ncols = imageInfo[nbands].ncolumns;
            
            if (voxel == NULL)
                voxel = imageInfo[nbands].voxel;
            
            /* check if slice contains non-zero data */
            linfo->zero[nbands] = 1;
            if (imageInfo[nbands].nrows < 2) linfo->zero[nbands] = 0;
            
            linfo->info[id] = imageInfo[nbands];
            
            itr = imageInfo[nbands].repetition_time;
            
            id++;
            nbands++;
        }
        nobject++;
    }
    fclose(in_file);
    if(!found) VError(" couldn't find functional data");
    
    linfo->ntimesteps = ntimesteps;
    linfo->nrows    = nrows;
    linfo->ncols    = ncols;
    linfo->nslices  = id;
    linfo->itr      = itr;
    linfo->repn     = repn;
    linfo->voxel    = voxel;
    linfo->filename = VNewString(in_filename);
    return list;
}
