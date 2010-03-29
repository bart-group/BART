//
//  BAProcedureController.m
//  BARTCommandLine
//
//  Created by First Last on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BAProcedureController.h"
#import "BAAnalyzerElement.h"
#import "BAGUIProtoCGLayer.h"


@interface BAProcedureController ()
    
-(void)processDataThread;

@end


@implementation BAProcedureController

-(id)init
{
    if (self = [super init]) {
        // TODO: appropriate init
        mRawDataElement = [[BADataElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-functional.v" ofImageDataType:IMAGE_DATA_SHORT];
        mDesignEl = [[BADesignElement alloc] initWithDatasetFile:@"../../tests/BARTMainAppTests/testfiles/TestDataset02-design.des" ofImageDataType:IMAGE_DATA_FLOAT];
        [[BAGUIProtoCGLayer getGUI] setBackgroundImage:mRawDataElement];
        mCurrentTimestep = 50;
    }
    
    return self;
}

-(void)newDataDidArrive:(NSNotification*)aNotification
{
    // TODO: hard coded max number timesteps
    if (mCurrentTimestep < 720) {
        mCurrentTimestep++;
        
        [NSThread detachNewThreadSelector:@selector(processDataThread) toTarget:self withObject:nil];
    }
}

-(void)processDataThread
{
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    BAAnalyzerElement* analyzer = [[BAAnalyzerElement alloc] initWithAnalyzerType:kAnalyzerGLM];
    
    NSLog(@"TIMESTEP: %d", mCurrentTimestep);
    
    BADataElement* resMap = [analyzer anaylzeTheData:mRawDataElement withDesign:mDesignEl andCurrentTimestep:mCurrentTimestep];
    
    [[BAGUIProtoCGLayer getGUI] setForegroundImage:resMap];
    
    // TODO: Post GUI update event
    
    [analyzer release];
    [autoreleasePool drain];
    [NSThread exit];
}

-(void)dealloc
{
    [mRawDataElement release];
    [mDesignEl release];
    [super dealloc];
}

@end
