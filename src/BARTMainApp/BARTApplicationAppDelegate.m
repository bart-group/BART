//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/12/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"

#import "../CLETUS/COSystemConfig.h"
#import "BAProcedureController.h"
#import "BARTNotifications.h"


@interface BARTApplicationAppDelegate ()
BAProcedureController *procController;
-(void)setGUIBackgroundImage:(NSNotification*)aNotification;
-(void)setGUIResultImage:(NSNotification*)aNotification;

@end


@implementation BARTApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{    
    COSystemConfig *config = [COSystemConfig getInstance];
	NSError *err = [config fillWithContentsOfEDLFile:@"/Users/Lydi/Development/BARTProcedure/BARTApplication/trunk/tests/NEDTests/prrofOfConcept_motor_LongBlocks.edl"];
	
	if (err) {
        NSLog(@"%@", err);
	}
	guiController = [guiController initWithDefault];
	
    procController = [[BAProcedureController alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIBackgroundImage:)
												 name:BARTDidLoadBackgroundImageNotification object:nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setGUIResultImage:)
												 name:BARTDidCalcNextResultNotification object:nil];
	[procController initData];
	[procController initDesign];
	[procController initAnalyzer];
	[procController startAnalysis];
	
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
	[procController release];
    [super dealloc];
}

@end
