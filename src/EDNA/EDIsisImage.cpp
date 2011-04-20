/*
 *  EDIsisImage.cpp
 *  BARTApplication
 *
 *  Created by Lydia Hellrung on 4/20/11.
 *  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
 *
 */


#import "EDIsisImage.h"




EDIsisImage::EDIsisImage(const isis::data::Image &src) : isis::data::Image(src)
{
	//clear the set table to make clear it's not an usual image
		set.clear();
}
	
void EDIsisImage::addVolume(std::vector< boost::shared_ptr< isis::data::Chunk > > chunks){
	BOOST_FOREACH(boost::shared_ptr< isis::data::Chunk > p,chunks){
		lookup.push_back(p);
	}
	isis::util::FixedVector<size_t,4> sizeVector=getSizeAsVector();
	sizeVector[isis::data::timeDim] += 1;
	const size_t sizeForInit[4] = {sizeVector[0], sizeVector[1], sizeVector[2], sizeVector[3]};
	init(sizeForInit);
	//set clean to avoid reIndex() when accessing the image
	isis::data::Image::clean = true;
}

EDIsisImage::~EDIsisImage()
{

}
