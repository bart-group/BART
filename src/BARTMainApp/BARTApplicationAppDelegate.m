//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"

#import "CLETUS/COExperimentContext.h"
#import "BAProcedurePipeline.h"
#import "BARTNotifications.h"
#import "CLETUS/COExperimentContext.h"


@interface BARTApplicationAppDelegate ()

-(void)setGUIBackgroundImage:(NSNotification*)aNotification;
-(void)setGUIResultImage:(NSNotification*)aNotification;

@end


@implementation BARTApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{  
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIBackgroundImage:)
												 name:BARTDidLoadBackgroundImageNotification object:nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIResultImage:)
												 name:BARTDidCalcNextResultNotification object:nil];
	
    
    //COSystemConfig *config = [[COExperimentContext getInstance] systemConfig];
    COExperimentContext *experimentContext = [COExperimentContext getInstance];
    
   //NSError *err = [config fillWithContentsOfEDLFile:@"../../../../tests/NEDTests/timeBasedRegressorNEDTest.edl"];
	
	guiController = [guiController initWithDefault];
	
    procedurePipe = [[BAProcedurePipeline alloc] init];
    
    NSError *err = [experimentContext resetWithEDLFile:@"../../tests/NEDTests/timeBasedRegressorNEDTest.edl"];
    if (err) {
        NSLog(@"%@", err);
	}
	
	
	
  }

-(void)setGUIBackgroundImage:(NSNotification*)aNotification
{
	//set this as background for viewer
	EDDataElement *elem = (EDDataElement*) [aNotification object];
	[guiController setBackgroundImage:elem];
}

-(void)setGUIResultImage:(NSNotification*)aNotification
{
	
	[guiController setForegroundImage:[aNotification object]];
}

-(void)applicationWillTerminate:(NSNotification*)aNotification
{
	[procedurePipe release];
    [super dealloc];
}

@end
