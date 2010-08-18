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
    
   // fuer Datenelemente ist Vorgabe der Typen okay - Vimage, isis::image - 


    unsigned int numberRows;
    unsigned int numberCols;
    unsigned int numberSlices;
    unsigned int numberTimesteps;
    //enum ImageType imageType;
    enum ImageDataType imageDataType;
    
    unsigned int repetitionTimeInMs;
   // NSArray *allDatasetProperties;
    NSDictionary *imagePropertiesMap;
    
    
    
}

@property (readonly, assign) unsigned int numberRows; 
@property (readonly, assign) unsigned int numberCols; 
@property (readonly, assign) unsigned int numberSlices; 
@property (readonly, assign) unsigned int numberTimesteps;
@property (readonly, assign) enum ImageDataType imageDataType;



-(id)initWith:(NSArray*) aType;

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps;


-(void)dealloc;



@end


#pragma mark -

@interface BADataElement (AbstractMethods)

-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t;

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)s timestep:(unsigned int)t;

//-(BADataElement*)CreateNewDataElement: withSize:(NSSize*)size andType:(NSString*)type; 

-(void)WriteDataElementToFile:(NSString*)path;

-(BOOL)sliceIsZero:(int)slice;

-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value;

-(id)getImageProperty:(enum ImagePropertyID)key;

-(float*)getDataFromSlice:(int)sliceNr atTimestep:(uint)tstep;

-(float*)getRowDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep;

-(void)setRowAt:(uint)row atSlice:(uint)sl	atTimestep:(uint)tstep withData:(float*)data;

-(float*)getColDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep;

-(void)setColAt:(uint)col atSlice:(uint)sl atTimestep:(uint)tstep withData:(float*)data;

-(float*)getTimeseriesDataAtRow:(uint)row atCol:(uint)col atSlice:(uint)sl fromTimestep:(uint)tstart toTimestep:(uint)tend;

-(void)print;





@end