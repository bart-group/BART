//
//  EDDataElementIsisRealTime.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/30/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EDDataElementIsisRealTime.h"
#import "DataStorage/io_factory.hpp"




@implementation EDDataElementIsisRealTime



-(id)initWithFile:(NSString*)path andSuffix:(NSString*)suffix andDialect:(NSString*)dialect ofImageType:(enum ImageType)iType
{
	// set  isis loglevels
	isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	isis::util::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	
	self = [super init];
	mImagePropertiesMap = nil;
	//set the type of the image
	mImageType = iType;
		
	// the most important thing - load with isis factory
	std::list<isis::data::Image> images = isis::data::IOFactory::load( [path cStringUsingEncoding:NSUTF8StringEncoding], [suffix cStringUsingEncoding:NSUTF8StringEncoding], [dialect cStringUsingEncoding:NSUTF8StringEncoding]);
	
	// that's unusual - take the first one, warn the user
    if (1 < images.size()) {
        NSLog(@"hmmm, several pics in one image");
	}
	// make a real copy including conversion to float
	isis::data::MemImage<float> memImg = images.front();
	
	//get the type of the orig image
	mDataTypeID = memImg.getChunkAt(0).getTypeID();
	
	
	// give this copy to our class element
	mIsisImage = memImg; 
	//splice the whatever build image to a slice-chunked one (each 2D is a single chunk - easier access later on)
    mIsisImage.spliceDownTo(isis::data::sliceDim);
	// get our class params from the image itself
	mImageSize.rows = mIsisImage.getNrOfRows(); // getDimSize(isis::data::colDim)
    mImageSize.columns = mIsisImage.getNrOfColumms();
    mImageSize.slices = mIsisImage.getNrOfSlices();
    mImageSize.timesteps = mIsisImage.getNrOfTimesteps();
    mRepetitionTimeInMs = (mIsisImage.getPropertyAs<isis::util::fvector4>("voxelSize"))[3];
	
	return self;
}

-(id)initEmptyWithSize:(BARTImageSize*) imageSize ofImageType:(enum ImageType)iType
{
	mAllDataMap.clear();
	mImageType = iType;
	//TODO COPY OPERATOR 
	//mImageSize = imageSize;
	
	return nil;
	
}

-(void)dealloc
{

	[super dealloc];
}

-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	return 0;
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	return 0.0;
}

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)s timestep:(unsigned int)t
{
	
}


-(BOOL)WriteDataElementToFile:(NSString*)path
{
	return FALSE;
}

-(BOOL)WriteDataElementToFile:(NSString*)path withOverwritingSuffix:(NSString*)suffix andDialect:(NSString*)dialect
{
	return FALSE;
}

-(BOOL)sliceIsZero:(int)slice
{
	return FALSE;
}

-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value;
{
	
}

-(id)getImageProperty:(enum ImagePropertyID)key
{
	return nil;
}

-(enum ImageDataType)getImageDataType
{
	return IMAGE_DATA_UNKNOWN;
}


-(float*)getSliceData:(uint)sliceNr atTimestep:(uint)tstep
{
	return nil;
}

-(float*)getRowDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep
{
	return nil;
}

-(void)setRowAt:(uint)row atSlice:(uint)sl	atTimestep:(uint)tstep withData:(float*)data
{
	
}

-(float*)getColDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep
{
	return nil;
}

-(void)setColAt:(uint)col atSlice:(uint)sl atTimestep:(uint)tstep withData:(float*)data
{
	
}

-(float*)getTimeseriesDataAtRow:(uint)row atCol:(uint)col atSlice:(uint)sl fromTimestep:(uint)tstart toTimestep:(uint)tend
{
	return nil;
}

-(void)print
{
	
}

-(void)copyProps:(NSArray*)propList fromDataElement:(BADataElement*)srcElement
{
	
}

-(NSDictionary*)getProps:(NSArray*)propList
{
	NSDictionary *props = [[NSDictionary alloc] init];
	return props;
}

-(void)setProps:(NSDictionary*)propDict
{
	
}


@end
