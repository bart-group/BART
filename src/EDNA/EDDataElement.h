//
//  EDDataElement.h
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifdef __cplusplus
#include <itkImage.h>

typedef float ITKImagePixelType;
const unsigned int ITKIMAGE_DIMENSION = 3;
typedef itk::Image<ITKImagePixelType, ITKIMAGE_DIMENSION> ITKImage;
#endif

enum ImageType {
    IMAGE_FCTDATA,
    IMAGE_BETAS,
	IMAGE_ANADATA,
	IMAGE_TMAP,
	IMAGE_ZMAP,
	IMAGE_MOCO,
	IMAGE_UNKNOWN
};

enum ImageDataType {
    IMAGE_DATA_FLOAT,
    IMAGE_DATA_INT16,
	IMAGE_DATA_UINT16,
	IMAGE_DATA_UINT8,
	IMAGE_DATA_INT8,
	IMAGE_DATA_DOUBLE,
	IMAGE_DATA_INT32,
	IMAGE_DATA_UINT32,
	IMAGE_DATA_UNKNOWN
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

@interface BARTImageSize : NSObject <NSCopying> {
	size_t rows;
	size_t columns;
	size_t slices;
	size_t timesteps;
	
}

@property size_t rows;
@property size_t columns;
@property size_t slices;
@property size_t timesteps;

-(id)initWithRows:(size_t)r andCols:(size_t)c andSlices:(size_t)s andTimesteps:(size_t)t;

@end



@interface EDDataElement : NSObject <NSCopying> {
	
	BARTImageSize *mImageSize;
    uint mDataTypeID;
    size_t mRepetitionTimeInMs;
	NSDictionary *mImagePropertiesMap;
    
    enum ImageDataType mImageDataType;
	enum ImageType mImageType;
	NSString *justatest;
    
}
@property (retain) BARTImageSize *mImageSize;
@property (retain) NSString *justatest;
@property (readonly, assign) enum ImageType mImageType;



-(id)initWithDataFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType;

-(id)initEmptyWithSize:(BARTImageSize*) imageSize ofImageType:(enum ImageType)iType;

-(id)initForRealTimeTCPIPWithSize:(BARTImageSize*)s ofImageType:(enum ImageType)iType;

-(void)dealloc;

// DEPRECATED == VI stuff
-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps;

-(BARTImageSize*)getImageSize;

@end


#pragma mark -

@interface EDDataElement (AbstractMethods)


-(id)initWithFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType;

-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)s timestep:(unsigned int)t;

//-(EDDataElement*)CreateNewDataElement: withSize:(NSSize*)size andType:(NSString*)type; 

-(BOOL)WriteDataElementToFile:(NSString*)path;

-(BOOL)WriteDataElementToFile:(NSString*)path withOverwritingSuffix:(NSString*)suffix andDialect:(NSString*)dialect;

-(BOOL)sliceIsZero:(int)slice;

-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value;

-(id)getImageProperty:(enum ImagePropertyID)key;

-(enum ImageDataType)getImageDataType;

/*
 *
 * Attention: when running through the result buffer, col is the fastest running index, i.e. get the data row by row
 */

-(float*)getSliceData:(uint)sliceNr atTimestep:(uint)tstep;

-(float*)getRowDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep;

-(void)setRowAt:(uint)row atSlice:(uint)sl	atTimestep:(uint)tstep withData:(float*)data;

-(float*)getColDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep;

-(void)setColAt:(uint)col atSlice:(uint)sl atTimestep:(uint)tstep withData:(float*)data;

-(float*)getTimeseriesDataAtRow:(uint)row atCol:(uint)col atSlice:(uint)sl fromTimestep:(uint)tstart toTimestep:(uint)tend;

-(void)print;

-(void)copyProps:(NSArray*)propList fromDataElement:(EDDataElement*)srcElement;

-(NSDictionary*)getProps:(NSArray*)propList;

-(void)setProps:(NSDictionary*)propDict;

-(BOOL)isEmpty;

-(BOOL)isValid;

-(NSArray*)getMinMaxOfDataElement;

#ifdef __cplusplus

/**
 * Converts the whole DataElement to an ITKImage.
 *
 * \return The DataElement as an ITKImage.
 */
-(ITKImage::Pointer)asITKImage;

/**
 * Converts a single timestep of the DataElement to an ITKImage.
 *
 * \param timestep The timestep of the volume to convert.
 * \return         The ITKImage of the volume at timestep.
 */
-(ITKImage::Pointer)asITKImage:(unsigned int)timestep;

#endif

@end