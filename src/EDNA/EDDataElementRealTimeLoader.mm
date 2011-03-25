//
//  EDDataElementRealTimeLoader.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 3/22/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//



#import "DataStorage/io_factory.hpp"
#import "DataStorage/image.hpp"
#import "EDDataElementIsis.h"
#import "BARTNotifications.h"
#import "EDDataElementRealTimeLoader.h"

@interface EDDataElementRealTimeLoader ()

-(void)loadNextVolumeOfImageType:(enum ImageType)imgType;
-(BOOL)isImage:(isis::data::Image)img ofImageType:(enum ImageType)imgType;
@end


@implementation EDDataElementRealTimeLoader

-(id)init
{
	self = [super init];
	arrayLoadedDataElements = [[NSMutableArray alloc] initWithCapacity:1];
	[arrayLoadedDataElements autorelease];

	return self;
}

-(void)startRealTimeInputOfImageType:(enum ImageType)imgType
{
	[[NSThread currentThread] setThreadPriority:1.0];
	while (![[NSThread currentThread] isCancelled]) {
		[self loadNextVolumeOfImageType:imgType];
	}
	
}


-(void)loadNextVolumeOfImageType:(enum ImageType)imgType
{
	isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::error );
	isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::error );
	
    
	std::list<isis::data::Image> tempList = isis::data::IOFactory::load("", ".tcpip", "");
    
    if (0 == tempList.size() && (YES == [[NSThread currentThread] isExecuting])){
        [[NSThread currentThread] cancel];
        NSLog(@"cancel thread now");
        return;
    }
	//[arrayLoadedDataElements removeAllObjects];
	std::list<isis::data::Image>::const_iterator it ;
	EDDataElementIsis *dataElem;
    for (it = tempList.begin(); it != tempList.end(); it++) {
		if (TRUE == [self isImage:*it ofImageType:imgType]){
			dataElem = [[EDDataElementIsis alloc] initFromImage:*it ofImageType:imgType];}
        //imageList.push_back(*it);
		[arrayLoadedDataElements addObject:dataElem];
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadNextDataNotification object:dataElem];
}

-(BADataElement*)getDataElements
{
	return nil;
}

-(BOOL)isImage:(isis::data::Image)img ofImageType:(enum ImageType)imgType
{
	std::string seqDescr;
	switch (imgType) {
		case IMAGE_MOCO:
			seqDescr = img.getPropertyAs<std::string>("sequenceDescription");
			if (0 == seqDescr.compare("epi_2D")){
				return TRUE;}
			return FALSE;
			break;
		case IMAGE_FCTDATA:
			
			break;
		case IMAGE_ANADATA:
			break;
		case IMAGE_TMAP:
			
			break;
		case IMAGE_BETAS:
			
			break;


		default:
			return FALSE;
			break;
	}
	return FALSE;
}

@end
