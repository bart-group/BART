//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"

#import "NEDesignElementDyn.h"
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
    
    mRawDataElement = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" ofImageDataType:IMAGE_DATA_SHORT];
    //for (unsigned int i = 0; i < 15; i++){
//        short val = [mRawDataElement getShortVoxelValueAtRow:i+27 col:i+33 slice:9 timestep:45];
//        NSLog(@"%d\n", val);
//    }
//    
    //mRawDataElement = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" ofImageDataType:IMAGE_DATA_SHORT];
 
    
	
    mRawDataElement = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" ofImageDataType:IMAGE_DATA_SHORT];
   // [mRawDataElement WriteDataElementToFile:@"/tmp/firstwrittentestfile.nii"];
    mDesignElement = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	if (nil == mDesignElement){
		return;}
	
    mCurrentTimestep = 50;
	
	
	
    guiController = [guiController initWithDefault];
    [guiController setBackgroundImage:mRawDataElement];
    
    //NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(newDataDidArrive:) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
}

-(void)newDataDidArrive:(NSNotification*)aNotification
{
    // TODO: hard coded max number timesteps
    NSLog(@"Timestep: %d", mCurrentTimestep+1);
	if (mCurrentTimestep < [mDesignElement mNumberTimesteps]) {
        mCurrentTimestep++;
        [NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
    }
}

-(void)processDataThread
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    BAAnalyzerElement* analyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
    
    BADataElement* resMap = [analyzer anaylzeTheData:mRawDataElement withDesign:[mDesignElement copy] andCurrentTimestep:mCurrentTimestep];
    
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

    [NSThread sleepForTimeInterval:1.0];
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
