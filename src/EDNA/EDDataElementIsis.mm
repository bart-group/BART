//
//  EDDataElementIsis.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#define _GLIBCXX_FULLY_DYNAMIC_STRING 1
#undef _GLIBCXX_DEBUG
#undef _GLIBCXX_DEBUG_PEDANTIC

#import "EDDataElementIsis.h"



#include "DataStorage/image.hpp"
#include "DataStorage/io_factory.hpp"


#include <iostream>

@implementation EDDataElementIsis


-(id)initWithFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
	self = [super init];
    
	// set  isis loglevels
	isis::data::ImageList images;
	isis::image_io::enable_log<isis::util::DefaultMsgPrint>( isis::warning );
	isis::data::enable_log<isis::util::DefaultMsgPrint>( isis::warning );
	isis::util::enable_log<isis::util::DefaultMsgPrint>( isis::warning );
	
	// the most important thing - load with isis factory
	mIsisImageList = isis::data::IOFactory::load( [path cStringUsingEncoding:NSUTF8StringEncoding], "", "" );

	// that's unusual 
    uint s = mIsisImageList.size();
    if (1 < mIsisImageList.size()) {
        NSLog(@"hmmm, several pics in one image");
	}
	
	//get the type of the orig image
	dataTypeID = (*(mIsisImageList.front())).getChunkAt(0).typeID();
	
	// make a real copy including conversion to float
	isis::data::MemImage<float> memImg = (*(mIsisImageList.front()));
	// give this copy to our class element
	mIsisImage = memImg; 
	//splice the whatever build image to a slice-chunked one (each 2D is a single chunk - easier access later on)
    mIsisImage.spliceDownTo(isis::data::sliceDim);
	// get our class params from the image itself
	numberRows = mIsisImage.sizeToVector()[isis::data::readDim];
    numberCols = mIsisImage.sizeToVector()[isis::data::phaseDim];
    numberSlices = mIsisImage.sizeToVector()[isis::data::sliceDim];
    numberTimesteps = mIsisImage.sizeToVector()[isis::data::timeDim];
    repetitionTimeInMs = (mIsisImage.getProperty<isis::util::fvector4>("voxelSize"))[3];
	
	// the image type is now just important for writing
	
 	return self;
}


-(id)initWithDataType:(enum ImageDataType)type andRows:(int) rows andCols:(int)cols andSlices:(int)slices andTimesteps:(int) tsteps 
{
    if (self = [super init]) {
        numberCols = cols;
        numberRows = rows;
        numberSlices = slices;
        numberTimesteps = tsteps;
		dataTypeID = isis::data::TypePtr<float>::staticID;
	}
    
	// empty isis image
    mIsisImage = isis::data::Image();
    	
	// create it with each slice and each timestep as a chunk and with type float (loaded ones are converted)
	for (int ts = 0; ts < tsteps; ts++){
		for (int sl = 0; sl < slices; sl++){
			isis::data::MemChunk<float> ch(cols, rows);
			ch.setProperty("indexOrigin", isis::util::fvector4(0,0,sl));
			ch.setProperty<u_int32_t>("acquisitionNumber", sl+ts*slices);
			ch.setProperty<u_int16_t>("sequenceNumber", 1);
			ch.setProperty("voxelSize", isis::util::fvector4(1,1,1,0));
			ch.setProperty("readVec", isis::util::fvector4(1,0,0,0));
			ch.setProperty("phaseVec", isis::util::fvector4(0,1,0,0));
			ch.setProperty("sliceVec", isis::util::fvector4(0,0,1,0));
			//mChunkList.push_back(ch);
			mIsisImage.insertChunk(ch);
		}
	}

    mIsisImage.reIndex();
   return self;
}


-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{	
	//TODO we dont want to use this!!
	return (short)mIsisImage.voxel<float>(c,r,s,t);	//else {
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)s timestep:(int)t
{
	float val = 0.0;
	if ([self sizeCheckRows:r Cols:c Slices:s Timesteps:t]){
			val = (float)mIsisImage.voxel<float>(c,r,s,t);
		}
    return val;
}

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)sl timestep:(unsigned int)t
{
	if ([self sizeCheckRows:r Cols:c Slices:sl Timesteps:t]){
		mIsisImage.voxel<float>(c,r,sl,t) = [val floatValue];}
}

-(void)WriteDataElementToFile:(NSString*)path
{
	[self WriteDataElementToFile:path withOverwritingSuffix:@"" andDialect:@""];
}

-(void)WriteDataElementToFile:(NSString*)path withOverwritingSuffix:(NSString*)suffix andDialect:(NSString*)dialect
{
	isis::data::ImageList imgList;
	//dataTypeID = isis::data::TypePtr<int8_t>::staticID;
	
	switch (dataTypeID) {
		case isis::data::TypePtr<int8_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<int8_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<u_int8_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<u_int8_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<int16_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<int16_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<u_int16_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<u_int16_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<int32_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<int32_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<u_int32_t>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<u_int32_t> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<float>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<float> (mIsisImage));
			break;
		}
		case isis::data::TypePtr<double>::staticID:
		{
			imgList.push_back( (boost::shared_ptr<isis::data::Image>) new isis::data::TypedImage<double> (mIsisImage));
			break;
		}
			
		default:
			NSLog(@"writeDataElementToFile failed due to unknown data type");
			return;
	}

	isis::data::IOFactory::write( imgList, [path cStringUsingEncoding:NSUTF8StringEncoding], [suffix cStringUsingEncoding:NSUTF8StringEncoding], [dialect cStringUsingEncoding:NSUTF8StringEncoding] );
}

-(BOOL)sliceIsZero:(int)slice
{
	// TODO quite slowly at the moment check performance
	return TRUE;
	//isis::util::_internal::TypeBase::Reference minV, maxV;
//	mIsisImage.getChunk(0,0,slice, 0, false).getMinMax(minV, maxV);
//	//NSLog(@"slice is zero: %.2f", maxV->is<float>());
//	if (float(0.0) == maxV->is<float>()){
//		return TRUE;}
//	else {
//		return TRUE;}

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
			for (unsigned int i = 0; i<3; i++){
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


-(float*)getSliceData:(uint)sliceNr atTimestep:(uint)tstep
{	
	if ([self sizeCheckRows:1 Cols:1 Slices:sliceNr Timesteps:tstep]){
		isis::data::MemChunkNonDel<float> chSlice(numberCols, numberRows);
		mIsisImage.getChunk(0,0, sliceNr, tstep, false).copySlice(0, 0, chSlice, 0, 0);
		return (( boost::shared_ptr<float> ) chSlice.getTypePtr<float>()).get();
	}
	return NULL;

}

-(float*)getTimeseriesDataAtRow:(uint)row atCol:(uint)col atSlice:(uint)sl fromTimestep:(uint)tstart toTimestep:(uint)tend
{	
	if ([self sizeCheckRows:row Cols:col Slices:sl Timesteps:tend] and (tstart < tend) ){
		uint nrTimesteps = tend-tstart+1;
		isis::data::MemChunkNonDel<float> chTimeSeries(nrTimesteps, 1);
		for (uint i = tstart; i < tend+1; i++){
			chTimeSeries.voxel<float>(i-tstart,0) = mIsisImage.getChunk(0,0,sl,i, false).voxel<float>(col, row);}
		return (( boost::shared_ptr<float> ) chTimeSeries.getTypePtr<float>()).get();
	}
	return NULL;
}

-(float*)getRowDataAt:(uint)row atSlice:(uint)sl atTimestep:(uint)tstep
{	
	if ([self sizeCheckRows:row Cols:1 Slices:sl Timesteps:tstep]){
		isis::data::MemChunkNonDel<float> rowChunk(numberCols, 1);
		mIsisImage.getChunk(0, 0, sl, tstep, false).copyLine(row, 0, 0, rowChunk, 0, 0, 0);
		return (( boost::shared_ptr<float> )rowChunk.getTypePtr<float>()).get();	
	}
	return NULL;
}

-(float*)getColDataAt:(uint)col atSlice:(uint)sl atTimestep:(uint)tstep
{	
	if ([self sizeCheckRows:1 Cols:col Slices:sl Timesteps:tstep] ){
		isis::data::MemChunkNonDel<float> colChunk(numberRows, 1);
		isis::data::Chunk sliceCh = mIsisImage.getChunk(0,0,sl,tstep, false);
		for (uint i = 0; i < numberRows; i++){
			colChunk.voxel<float>(i, 0) = sliceCh.voxel<float>(col, i, 0, 0);}
		return (( boost::shared_ptr<float> ) colChunk.getTypePtr<float>()).get();
	}
	return NULL;
}

-(void)setRowAt:(uint)row atSlice:(uint)sl	atTimestep:(uint)tstep withData:(float*)data
{	
	if ([self sizeCheckRows:row Cols:1 Slices:sl Timesteps:tstep] ){
		isis::data::MemChunk<float> dataToCopy(data, numberCols);
		isis::data::Chunk dataInsertCh = (mIsisImage.getChunk(0, 0, sl, tstep, false));
		dataToCopy.copyLine(0, 0, 0, dataInsertCh, row, 0, 0);}
	return;
	
}

-(void)setColAt:(uint)col atSlice:(uint)sl atTimestep:(uint)tstep withData:(float*)data
{	
	if ([self sizeCheckRows:1 Cols:col Slices:sl Timesteps:tstep] ){
		isis::data::MemChunk<float> dataToCopy(data, numberRows);
		isis::data::Chunk sliceCh = mIsisImage.getChunk(0,0,sl,tstep, false);
		for (uint i = 0; i < numberRows; i++){
			sliceCh.voxel<float>(col, i, 0, 0) = dataToCopy.voxel<float>(i, 0);}
	}
	return;
}


-(void)print
{
	mIsisImage.print(std::cout, true);
}

-(BOOL)sizeCheckRows:(uint)r Cols:(uint)c Slices:(uint)s Timesteps:(uint)t
{
	if (r < numberRows      and 0 <= r and
		c < numberCols      and 0 <= c and
		s < numberSlices    and 0 <= s and
		t < numberTimesteps and 0 <= t){
		return YES;}
	return NO;

}

-(void)copyProps:(NSArray*)propList fromDataElement:(BADataElement*)srcElement
{
	[self setProps: [srcElement getProps:propList]];
}


-(NSDictionary*)getProps:(NSArray*)propList
{
	NSMutableArray *propValues = [[NSMutableArray alloc] init];
	for (NSString *str in propList) {				// type is fvector4
		if ( [[str lowercaseString] isEqualToString:@"indexorigin"]
		or [[str lowercaseString] isEqualToString:@"readvec"]
		or [[str lowercaseString] isEqualToString:@"phasevec"]
		or [[str lowercaseString] isEqualToString:@"slicevec"]
		or [[str lowercaseString] isEqualToString:@"capos"]
		or [[str lowercaseString] isEqualToString:@"cppos"]
		or [[str lowercaseString] isEqualToString:@"voxelsize"]
		or [[str lowercaseString] isEqualToString:@"voxelgap"])
		{
			isis::util::fvector4 prop = mIsisImage.getProperty<isis::util::fvector4>([str  cStringUsingEncoding:NSISOLatin1StringEncoding]);
			NSArray* ret = [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:prop[0]], [NSNumber numberWithFloat:prop[1]], [NSNumber numberWithFloat:prop[2]], [NSNumber numberWithFloat:prop[3]], nil ] autorelease];
			[propValues addObject:ret];
		}
		else if( [[str lowercaseString] isEqualToString:@"acquisitionnumber"]) //type is u_int32_t
		{
			u_int32_t prop = mIsisImage.getProperty<u_int32_t>([str  cStringUsingEncoding:NSISOLatin1StringEncoding]);
			NSNumber* ret = [[NSNumber numberWithUnsignedLong:prop] autorelease];
			[propValues addObject:ret];
		}
		else if ( [[str lowercaseString] isEqualToString:@"repetitiontime"]	// type is u_int16_t
		or   [[str lowercaseString] isEqualToString:@"sequencenumber"]
		or   [[str lowercaseString] isEqualToString:@"subjectage"]
		or   [[str lowercaseString] isEqualToString:@"subjectweight"]
		or   [[str lowercaseString] isEqualToString:@"flipangle"]
		or   [[str lowercaseString] isEqualToString:@"numberofaverages"] )
		{
			u_int16_t prop = mIsisImage.getProperty<u_int16_t>([str  cStringUsingEncoding:NSISOLatin1StringEncoding ]);
			NSNumber* ret = [[NSNumber numberWithUnsignedInt:prop] autorelease];
			[propValues addObject:ret];
		}
		else if ( [[str lowercaseString] isEqualToString:@"echotime"]	 // type is float
		or   [[str lowercaseString] isEqualToString:@"acquisitiontime"] )
		{
			float prop = mIsisImage.getProperty<float>([str  cStringUsingEncoding:NSISOLatin1StringEncoding]);
			NSNumber* ret = [[NSNumber numberWithFloat:prop] autorelease];
			[propValues addObject:ret];
		}
		else									// everything else is interpreted as string (conversion by isis)
		{
			std::string prop = mIsisImage.getProperty<std::string>([str  cStringUsingEncoding:NSISOLatin1StringEncoding]);
			NSString* ret = [[NSString stringWithCString:prop.c_str() encoding:NSISOLatin1StringEncoding] autorelease];
			[propValues addObject:ret];
		}
	} 
		
	NSDictionary *propDict = [[NSDictionary alloc] initWithObjects:propValues forKeys:propList];
	return propDict;
}

-(void)setProps:(NSDictionary*)propDict
{
	
	for (NSString *str in [propDict allKeys]) {		// type is fvector4
		if ( [[str lowercaseString] isEqualToString:@"indexorigin"]
			or [[str lowercaseString] isEqualToString:@"readvec"]
			or [[str lowercaseString] isEqualToString:@"phasevec"]
			or [[str lowercaseString] isEqualToString:@"slicevec"]
			or [[str lowercaseString] isEqualToString:@"capos"]
			or [[str lowercaseString] isEqualToString:@"cppos"]
			or [[str lowercaseString] isEqualToString:@"voxelsize"]
			or [[str lowercaseString] isEqualToString:@"voxelgap"])
		{
			isis::util::fvector4 prop;
			if (YES == [[propDict valueForKey:str] isKindOfClass:[NSArray class]]){
				for (unsigned int i = 0; i < [[propDict valueForKey:str] count]; i++){
					prop[i] = [[[propDict valueForKey:str] objectAtIndex:i] floatValue];}
				mIsisImage.setProperty<isis::util::fvector4>([str cStringUsingEncoding:NSISOLatin1StringEncoding], prop);
			}
		}
		else if( [[str lowercaseString] isEqualToString:@"acquisitionnumber"]) //type is u_int32_t
		{
			if (YES == [[propDict valueForKey:str] isKindOfClass:[NSNumber class]]){
				u_int32_t prop = [[propDict valueForKey:str] unsignedLongValue];
				mIsisImage.setProperty<u_int32_t>([str  cStringUsingEncoding:NSISOLatin1StringEncoding], prop);}
		}
		else if ( [[str lowercaseString] isEqualToString:@"repetitiontime"] // type is u_int16_t
			or   [[str lowercaseString] isEqualToString:@"sequencenumber"]
			or   [[str lowercaseString] isEqualToString:@"subjectage"]
			or   [[str lowercaseString] isEqualToString:@"subjectweight"]
			or   [[str lowercaseString] isEqualToString:@"flipangle"]
			or   [[str lowercaseString] isEqualToString:@"numberofaverages"] )
		{
			if (YES == [[propDict valueForKey:str] isKindOfClass:[NSNumber class]]){
				u_int16_t prop = [[propDict valueForKey:str] unsignedIntValue];
				mIsisImage.setProperty<u_int16_t>([str  cStringUsingEncoding:NSISOLatin1StringEncoding], prop);}
		}
		else if ( [[str lowercaseString] isEqualToString:@"echotime"]  // type is float
			or   [[str lowercaseString] isEqualToString:@"acquisitiontime"] )
		{
			if (YES == [[propDict valueForKey:str] isKindOfClass:[NSNumber class]]){
				float prop = [[propDict valueForKey:str] floatValue];
				mIsisImage.setProperty<float>([str  cStringUsingEncoding:NSISOLatin1StringEncoding], prop);}
		}
		else									// everything else is interpreted as string (conversion by isis)
 		{
			if (YES == [[propDict valueForKey:str] isKindOfClass:[NSString class]]){
				std::string prop = [[propDict valueForKey:str]  cStringUsingEncoding:NSISOLatin1StringEncoding];
				NSLog(@"%s", prop.c_str());
				mIsisImage.setProperty<std::string>([str  cStringUsingEncoding:NSISOLatin1StringEncoding], prop.c_str());}
		}
	} 
	
}

@end
