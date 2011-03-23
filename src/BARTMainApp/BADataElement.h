//
//  BADataElement.h
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAElement.h"


@interface BADataElement : BAElement {
	
	ImageSize imageSize;
    uint dataTypeID;
    unsigned int repetitionTimeInMs;
	NSDictionary *imagePropertiesMap;
    
    enum ImageDataType imageDataType;
	enum ImageType imageType;
    
}
@property (readonly, assign) ImageSize imageSize;
//@property (readonly, assign) uint dataTypeID;
@property (readonly, assign) enum ImageType imageType;



-(id)initWithDataFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType;

-(id)initEmptyWithSize:(ImageSize*) imageSize ofImageType:(enum ImageType)iType;

-(void)dealloc;

// DEPRECATED == VI stuff
-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps;



@end


#pragma mark -

@interface BADataElement (AbstractMethods)

-(id)initWithFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType;

-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)s timestep:(unsigned int)t;

//-(BADataElement*)CreateNewDataElement: withSize:(NSSize*)size andType:(NSString*)type; 

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

-(void)copyProps:(NSArray*)propList fromDataElement:(BADataElement*)srcElement;

-(NSDictionary*)getProps:(NSArray*)propList;

-(void)setProps:(NSDictionary*)propDict;


@end