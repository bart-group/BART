//
//  EDDataElementIsis.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../BARTMainApp/BADataElement.h"
#include "/Users/Lydi/Development/isis/lib/DataStorage/image.hpp"

@interface EDDataElementIsis : BADataElement {
	isis::data::ImageList mIsisImageList;
    isis::data::Image mIsisImage;
	
	
}

@end
