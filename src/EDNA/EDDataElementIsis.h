//
//  EDDataElementIsis.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../BARTMainApp/BADataElement.h"
#import "DataStorage/image.hpp"

@interface EDDataElementIsis : BADataElement {
	isis::data::ImageList mIsisImageList;
    isis::data::Image mIsisImage;
	isis::data::ChunkList mChunkList;
	
	
}


-(BOOL)sizeCheckRows:(uint)r Cols:(uint)c Slices:(uint)s Timesteps:(uint)t;


@end
