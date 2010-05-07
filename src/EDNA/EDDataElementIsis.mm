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
	mIsisImage = isis::data::IOFactory::load( "/tmp/TestDataset01-Orig2.nii", "" );
	//  write images to file(s)
	if(isis::data::IOFactory::write( mIsisImage, "/tmp/delme.nii", "" ))
		std::cout << "Wrote Image to " << std::endl;
	isis::data::IOFactory::load( "/tmp/delme.nii", "" );
	//mIsisImage = isis::data::IOFactory::load( "/tmp/data_test01.nii", "" );
	
	return self;
}



-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	return 1;//mIsisImage.voxel<u_int16_t>(r,c,s,t);
	
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	return 0.0;//mIsisImage.voxel<float>(r,c,s,t);
}

-(void)setVoxelValue:(NSNumber*)val atRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	//mIsisImage.voxel<float>(r,c,s,t);
}

-(void)WriteDataElementToFile:(NSString*)path
{
	isis::data::IOFactory::write( mIsisImage, "/tmp/delme.nii", "" );
}

-(BOOL)sliceIsZero:(int)slice
{
	return FALSE;
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
