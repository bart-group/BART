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
#include <iostream>

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
    //BOOST_FOREACH(isis::data::ImageList::value_type &refImage, mIsisImageList){
//        mIsisImage = *refImage;
//    }
	mIsisImage = *(mIsisImageList.front());
    numberRows = mIsisImage.sizeToVector()[isis::data::readDim];
    numberCols = mIsisImage.sizeToVector()[isis::data::phaseDim];
    numberSlices = mIsisImage.sizeToVector()[isis::data::sliceDim];
    numberTimesteps = mIsisImage.sizeToVector()[isis::data::timeDim];
    imageDataType = IMAGE_DATA_SHORT;
    
    repetitionTimeInMs = (mIsisImage.getProperty<isis::util::fvector4>("voxelSize"))[3];
    
	
	
    
    
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
    	
	for (int ts = 0; ts < tsteps; ts++){
		for (int sl = 0; sl < slices; sl++){
			isis::data::MemChunk<float> ch(rows, cols);
			ch.setProperty("indexOrigin", isis::util::fvector4(0,0,sl,ts));
			ch.setProperty<uint32_t>("acquisitionNumber", 1);
			ch.setProperty<uint16_t>("sequenceNumber", 1);
			ch.setProperty("voxelSize", isis::util::fvector4(1,1,1,0));
			ch.setProperty("readVec", isis::util::fvector4(1,0,0,0));
			ch.setProperty("phaseVec", isis::util::fvector4(0,1,0,0));
			ch.setProperty("sliceVec", isis::util::fvector4(0,0,1,0));
		
			mChunkList.push_back(ch);
			mIsisImage.insertChunk(ch);
		}
	}
	
	
	//mIsisImage.insertChunk(ch);
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
	isis::data::ImageList imageList(mChunkList);
	isis::data::IOFactory::write( imageList, [path cStringUsingEncoding:NSUTF8StringEncoding], "" );
}

-(BOOL)sliceIsZero:(int)slice
{
	return TRUE;
}

-(void)setImageProperty:(enum ImagePropertyID)key withValue:(id) value
{	
	isis::util::fvector4 vec;
	switch (key) {
        case PROPID_NAME:
			mIsisImage.setProperty<std::string>("GLM/name", [value UTF8String]);
            break;
        case PROPID_MODALITY:
            
            
            break;
        case PROPID_DF:
            break;
        case PROPID_PATIENT:
			mIsisImage.setProperty<std::string>("subjectName", [value UTF8String]);
            break;
        case PROPID_VOXEL:
            break;
        case PROPID_REPTIME:
            break;
        case PROPID_TALAIRACH:
            break;
        case PROPID_FIXPOINT:
            break;
        case PROPID_CA:
            break;
        case PROPID_CP:
            break;
        case PROPID_EXTENT:
            break;
        case PROPID_BETA:
            break;
		case PROPID_READVEC:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}//, [[value objectAtIndex:1] floatValue], [[value objectAtIndex:2] floatValue], [[value objectAtIndex:3] floatValue]);
			mIsisImage.setProperty<isis::util::fvector4>("readVec", vec);
			break;
		case PROPID_PHASEVEC:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}//, [[value objectAtIndex:1] floatValue], [[value objectAtIndex:2] floatValue], [[value objectAtIndex:3] floatValue]);
			mIsisImage.setProperty<isis::util::fvector4>("phaseVec", vec);
			break;
		case PROPID_SLICEVEC:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}//, [[value objectAtIndex:1] floatValue], [[value objectAtIndex:2] floatValue], [[value objectAtIndex:3] floatValue]);
			mIsisImage.setProperty<isis::util::fvector4>("sliceVec", vec);
			break;
		case PROPID_SEQNR:
			mIsisImage.setProperty<uint16_t>("sequenceNumber", [value unsignedShortValue]);
			break;
		case PROPID_VOXELSIZE:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}//, [[value objectAtIndex:1] floatValue], [[value objectAtIndex:2] floatValue], [[value objectAtIndex:3] floatValue]);
			mIsisImage.setProperty<isis::util::fvector4>("voxelSize", vec);
			break;
		case PROPID_ORIGIN:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}//, [[value objectAtIndex:1] floatValue], [[value objectAtIndex:2] floatValue], [[value objectAtIndex:3] floatValue]);
			mIsisImage.setProperty<isis::util::fvector4>("indexOrigin", vec);
			break;
        default:
            break;
	}
}

-(id)getImageProperty:(enum ImagePropertyID)key
{	
	id ret = nil;
	std::string strtest;
	
	
	switch (key) {
        case PROPID_NAME:
			mIsisImage.getProperty<std::string>("");
            break;
        case PROPID_MODALITY:
            
            
            break;
        case PROPID_DF:
            break;
        case PROPID_PATIENT:
			ret = [[[NSString alloc ] initWithCString:(mIsisImage.getProperty<std::string>("subjectName")).c_str() encoding:NSUTF8StringEncoding] autorelease];
			break;
        case PROPID_VOXEL:
            break;
        case PROPID_REPTIME:
            break;
        case PROPID_TALAIRACH:
            break;
        case PROPID_FIXPOINT:
            break;
        case PROPID_CA:
            break;
        case PROPID_CP:
            break;
        case PROPID_EXTENT:
            break;
        case PROPID_BETA:
            break;
		case PROPID_READVEC:
			ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("readVec")[0]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("readVec")[1]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("readVec")[2]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("readVec")[3]], nil ] autorelease];
			break;
		case PROPID_PHASEVEC:
			ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("phaseVec")[0]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("phaseVec")[1]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("phaseVec")[2]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("phaseVec")[3]], nil ] autorelease];
			break;
		case PROPID_SLICEVEC:
			ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("sliceVec")[0]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("sliceVec")[1]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("sliceVec")[2]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("sliceVec")[3]], nil ] autorelease];
			break;
		case PROPID_SEQNR:
			ret = [NSNumber numberWithUnsignedShort:1];
			break;
		case PROPID_VOXELSIZE:
			ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("voxelSize")[0]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("voxelSize")[1]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("voxelSize")[2]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("voxelSize")[3]], nil ] autorelease];
			break;
		case PROPID_ORIGIN:
			ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("indexOrigin")[0]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("indexOrigin")[1]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("indexOrigin")[2]], [NSNumber numberWithFloat:mIsisImage.getProperty<isis::util::fvector4>("indexOrigin")[3]], nil ] autorelease];
			break;
        default:
            break;
	}
	return ret;
}


-(short*)getDataFromSlice:(int)sliceNr atTimestep:(uint)tstep;
{	
	
	//isis::data::MemChunk<int16_t> sliceChunk(mIsisImage.getChunk(0,0,sliceNr, tstep));
	short *pValues = static_cast<short*> (malloc(sizeof(mIsisImage.getChunk(0,0,sliceNr, tstep).volume())));
	mIsisImage.getChunk(0,0,sliceNr, tstep).getTypePtr<int16_t>().copyToMem(0, mIsisImage.getChunk(0,0,sliceNr, tstep).volume() - 1, pValues );
	//mIsisImage.getChunk(0,0,sliceNr, tstep).asTypePtr<int16_t>();//  sliceChunk.getTypePtr();
	
	return pValues;
}

-(float*)getFloatDataFromSlice:(int)sliceNr
{
	return nil;
}

-(void)print
{
	mIsisImage.print(std::cout, true);
}

@end
