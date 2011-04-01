//
//  BAProcedureController.m
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAProcedureController.h"
#import "BADataElement.h"
#import "BADesignElement.h"
#import "BAAnalyzerElement.h"
#import "BADataElementRealTimeLoader.h"
#import "BARTNotifications.h"



@interface BAProcedureController ()

//
BADataElement *mInputData;
BADesignElement *mDesignData;
BADataElement *mResultData;
BAAnalyzerElement *mAnalyzer;
size_t mCurrentTimestep;
BADataElementRealTimeLoader *mRtLoader;


-(void)nextDataArrived:(NSNotification*)aNotification;
-(void)analysisStepDidFinish:(NSNotification*)aNotification;

-(void)processDataThread;
-(void)timerThread;



@end


@implementation BAProcedureController

-(id)init
{
    if (self = [super init]) {
        // TODO: appropriate init
        mCurrentTimestep = 50;
		
		
    }
    return self;
}

-(void)dealloc
{
	
	[mInputData release];
	[mResultData release];
    [mDesignData release];
	[mAnalyzer release];
	
	
	[super dealloc];
}


-(BOOL) initData
{
	// release actual data element
	if (nil != mInputData){
		[mInputData release];
		mInputData = nil;
	}
	BOOL thisisafileload = TRUE;
	//FILE LOAD STUFF
	if (TRUE == thisisafileload){
		// setup the input data
		mInputData = [[BADataElement alloc] initWithDataFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" andSuffix:@"" andDialect:@"" ofImageType:IMAGE_FCTDATA];
		if (nil == mInputData) {
			return FALSE;
		}
		//POST 
	
		[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadBackgroundImageNotification object:mInputData];
	}
	else{
		//REALTIMESTUFF
		mRtLoader = [[BADataElementRealTimeLoader alloc] init];
		BARTImageSize *imSize = [[BARTImageSize alloc] init];
		mInputData = [[BADataElement alloc] initEmptyWithSize:imSize ofImageType:IMAGE_FCTDATA];
	}
	
	//register as observer for new data
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(nextDataArrived:)
												 name:BARTDidLoadNextDataNotification object:nil];
	return TRUE;
}

-(BOOL) initDesign
{
	if (nil != mDesignData){
		[mDesignData release];
		mDesignData = nil;}
	
	mDesignData = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	if (nil == mDesignData){
		return FALSE;}
	
	return TRUE;
}

-(BOOL) initPresentation
{
	return FALSE;
}

-(BOOL) initAnalyzer
{
	if (nil != mAnalyzer){
		[mAnalyzer release];
		mAnalyzer = nil;}
	
	mAnalyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
	if (nil == mAnalyzer){
		return FALSE;}
	return TRUE;
}

-(BOOL)startAnalysis
{
	[NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
	
	return TRUE;
}

-(void)nextDataArrived:(NSNotification*)aNotification
{
	//[aNotification object]
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadBackgroundImageNotification object:mInputData];
	
	// TODO: hard coded max number timesteps
	NSLog(@"Timestep: %d", mCurrentTimestep+1);
	if (mCurrentTimestep < [mDesignData mNumberTimesteps]) {
		mCurrentTimestep++;
		[NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
	}
}

-(void)processDataThread
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	
	// TODO: copy of DataElement
	BADataElement *resData = [mAnalyzer anaylzeTheData:mInputData withDesign:[mDesignData copy] andCurrentTimestep:mCurrentTimestep];
	
	// TODO: Post GUI update event
	//[[BAGUIProtoCGLayer getGUI] setForegroundImage:resMap];
	//[NSApp sendAction:@selector(setForegroundImage:) to:guiController from:resMap];
	//[guiController setForegroundImage:resData];
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidCalcNextResultNotification object:resData];
	
	
	[autoreleasePool drain];
	[NSThread exit];
}

-(void)timerThread
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	
	[self nextDataArrived:nil];
	
	[NSThread sleepForTimeInterval:1.0];
	[NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
	
	[autoreleasePool drain];
	[NSThread exit];
}

-(void)analysisStepDidFinish:(NSNotification*)aNotification
{
	// TODO: update GUI
}


@end
