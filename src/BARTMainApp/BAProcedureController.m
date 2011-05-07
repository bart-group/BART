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
#import "../CLETUS/COSystemConfig.h"
#import "BADynamicDesignController.h"


@interface BAProcedureController (PrivateMethods)

//
BADataElement *mInputData;
//BADesignElement *mDesignData;
BADynamicDesignController *dynamicDesignController;
BADataElement *mResultData;
BAAnalyzerElement *mAnalyzer;
size_t mCurrentTimestep;
BADataElementRealTimeLoader *mRtLoader;
COSystemConfig *config;
//TODO: define enum and take a switch where needed
BOOL isRealTimeTCPInput;
size_t startAnalysisAtTimeStep;


-(void)nextDataArrived:(NSNotification*)aNotification;

-(void)processDataThread;
-(void)timerThread;
-(void)lastScanArrived:(NSNotification*)aNotification;

@end


@implementation BAProcedureController

-(id)init
{
    if (self = [super init]) {
        // TODO: appropriate init
        mCurrentTimestep = 300;
		config = [COSystemConfig getInstance];
		isRealTimeTCPInput = FALSE;
		startAnalysisAtTimeStep = 15;
		
		dynamicDesignController = [[BADynamicDesignController alloc] init]; 
		
    }
	return self;
}

-(void)dealloc
{
	//just for security reasons
	if (1 > [mInputData getImageSize].timesteps){
		NSString *fname =[NSString stringWithFormat:@"/tmp/test_imagenr_SECURITY%d.nii", [mInputData getImageSize].timesteps];
		[mInputData WriteDataElementToFile:fname];}
	
	
	[mInputData release];
	[mResultData release];
    [dynamicDesignController release];
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
	//TODO: switch for different versions!!
	//FILE LOAD STUFF
	if (FALSE == isRealTimeTCPInput){
		// setup the input data
		mInputData = [[BADataElement alloc] initWithDataFile:@"/Users/Lydi/RealTimeProject/BARTTests/29_04_2011/analysisWithBart/tmaps/HL3T_simpleMotorLongBlocks_move.nii" andSuffix:@"" andDialect:@"" ofImageType:IMAGE_FCTDATA];
		if (nil == mInputData) {
			return FALSE;
		}
		//POST 
		[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadBackgroundImageNotification object:mInputData];
	}
	else{
		//REALTIMESTUFF
		//TODO: Unterscheidung Verzeichnis laden oder rtExport laden - zweiter RealTimeLoader??
		mRtLoader = [[BADataElementRealTimeLoader alloc] init];
	
		//register as observer for new data
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(nextDataArrived:)
													 name:BARTDidLoadNextDataNotification object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(lastScanArrived:)
													 name:BARTScannerSentTerminusNotification object:nil];
		
		
		
	}
	
	
	return TRUE;
}

-(BOOL) initDesign
{
	BOOL ret = [dynamicDesignController initDesign];
	NSLog(@"%d", ret);
	return ret;
	//if (nil != mDesignData){
//		[mDesignData release];
//		mDesignData = nil;}
//	
//	mDesignData = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
//	if (nil == mDesignData){
//		return FALSE;}
//	
//	return TRUE;
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
	if (FALSE == isRealTimeTCPInput){
		[NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];}
	else {
		NSError *err = [[NSError alloc] init];
		NSThread *t = [[NSThread alloc] initWithTarget:mRtLoader selector:@selector(startRealTimeInputOfImageType) object:err]; //TODO error object 
		[t start];
	}

	return TRUE;
}

-(void)nextDataArrived:(NSNotification*)aNotification
{
	if (FALSE == isRealTimeTCPInput){
		NSLog(@"Timestep: %d", mCurrentTimestep+1);
		if ((mCurrentTimestep > startAnalysisAtTimeStep-1 ) && (mCurrentTimestep < [[dynamicDesignController designElement] mNumberTimesteps])) {
			[NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
		}
		mCurrentTimestep++;
		
		//JUST FOR TEST
		//NSString *fname =[NSString stringWithFormat:@"/tmp/test_imagenr_%d.nii", mCurrentTimestep];
		//[[aNotification object] WriteDataElementToFile:fname];
	}
	else {
		//get data to analyse out of notification
		mInputData = [aNotification object];

		if ([mInputData getImageSize].timesteps == 1){
			[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadBackgroundImageNotification object:mInputData];
		}
		
		NSLog(@"Nr of Timesteps in InputData: %d", [mInputData getImageSize].timesteps);
		if (([mInputData getImageSize].timesteps > startAnalysisAtTimeStep-1 ) && ([mInputData getImageSize].timesteps < [[dynamicDesignController designElement] mNumberTimesteps])) {
			[NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
		}
		// JUST FOR TEST
		if ([mInputData getImageSize].timesteps == 312){
			NSString *fname =[NSString stringWithFormat:@"/tmp/test_imagenr_dedumm%d.nii", [mInputData getImageSize].timesteps];
			[[aNotification object] WriteDataElementToFile:fname];}
	}
}

-(void)processDataThread
{
	NSLog(@"processDataThread START");
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	BADataElement *resData;
	
	
	//TODO : get from config or gui
	float cVecFromConfig[[dynamicDesignController designElement].mNumberExplanatoryVariables];
	cVecFromConfig[0] = 1.0;
	cVecFromConfig[1] = 0.0;
	//cVecFromConfig[2] = 0.0;
	NSMutableArray *contrastVector = [[NSMutableArray alloc] init];
	for (size_t i = 0; i < [dynamicDesignController designElement].mNumberExplanatoryVariables; i++){
		NSNumber *nr = [NSNumber numberWithFloat:cVecFromConfig[i]];
		[contrastVector addObject:nr];}
	
	if (FALSE == isRealTimeTCPInput){
		resData = [mAnalyzer anaylzeTheData:mInputData withDesign:[[dynamicDesignController designElement] copy] atCurrentTimestep:mCurrentTimestep-1 forContrastVector:contrastVector andWriteResultInto:nil];
	}
	else {
		resData = [mAnalyzer anaylzeTheData:mInputData withDesign:[[[dynamicDesignController designElement] copy] autorelease] atCurrentTimestep:[mInputData getImageSize].timesteps forContrastVector:contrastVector andWriteResultInto:nil];
		NSString *fname =[NSString stringWithFormat:@"/tmp/test_zmapnr_%d.nii", [mInputData getImageSize].timesteps];
		[resData WriteDataElementToFile:fname];
	}
	
	//NSLog(@"!!!!resData retainCoung pre notification %d", [resData retainCount]);
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidCalcNextResultNotification object:[resData retain]];
	//NSLog(@"!!!!!resData retainCoung post notification %d", [resData retainCount]);

	[autoreleasePool drain];
	NSLog(@"processDataThread END");
	[NSThread exit];
}

-(void)timerThread
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	
	[self nextDataArrived:nil];
	if (mCurrentTimestep > [[dynamicDesignController designElement] mNumberTimesteps]){
		[[NSThread currentThread] cancel];}
	
	[NSThread sleepForTimeInterval:1.0];
	[NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
	
	[autoreleasePool drain];
	[NSThread exit];
}


-(void)lastScanArrived:(NSNotification*)aNotification
{
	NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
	//TODO: folder from edl
	NSString *fname =[NSString stringWithFormat:@"/tmp/test_imagenr_%d_{subjectName}_{sequenceNumber}_%d.nii", [[aNotification object] getImageSize].timesteps, ti];
	[[aNotification object] WriteDataElementToFile:fname];
}


@end
