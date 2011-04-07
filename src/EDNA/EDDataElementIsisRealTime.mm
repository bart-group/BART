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
	isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::info );
	isis::util::enableLog<isis::util::DefaultMsgPrint>( isis::warning );
	
	self = [super init];
    //mRepetitionNumber = 0;
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
    isis::data::Image mIsisImage = memImg; 
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
    self = [super init];
    //mRepetitionNumber = 0;
	mAllDataMap.clear();
	mImageType = iType;
	mImageSize = [imageSize copy];
    
	return self;
	
}

-(void)dealloc
{
    [mImageSize release];
	[super dealloc];
}

-(short)getShortVoxelValueAtRow: (int)r col:(int)c slice:(int)sl timestep:(int)t
{
    std::vector<boost::shared_ptr<isis::data::Chunk> > vecSlices = mAllDataMap[t];
    boost::shared_ptr<isis::data::Chunk> ptrChunk = vecSlices[sl];
    
	return (short)ptrChunk->voxel<float>(c,r);
}

-(float)getFloatVoxelValueAtRow: (int)r col:(int)c slice:(int)sl timestep:(int)t
{
	std::vector<boost::shared_ptr<isis::data::Chunk> > vecSlices = mAllDataMap[t];
    boost::shared_ptr<isis::data::Chunk> ptrChunk = vecSlices[sl];
    
	return (float)ptrChunk->voxel<float>(c,r);
    
}

-(void)setVoxelValue:(NSNumber*)val atRow: (unsigned int)r col:(unsigned int)c slice:(unsigned int)sl timestep:(unsigned int)t
{
    if (mAllDataMap.size() >= t){
        std::vector<boost::shared_ptr<isis::data::Chunk> > vecSlices = mAllDataMap[t];
        if (vecSlices.size() >= sl){
            boost::shared_ptr<isis::data::Chunk> ptrChunk = vecSlices[sl];
            if (mImageSize.rows >= r && mImageSize.columns >= c) {
                ptrChunk->voxel<float>(c,r) = [val floatValue];
            }
        }
    }
    
}


-(BOOL)WriteDataElementToFile:(NSString*)path
{
	
    return [self WriteDataElementToFile:path withOverwritingSuffix:@"" andDialect:@""];
}

-(BOOL)WriteDataElementToFile:(NSString*)path withOverwritingSuffix:(NSString*)suffix andDialect:(NSString*)dialect
{
    std::map<size_t, std::vector<boost::shared_ptr<isis::data::Chunk> > >::iterator itMap;
    std::vector<boost::shared_ptr<isis::data::Chunk> >::iterator itVector;
    std::list<isis::data::Chunk> chunkList;
    for (itMap = mAllDataMap.begin(); itMap != mAllDataMap.end() ; itMap++) {
        for (itVector=(*itMap).second.begin(); itVector != (*itMap).second.end(); itVector++) {
            chunkList.push_back(*(*itVector));
        }
        
    }
    isis::data::Image img(chunkList);
    return isis::data::IOFactory::write(img, [path cStringUsingEncoding:NSUTF8StringEncoding], 
                                 [suffix cStringUsingEncoding:NSUTF8StringEncoding], 
                                 [dialect cStringUsingEncoding:NSUTF8StringEncoding]);
	
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
	return IMAGE_DATA_FLOAT;
}


-(float*)getSliceData:(uint)sliceNr atTimestep:(uint)tstep
{
    std::vector<boost::shared_ptr<isis::data::Chunk> > vecSlices = mAllDataMap[tstep];
    boost::shared_ptr<isis::data::Chunk> ptrChunk = vecSlices[sliceNr];
    return (( boost::shared_ptr<float> ) ptrChunk->getValuePtr<float>()).get();
	
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

-(void)appendVolume:(isis::data::Image)img
{
    if (TRUE == mAllDataMap.empty())
    {
        mImageSize.rows = img.getNrOfRows();
        mImageSize.columns = img.getNrOfColumms();
        mImageSize.slices = img.getNrOfSlices();
        mImageSize.timesteps = 1;
    }
    else {
        if ((mImageSize.rows == img.getNrOfRows())
            && (mImageSize.columns == img.getNrOfColumms())
            && (mImageSize.slices == img.getNrOfSlices()))
        {
            mImageSize.timesteps += 1;
        }
        else {
            NSLog(@"Size of appended Volume does not match all other volumes");
            return;
        }
    }

    std::vector<boost::shared_ptr<isis::data::Chunk> > chVector = img.getChunksAsVector();
    std::vector<boost::shared_ptr<isis::data::Chunk> >::iterator it;
    
    for (it = chVector.begin(); it != chVector.end(); it++) {
        (*it)->join(img);
    }
    mAllDataMap[mImageSize.timesteps-1] = chVector;
    
    //increase the counter used as index in map
    //mRepetitionNumber++;
}


@end
