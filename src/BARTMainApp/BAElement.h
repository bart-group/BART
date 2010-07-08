//
//  BAElement.h
//  BARTCommandLine
//
//  Created by First Last on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum ImageType {
    IMAGE_DESIGN,
    IMAGE_FCTDATA,
    IMAGE_BETAS
};

enum ImageDataType {
    IMAGE_DATA_FLOAT,
    IMAGE_DATA_SHORT
};

enum ImagePropertyID{
    PROPID_NAME,
    PROPID_MODALITY,
    PROPID_DF,
    PROPID_PATIENT,
    PROPID_VOXEL,
    PROPID_REPTIME,
    PROPID_TALAIRACH,
    PROPID_FIXPOINT,
    PROPID_CA,
    PROPID_CP,
    PROPID_EXTENT,
    PROPID_BETA,
	PROPID_READVEC,
	PROPID_PHASEVEC,
	PROPID_SLICEVEC,
	PROPID_SEQNR,
	PROPID_VOXELSIZE, 
	PROPID_ORIGIN
};



@interface BAElement : NSObject <NSCopying> {

}

@end
