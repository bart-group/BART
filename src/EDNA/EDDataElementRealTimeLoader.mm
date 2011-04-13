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
	//self = [super init];
	//arrayLoadedDataElements = [[NSMutableArray alloc] initWithCapacity:1];
	//[arrayLoadedDataElements autorelease];
	mDataElement = nil;
	return self;
}

-(void)startRealTimeInputOfImageType
{
	NSLog(@"startRealTimeInputOfImageType START");
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	mDataElement = [[EDDataElementIsisRealTime alloc] initEmptyWithSize:[[BARTImageSize alloc] init] ofImageType:IMAGE_FCTDATA];
	
	[[NSThread currentThread] setThreadPriority:1.0];
	while (![[NSThread currentThread] isCancelled]) {
		[self loadNextVolumeOfImageType:IMAGE_FCTDATA];
	}
	NSLog(@"startRealTimeInputOfImageType END");

	[pool drain];
}


-(void)loadNextVolumeOfImageType:(enum ImageType)imgType
{
	//isis::image_io::enableLog<isis::util::DefaultMsgPrint>( isis::error );
	//isis::data::enableLog<isis::util::DefaultMsgPrint>( isis::error );
	
    NSLog(@"loadNextVolumeOfImageType START");

	std::list<isis::data::Image> tempList = isis::data::IOFactory::load("", ".tcpip", "");
    
    if (0 == tempList.size() && (YES == [[NSThread currentThread] isExecuting])){
        [[NSThread currentThread] cancel];
        NSLog(@"cancel thread now");
        return;
    }
	EDDataElementIsisRealTime *elem = [[EDDataElementIsisRealTime alloc] initEmptyWithSize:[[BARTImageSize alloc] init] ofImageType:IMAGE_FCTDATA];
	
	std::list<isis::data::Image>::const_iterator it ;
    for (it = tempList.begin(); it != tempList.end(); it++) {
		if (TRUE == [self isImage:*it ofImageType:imgType]){
            [elem appendVolume:*it];
			[mDataElement appendVolume:*it];
        }
		else {
			// TODO what to do with other data
			//[arrayLoadedDataElements addObject:dataElem];
		}

		
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadNextDataNotification object:mDataElement];
	//[[NSNotificationCenter defaultCenter] postNotificationName:BARTTestBackroundNotification object:elem];
	NSLog(@"loadNextVolumeOfImageType END loaded imageNR: %ld", [mDataElement getImageSize].timesteps);

}


-(BOOL)isImage:(isis::data::Image)img ofImageType:(enum ImageType)imgType
{
	//TODO: kriterien festlegen!!!
	std::string seqDescr;
	switch (imgType) {
		case IMAGE_MOCO:
			seqDescr = img.getPropertyAs<std::string>("sequenceDescription");
			if (0 == seqDescr.compare("epi_2D")){
				return TRUE;}
			return FALSE;
			break;
		case IMAGE_FCTDATA:
			
			return TRUE;
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
