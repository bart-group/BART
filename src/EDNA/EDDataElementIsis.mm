//
//  EDDataElementIsis.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "EDDataElementIsis.h"
#include "/Users/Lydi/Development/isis/lib/DataStorage/image.hpp"
#include "/Users/Lydi/Development/isis/lib/DataStorage/io_factory.hpp"


@implementation EDDataElementIsis


-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
	self = [super init];
    

	isis::data::ImageList images;
	isis::image_io::enable_log<isis::util::DefaultMsgPrint>( isis::info );
	
	// the null-loader shall generate 5 3x3x3x10 images
	mIsisImageList = isis::data::IOFactory::load( [path cStringUsingEncoding:NSUTF8StringEncoding], "", "" );
	//  write images to file(s)
	//if(isis::data::IOFactory::write( mIsisImage, "/tmp/delme.nii", "" ))
//		std::cout << "Wrote Image to " << std::endl;
	//isis::data::IOFactory::load( "/tmp/delme.nii", "" );
	//mIsisImage = isis::data::IOFactory::load( "/tmp/data_test01.nii", "" );
	
	
    if (1 > mIsisImageList.size()) {
        NSLog(@"hmmm, several pics in one image");
        return nil;
    }
    BOOST_FOREACH(isis::data::ImageList::value_type &refImage, mIsisImageList){
        mIsisImage = *refImage;
    }
    numberRows = mIsisImage.sizeToVector()[isis::data::readDim];
    numberCols = mIsisImage.sizeToVector()[isis::data::phaseDim];
    numberSlices = mIsisImage.sizeToVector()[isis::data::sliceDim];
    numberTimesteps = mIsisImage.sizeToVector()[isis::data::timeDim];
    imageDataType = IMAGE_DATA_SHORT;
    
    repetitionTimeInMs;
    
    
    
	return self;
}


-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps 
{
    if (self = [super init]) {
        numberCols = cols;
        numberRows = rows;
        numberSlices = slices;
        numberTimesteps = tsteps;
        imageDataType = type;
    }
    
    mIsisImage = isis::data::Image();
    if (IMAGE_DATA_FLOAT == type){
		
        isis::data::MemChunk<float> ch(rows, cols, slices);
        
		ch.setProperty("indexOrigin", isis::util::fvector4(0,0,0,0));
		ch.setProperty<uint32_t>("acquisitionNumber", 1);
		ch.setProperty<uint16_t>("sequenceNumber", 1);
		ch.setProperty("voxelSize", isis::util::fvector4(1,1,1,0));
		ch.setProperty("readVec", isis::util::fvector4(1,0,0,0));
		ch.setProperty("phaseVec", isis::util::fvector4(0,1,0,0));
		ch.setProperty("sliceVec", isis::util::fvector4(0,0,1,0));
		ch.print(std::cout, true);
		mIsisImage.insertChunk(ch);
    }
    else {
        isis::data::MemChunk<int16_t> ch(rows, cols, slices);
		
		ch.setProperty("indexOrigin", isis::util::fvector4(0,0,0,0));
		ch.setProperty<uint32_t>("acquisitionNumber", 1);
		ch.setProperty<uint16_t>("sequenceNumber", 1);
		ch.setProperty("voxelSize", isis::util::fvector4(1,1,1,0));
		ch.setProperty("readVec", isis::util::fvector4(1,0,0,0));
		ch.setProperty("phaseVec", isis::util::fvector4(0,1,0,0));
		ch.setProperty("sliceVec", isis::util::fvector4(0,0,1,0));
		ch.print(std::cout, true);
		mIsisImage.insertChunk(ch);
    }
	mIsisImage.reIndex();

   return self;
}


-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	if (IMAGE_DATA_FLOAT == imageDataType){
		//isis::data::MemChunk<int16_t> ch(mIsisImage.getChunk(0));
		return (short)mIsisImage.voxel<float>(r,c,s,t);}
	else {
		
		return mIsisImage.voxel<int16_t>(r,c,s,t);
	}

	
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	float val;
	if (IMAGE_DATA_FLOAT == imageDataType){
		val = (float)mIsisImage.voxel<float>(r,c,s,t);
	}
	else{
		val = (float)mIsisImage.voxel<int16_t>(r,c,s,t);
	}
    return val;
}

-(void)setVoxelValue:(NSNumber*)val atRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	mIsisImage.voxel<float>(r,c,s,t) = [val floatValue];
}

-(void)WriteDataElementToFile:(NSString*)path
{
    
	isis::data::IOFactory::write( mIsisImageList, "/tmp/delme.nii", "" );
}

-(BOOL)sliceIsZero:(int)slice
{
	return TRUE;
}

-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value
{	
}

-(id)getImageProperty:(enum ImagePropertyID)key
{	
	return @"";
}


-(short*)getShortDataFromSlice:(int)sliceNr
{	
	return nil;
}

-(float*)getFloatDataFromSlice:(int)sliceNr
{
	return nil;
}

@end
