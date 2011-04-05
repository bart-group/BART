//
//  EDDataElementIsisRealTime.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/30/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../BARTMainApp/BADataElement.h"
#import "DataStorage/image.hpp"
#include <map.h>

@interface EDDataElementIsisRealTime : BADataElement {
	//isis::data::Image mIsisImage;
	map<size_t, std::vector<boost::shared_ptr<isis::data::Chunk> > > mAllDataMap;
    //size_t mRepetitionNumber;
}

-(void)appendVolume:(isis::data::Image)img;

@end
