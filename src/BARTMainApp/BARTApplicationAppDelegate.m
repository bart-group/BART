//
//  BARTApplicationAppDelegate.m
//  BARTApplication
//
//  Created by First Last on 11/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BARTApplicationAppDelegate.h"
#import "BAGUIPrototyp.h"
#import "BADesignElementDyn.h"
#import "COSystemConfig.h"


@interface BARTApplicationAppDelegate ()

-(void)newDataDidArrive:(NSNotification*)aNotification;
-(void)analysisStepDidFinish:(NSNotification*)aNotification;

@end


@implementation BARTApplicationAppDelegate

@synthesize window;
@synthesize gui;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{    
    COSystemConfig *config = [COSystemConfig getInstance];
	
	NSError *err = [config fillWithContentsOfEDLFile:@"../../tests/CLETUSTests/timeBasedRegressorLydi.edl"];
	
	if (nil != err){
        NSLog(@"%@", err);
		NSLog(@"Where the hell is the edl file");
	}
	
    gui = [[BAGUIProtoCGLayer alloc] initWithWindow:window];
    [gui initLayers];
	//[gui doPaint];

    procedureController = [[BAProcedureController alloc] init];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(newDataDidArrive:) userInfo:nil repeats:YES];
}

-(void)newDataDidArrive:(NSNotification*)aNotification
{
    [procedureController newDataDidArrive:aNotification];
}

-(void)analysisStepDidFinish:(NSNotification*)aNotification
{
    // TODO: update GUI
}

-(void)dealloc{
    
    [procedureController release];
        
    [super dealloc];    
    
}

@end
