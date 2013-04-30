//
//  EDDataElementIsis.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#ifndef EDDATAELEMENTISIS_H
#define EDDATAELEMENTISIS_H

#import <Cocoa/Cocoa.h>
#import "EDDataElement.h"
#import "DataStorage/image.hpp"
#include "Adapter/itkAdapter.hpp"


@interface EDDataElementIsis : EDDataElement {
	//isis::data::ImageList mIsisImageList;
	std::list<isis::data::Image> mIsisImageList; 
    isis::data::Image *mIsisImage;
	//isis::data::ChunkList mChunkList;
	std::list<isis::data::Chunk> mChunkList;
    
    isis::adapter::itkAdapter* mITKAdapter;
	
}

-(void)appendVolume:(EDDataElement*)nextVolume;
-(BOOL)sizeCheckRows:(NSUInteger)r Cols:(NSUInteger)c Slices:(NSUInteger)s Timesteps:(NSUInteger)t;
-(id)initFromImage:(isis::data::Image)img ofImageType:(enum ImageType)imgType;


@end

#endif // EDDATAELEMENTISIS_H