//
//  EDDataElementRealTimeLoader.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 3/22/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//


#import "DataStorage/image.hpp"
#import "DataStorage/io_factory.hpp"
#import "../BARTMainApp/BADataElementRealTimeLoader.h"
#import "EDDataElementIsis.h"

@interface EDDataElementRealTimeLoader <BADataElementRealTimeLoader> {
	
	NSMutableArray *arrayLoadedDataElements;
	
}

-(void)loadNextVolume;

@end


@implementation EDDataElementRealTimeLoader


-(id)init
{
	[self super];

	arrayLoadedDataElements = [[NSMutableArray alloc] init];
	[arrayLoadedDataElements autorelease];
	
	return self;
}

-(void)startRealTimeInput
{
	[[NSThread currentThread] setThreadPriority:1.0];
	while (![[NSThread currentThread] isCancelled]) {
		[self loadNextVolume];
	}
	
}


-(void)loadNextVolume
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
    for (it = tempList.begin(); it != tempList.end(); it++) {
		EDDataElementIsis *dataElem = [[EDDataElementIsis alloc] initFromImage:*it];
        //imageList.push_back(*it);
		[arrayLoadedDataElements addObject:dataElem];
    }
	//TODO: Notification
}

-(NSArray*)getDataElements
{
	
}

@end
