//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"
#import "BAGUIPrototyp.h"
#import "BADesignElementDyn.h"
#import "COSystemConfig.h"

@interface BARTApplicationAppDelegate ()

-(void)newDataDidArrive:(NSNotification*)aNotification;
-(void)analysisStepDidFinish:(NSNotification*)aNotification;

-(void)processDataThread;
-(void)timerThread;

@end


@implementation BARTApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{    
    COSystemConfig *config = [COSystemConfig getInstance];
	NSError *err = [config fillWithContentsOfEDLFile:@"../../tests/CLETUSTests/timeBasedRegressorLydi.edl"];
	
	if (err) {
        NSLog(@"%@", err);
	}
    
    mRawDataElement = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
    mDesignElement = [[BADesignElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-design.des" ofImageDataType:IMAGE_DATA_FLOAT];
    mCurrentTimestep = 50;
	
    guiController = [guiController init];
    [guiController setBackgroundImage:mRawDataElement];
    
    //NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(newDataDidArrive:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
}

-(void)newDataDidArrive:(NSNotification*)aNotification
{
    // TODO: hard coded max number timesteps
    if (mCurrentTimestep < [mDesignElement mNumberTimesteps]) {
        mCurrentTimestep++;
        [NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
    }
}

-(void)processDataThread
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    BAAnalyzerElement* analyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
    
    BADataElement* resMap = [analyzer anaylzeTheData:mRawDataElement withDesign:mDesignElement andCurrentTimestep:mCurrentTimestep];
    
    // TODO: Post GUI update event
    //[[BAGUIProtoCGLayer getGUI] setForegroundImage:resMap];
    //[NSApp sendAction:@selector(setForegroundImage:) to:guiController from:resMap];
    [guiController setForegroundImage:resMap];
    
    [analyzer release];
    [autoreleasePool drain];
    [NSThread exit];
}

-(void)timerThread
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    [self newDataDidArrive:nil];

    [NSThread sleepForTimeInterval:0.5];
    [NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
    
    [autoreleasePool drain];
    [NSThread exit];
}

-(void)analysisStepDidFinish:(NSNotification*)aNotification
{
    // TODO: update GUI
}

-(void)dealloc
{
    [mRawDataElement release];
    [mDesignElement release];
        
    [super dealloc];
}

@end
