//
//  BAProcedurePipeline.m
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 10/29/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAProcedurePipeline.h"
#import "EDNA/EDDataElement.h"
#import "NED/NEDesignElement.h"
#import "BAAnalyzerElement.h"
#import "EDNA/EDDataElementRealTimeLoader.h"
#import "BARTNotifications.h"
#import "CLETUS/COExperimentContext.h"
#import "BAProcedureStep_Paradigm.h"


@interface BAProcedurePipeline (PrivateMethods)

//

-(void)nextDataArrived:(NSNotification*)aNotification;

-(void)processDataThread;
-(void)timerThread;
-(void)lastScanArrived:(NSNotification*)aNotification;
-(void)resetProcedurePipeline:(NSNotification*)aNotification;

@end


@implementation BAProcedurePipeline



-(id)init
{
    if ((self = [super init])) {
        // TODO: appropriate init
        mCurrentTimestep = 50;
		config = [[COExperimentContext getInstance] systemConfig];
		isRealTimeTCPInput = NO;
		startAnalysisAtTimeStep = 15;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(resetProcedurePipeline:) 
                                                     name:BARTDidResetExperimentContextNotification object:nil];
    }
	return self;
}

-(void)dealloc
{

	[mInputData release];
	[mResultData release];
   // [dynamicDesignPipe release];
	[mAnalyzer release];
    [paradigm release];
	
	
	[super dealloc];
}

-(void)resetProcedurePipeline:(NSNotification*)aNotification
{
    #pragma unused(aNotification)
    config = [[COExperimentContext getInstance] systemConfig];
    
    //[self initData];
	//[self initDesign];
	//[self initAnalyzer];
    [self initPresentation];
	//[self startAnalysis];
    
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
        NSString *curDir = [[NSBundle mainBundle] resourcePath];
        NSString *fileName = [NSString stringWithFormat:@"%@/TestDataset02-functional.nii", curDir ];
        
		mInputData = [[EDDataElement alloc] initWithDataFile:fileName andSuffix:@"" andDialect:@"" ofImageType:IMAGE_FCTDATA];
		if (nil == mInputData) {
			return FALSE;
		}
		//POST 
		[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidLoadBackgroundImageNotification object:mInputData];
	}
	else{
		//REALTIMESTUFF
		//TODO: Unterscheidung Verzeichnis laden oder rtExport laden - zweiter RealTimeLoader??
		mRtLoader = [[EDDataElementRealTimeLoader alloc] init];
	
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
	if (nil != mDesignData){
		[mDesignData release];
		mDesignData = nil;}
	
	mDesignData = [[NEDesignElement alloc] initWithDynamicData];
	if (nil == mDesignData){
		return FALSE;}
	
	return TRUE;
}

-(BOOL) initPresentation
{
    paradigm = [[BAProcedureStep_Paradigm alloc] init];
    
	return YES;
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
		//NSError *err = [[NSError alloc] init];
		[NSThread detachNewThreadSelector:@selector(startRealTimeInputOfImageType) toTarget:mRtLoader withObject:nil]; 
        //TODO error object 
		//[err release];
        	}

    
	return TRUE;
}

-(void)nextDataArrived:(NSNotification*)aNotification
{
	if (FALSE == isRealTimeTCPInput){
		NSLog(@"Timestep: %lu", mCurrentTimestep+1);
		if ((mCurrentTimestep > startAnalysisAtTimeStep-1 ) && (mCurrentTimestep < [mDesignData mNumberTimesteps])) {
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
		
		NSLog(@"Nr of Timesteps in InputData: %lu", [mInputData getImageSize].timesteps);
		if (([mInputData getImageSize].timesteps > startAnalysisAtTimeStep-1 ) && ([mInputData getImageSize].timesteps < [mDesignData mNumberTimesteps])) {
			[NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
		}
		// JUST FOR TEST
		//if ([mInputData getImageSize].timesteps == 312){
//			NSString *fname =[NSString stringWithFormat:@"/tmp/test_imagenr_dedumm%d.nii", [mInputData getImageSize].timesteps];
//			[[aNotification object] WriteDataElementToFile:fname];}
	}
}

-(void)processDataThread
{
	NSLog(@"processDataThread START");
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	EDDataElement *resData;
	
	
	//TODO : get from config or gui
	float cVecFromConfig[mDesignData.mNumberExplanatoryVariables];
    memset(cVecFromConfig, 0, (sizeof(float)* mDesignData.mNumberExplanatoryVariables ));
	cVecFromConfig[0] = 1.0;
	cVecFromConfig[1] = -1.0;
	//cVecFromConfig[2] = 0.0;
	NSMutableArray *contrastVector = [[NSMutableArray alloc] init];
	for (size_t i = 0; i < mDesignData.mNumberExplanatoryVariables; i++){
		NSNumber *nr = [NSNumber numberWithFloat:cVecFromConfig[i]];
		[contrastVector addObject:nr];}
	
	if (FALSE == isRealTimeTCPInput){
		resData = [[mAnalyzer anaylzeTheData:mInputData withDesign:mDesignData  atCurrentTimestep:mCurrentTimestep-1 forContrastVector:contrastVector andWriteResultInto:nil] retain];
	}
	else {
		resData = [[mAnalyzer anaylzeTheData:mInputData withDesign:mDesignData atCurrentTimestep:[mInputData getImageSize].timesteps forContrastVector:contrastVector andWriteResultInto:nil] retain];
		NSString *fname =[NSString stringWithFormat:@"/tmp/test_zmapnr_%d.nii", [mInputData getImageSize].timesteps];
		[resData WriteDataElementToFile:fname];
	}
	
	//NSLog(@"!!!!resData retainCoung pre notification %d", [resData retainCount]);
   
	[[NSNotificationCenter defaultCenter] postNotificationName:BARTDidCalcNextResultNotification object:[resData autorelease]];
	//NSLog(@"!!!!!resData retainCoung post notification %d", [resData retainCount]);

    [contrastVector release];
	[autoreleasePool drain];
	NSLog(@"processDataThread END");
	[NSThread exit];
}

-(void)timerThread
{
	NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
	
	[self nextDataArrived:nil];
	if (mCurrentTimestep > [mDesignData mNumberTimesteps]){
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
    if ( nil != [aNotification object] ){
        NSString *fname =[NSString stringWithFormat:@"/tmp/{subjectName}_{sequenceNumber}_volumes_%d_%d.nii", [[aNotification object] getImageSize].timesteps, ti];
        [[aNotification object] WriteDataElementToFile:fname];
    }
}


@end
