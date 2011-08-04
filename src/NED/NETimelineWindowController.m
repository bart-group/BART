//
//  NETimelineWindowController.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/14/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NETimelineWindowController.h"
#import "NEPresentationController.h"
#import "NEControlWindowController.h"


@implementation NETimelineWindowController

@synthesize timelineView;

-(id)initWithWindowNibName:(NSString *)windowNibName
{
    if (self = [super initWithWindowNibName:windowNibName]) {
        timelineView = [[NETimelineView alloc] initWithFrame:[[self window] frame]];
        [scrollView setDocumentView:timelineView];
    }
    
    return self;
}

-(void)dealloc
{
    [timelineView release];
    [super dealloc];
}

-(void)setPresentationController:(NEPresentationController *)presController
{
    presentationController = presController;
}

-(void)setControlWindowController:(NEControlWindowController*)ctrlWindowController
{
    controlWindowController = ctrlWindowController;
}

-(void)replaceEvent:(NEStimEvent*)toReplace
          withEvent:(NEStimEvent*)replacement
{
    if (presentationController) {
        [presentationController enqueueEvent:replacement
                            asReplacementFor:toReplace];
    }
}

-(void)showEventInControlWindow:(NEStimEvent*)toShow
{
    if (controlWindowController) {
        [controlWindowController showEvent:toShow];
    }
}

-(void)clearSelection
{
    [timelineView clearSelection];
}

@end
