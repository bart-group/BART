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
	//isis::image_io::enable_log<isis::util::DefaultMsgPrint>( isis::info );
	
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
    
	mIsisImage = *(mIsisImageList.front());
    numberRows = mIsisImage.sizeToVector()[isis::data::readDim];
    numberCols = mIsisImage.sizeToVector()[isis::data::phaseDim];
    numberSlices = mIsisImage.sizeToVector()[isis::data::sliceDim];
    numberTimesteps = mIsisImage.sizeToVector()[isis::data::timeDim];
    imageDataType = type;
    
    repetitionTimeInMs = (mIsisImage.getProperty<isis::util::fvector4>("voxelSize"))[3];
    
	isis::data::ChunkList chList(mIsisImage.chunksBegin(), mIsisImage.chunksEnd() );
	unsigned int nrChunks = 0;
	isis::data::ChunkList chListRet;
	//BOOST_FOREACH(isis::data::Chunk &ref, chList){
//		chListRet = ref.splice(isis::data::sliceDim, ref.getProperty<isis::util::fvector4>("voxelSize"), ref.getProperty<isis::util::fvector4>("voxelGap"));
//		nrChunks++;
//	}
	
	NSLog(@"Number of chunks loaded %d and spliced", nrChunks, chListRet.size());
    
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
			ch.setProperty("indexOrigin", isis::util::fvector4(0,0,sl));
			ch.setProperty<uint32_t>("acquisitionNumber", sl+ts*slices);
			ch.setProperty<uint16_t>("sequenceNumber", 1);
			ch.setProperty("voxelSize", isis::util::fvector4(1,1,1,0));
			ch.setProperty("readVec", isis::util::fvector4(1,0,0,0));
			ch.setProperty("phaseVec", isis::util::fvector4(0,1,0,0));
			ch.setProperty("sliceVec", isis::util::fvector4(0,0,1,0));
		
			mChunkList.push_back(ch);
			mIsisImage.insertChunk(ch);
		}
	}

	
    mIsisImage.reIndex();
	
   return self;
}


-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	if (IMAGE_DATA_FLOAT == imageDataType){
		return (short)mIsisImage.voxel<float>(r,c,s,t);}
	else {
		
		return mIsisImage.voxel<int16_t>(r,c,s,t);
	}

	
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	float val = 0.0;
	if (r < numberRows      and 0 <= r and
		c < numberCols      and 0 <= c and
		s < numberSlices    and 0 <= s and
		t < numberTimesteps and 0 <= t){

		if (IMAGE_DATA_FLOAT == imageDataType){
			val = (float)mIsisImage.voxel<float>(r,c,s,t);
		}	
		else{
			val = (float)mIsisImage.voxel<int16_t>(r,c,s,t);
		}}
    return val;
}

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)sl timestep:(unsigned int)t
{

	
	if (r < numberRows      and 0 <= r and
		c < numberCols      and 0 <= c and
		sl < numberSlices    and 0 <= sl and
		t < numberTimesteps and 0 <= t){
		mIsisImage.voxel<float>(r,c,sl,t) = [val floatValue];}
}

-(void)WriteDataElementToFile:(NSString*)path
{
	
	mIsisImage.print(std::cout, true);
	isis::data::MemImage<uint16_t> img(mIsisImage);
	img.print(std::cout, true);
	
	//isis::data::ImageList imageList(mChunkList);
	//isis::data::IOFactory::write( iList, [path cStringUsingEncoding:NSUTF8StringEncoding], "" );
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
			if ( 0 != [value count] ){
				for (unsigned int i = 0; i<4; i++){
					vec[i] = [[value objectAtIndex:i] floatValue];}}
			mIsisImage.setProperty<isis::util::fvector4>("readVec", vec);
			break;
		case PROPID_PHASEVEC:
			if ( 0 != [value count] ){
				for (unsigned int i = 0; i<4; i++){
					vec[i] = [[value objectAtIndex:i] floatValue];}}
			mIsisImage.setProperty<isis::util::fvector4>("phaseVec", vec);
			break;
		case PROPID_SLICEVEC:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}
			mIsisImage.setProperty<isis::util::fvector4>("sliceVec", vec);
			break;
		case PROPID_SEQNR:
			mIsisImage.setProperty<uint16_t>("sequenceNumber", [value unsignedShortValue]);
			break;
		case PROPID_VOXELSIZE:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}
			mIsisImage.setProperty<isis::util::fvector4>("voxelSize", vec);
			break;
		case PROPID_ORIGIN:
			for (unsigned int i = 0; i<4; i++){
				vec[i] = [[value objectAtIndex:i] floatValue];}
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
			ret = [[[NSString alloc ] initWithCString:(mIsisImage.getProperty<std::string>("GLM/name")).c_str() encoding:NSUTF8StringEncoding] autorelease];
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


-(float*)getDataFromSlice:(int)sliceNr atTimestep:(uint)tstep;
{	
	
	//isis::data::MemChunk<int16_t> sliceChunk(mIsisImage.getChunk(0,0,sliceNr, tstep));
	float *pValues = static_cast<float*> (malloc(sizeof(mIsisImage.getChunk(0,0,sliceNr, tstep).volume())));
	mIsisImage.getChunk(0,0,sliceNr, tstep).getTypePtr<float>().copyToMem(0, mIsisImage.getChunk(0,0,sliceNr, tstep).volume() - 1, pValues );
	//mIsisImage.getChunk(0,0,sliceNr, tstep).asTypePtr<int16_t>();//  sliceChunk.getTypePtr();
	
	return pValues;
}


-(void)print
{
	mIsisImage.print(std::cout, true);
}

@end
