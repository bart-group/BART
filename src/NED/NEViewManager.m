//
//  NEViewManager.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEViewManager.h"
#import "NEControlWindowController.h"
#import "NETimelineView.h"
#import "NETimelineWindowController.h"
#import "COSystemConfig.h"
#import "NEPresentationView.h"
#import "NEPresentationController.h"
#import "NEFeedbackObject.h"


@interface NEViewManager (PrivateMethods)

/**
 * Initializes and places the control window.
 */
-(void)setupControlWindow;

/**
 * Initializes and places the timeline window.
 * Also creates all associated views and builds
 * the view hierarchy.
 */
-(void)setupTimelineWindow;

/**
 * Initializes and places the presentation window.
 * Also creates all associated views and builds
 * the view hierarchy.
 */
-(void)setupPresentationWindow;

@end


@implementation NEViewManager

-(id)init
{
    if ((self = [super init])) {
        NSArray* screens = [NSScreen screens];
        mPrimaryScreen = [screens objectAtIndex:0];
        
        if ([screens count] >= 2) {
            mSecondaryScreen = [screens objectAtIndex:1];
        } else {
            mSecondaryScreen = nil;
        }

        [self setupControlWindow];
        [self setupTimelineWindow];
        [self setupPresentationWindow];
        
        [mControlWindowController setTimelineWindowController:mTimelineWindowController];
        [mTimelineWindowController setControlWindowController:mControlWindowController];
    }
    
    return self;
}

-(void)setupControlWindow
{
    mControlWindowController = [[NEControlWindowController alloc] initWithWindowNibName:@"PresentationControl"];
    mControlWindow = [mControlWindowController window];
    
    [mControlWindow setStyleMask:(NSTitledWindowMask
                                  | NSMiniaturizableWindowMask
                                  | NSResizableWindowMask)];
    [mControlWindow setMovableByWindowBackground:YES];
    
    // Position the control window into the upper right corner.
    NSRect controlWindowFrame = [mControlWindow frame];
    NSSize primaryScreenSize  = [mPrimaryScreen frame].size;
    
    controlWindowFrame.origin.x = primaryScreenSize.width  - controlWindowFrame.size.width;
    controlWindowFrame.origin.y = primaryScreenSize.height - controlWindowFrame.size.height;
    
    [mControlWindow setFrame:controlWindowFrame display:NO animate:NO];
}

-(void)setupTimelineWindow
{
    NSRect timelineWindowFrame = [mPrimaryScreen frame];
    timelineWindowFrame.size.height = 0.0; // The actual height is set 
    
    NSRect timelineWindowContentRect = [NSWindow contentRectForFrameRect:timelineWindowFrame 
                                                               styleMask:(NSTitledWindowMask
                                                                          | NSMiniaturizableWindowMask
                                                                          | NSResizableWindowMask)];
    
    mTimelineWindow = [[NSWindow alloc] initWithContentRect:timelineWindowContentRect 
                                                  styleMask:(NSTitledWindowMask
                                                             | NSMiniaturizableWindowMask
                                                             | NSResizableWindowMask) 
                                                    backing:NSBackingStoreBuffered 
                                                      defer:YES
                                                     screen:mPrimaryScreen];
    [mTimelineWindow setTitle:@"Timeline"];
    
    // Creating ScrollView for the timeline window and adding it to the view hierarchy.
    mTimelineScrollView = [[NSScrollView alloc] initWithFrame:[[mTimelineWindow contentView] bounds]];
    [mTimelineScrollView setHasVerticalScroller:YES];
    [mTimelineScrollView setHasHorizontalScroller:YES];
    [mTimelineScrollView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [[mTimelineWindow contentView] addSubview:mTimelineScrollView];
    
    // Creating the NETimelineView object an set it as the ScrollView's document view.
    NSRect timelineViewRect = [[mTimelineScrollView contentView] frame];
    mTimelineView = [[NETimelineView alloc] initWithFrame:timelineViewRect];
    [mTimelineView setBounds:timelineViewRect];
    [mTimelineScrollView setDocumentView:mTimelineView];
    
    mTimelineWindowController = [[NETimelineWindowController alloc] initWithWindow:mTimelineWindow];
}

-(void)setupPresentationWindow
{
    COSystemConfig* config = [COSystemConfig getInstance];
    NSRect presentationViewRect = NSMakeRect(0.0, 
                                             0.0, 
                                             [[config getProp:@"/rtExperiment/stimulusData/stimEnvironment/screen/screenResolutionX"] floatValue], 
                                             [[config getProp:@"/rtExperiment/stimulusData/stimEnvironment/screen/screenResolutionY"] floatValue]);
    
    // Setting up the presentation window (for the experimenter) and position it in the upper left corner.
    mPresentationWindow = [[NSWindow alloc] initWithContentRect:presentationViewRect 
                                                      styleMask:0 
                                                        backing:NSBackingStoreBuffered 
                                                          defer:YES
                                                         screen:mPrimaryScreen];
    [mPresentationWindow setMovableByWindowBackground:YES];
    CGFloat primaryScreenHeight  = [mPrimaryScreen frame].size.height;
    NSRect presentationWindowFrame = NSMakeRect(0.0, 
                                                primaryScreenHeight - presentationViewRect.size.height, 
                                                presentationViewRect.size.width, 
                                                presentationViewRect.size.height);
    [mPresentationWindow setFrame:presentationWindowFrame display:NO animate:NO];
    
    // PresentationView that will be contained in the presentation window.
    mPresentationView = [[NEPresentationView alloc] initWithFrame:presentationViewRect];
    [[mPresentationWindow contentView] addSubview:mPresentationView];
    
    // Window controller for displaying the presentation window.
    mPresentationWindowController = [[NSWindowController alloc] initWithWindow:mPresentationWindow];
    
    // If a second screen/monitor is availiable, use it for fullscreen presentation.
//    mFullScreenPresentationView = nil;
//    if (mSecondaryScreen) {
//        mFullScreenPresentationView = [[NSView alloc] initWithFrame:presentationViewRect];
//        [mFullScreenPresentationView addSubview:mPresentationView];
//
//        NSDictionary* fullScreenOptions = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           [NSNumber numberWithBool:NO], NSFullScreenModeAllScreens,
//                                           nil];
//        [mPresentationView enterFullScreenMode:mSecondaryScreen withOptions:fullScreenOptions];
//    }
}

-(void)dealloc
{
//    if (mFullScreenPresentationView) {
//        [mFullScreenPresentationView release];
//    }
    
    [mPresentationWindowController release];
    [mPresentationView release];
    [mPresentationWindow release];
    
    [mTimelineView release];
    [mTimelineScrollView release];
    [mTimelineWindowController release];
    [mTimelineWindow release];
    
    [mControlWindowController release];
    
    [super dealloc];
}

-(void)setTimetable:(NETimetable*)timetable
{
    [mTimelineView setTimetable:timetable];
    
    // Determine and set max content size of the timeline window.
    NSSize timelineViewSize = [mTimelineView bounds].size;
    CGFloat horizontalScrollerHeight = [[mTimelineScrollView horizontalScroller] frame].size.height;
    CGFloat verticalScrollerWidth    = [[mTimelineScrollView verticalScroller] frame].size.width;
    
    NSSize timelineWindowContentMaxSize;
    timelineWindowContentMaxSize.width  = timelineViewSize.width + verticalScrollerWidth;
    timelineWindowContentMaxSize.height = timelineViewSize.height + horizontalScrollerHeight;
    [mTimelineWindow setContentMaxSize:timelineWindowContentMaxSize];

    // Adjust current frame of the timeline window.
    NSRect timelineWindowContentRect;
    timelineWindowContentRect.origin = [mTimelineWindow frame].origin;
    timelineWindowContentRect.size = timelineWindowContentMaxSize;
    
    NSRect newTimelineWindowFrame = [mTimelineWindow frameRectForContentRect:timelineWindowContentRect];
    if ([mPresentationWindow frame].origin.y < newTimelineWindowFrame.size.height) {
        newTimelineWindowFrame.size.height = [mPresentationWindow frame].origin.y;
    }
    
    [mTimelineWindow setFrame:newTimelineWindowFrame display:NO];
}

-(void)setController:(NEPresentationController*)presController
{
    mPresentationController = presController;
    [mControlWindowController setPresentationController:presController];
    [mTimelineWindowController setPresentationController:presController];
}

-(IBAction)showAllWindows:(id)sender
{
    [mPresentationWindowController showWindow:sender];
    [mTimelineWindowController showWindow:sender];
    [mControlWindowController showWindow:sender];
}

-(void)displayPresentationView
{
    if ([mPresentationView needsDisplay]) {
        [mPresentationView display];
    }
}

-(void)updateTimeline
{
    [mTimelineView setNeedsDisplay:YES];
}

-(void)setCurrentTime:(NSUInteger)newCurrentTime
{
    [mTimelineView setCurrentTime:newCurrentTime];
}

-(void)pausePresentation
{
    [mPresentationView pausePresentation];
}

-(void)continuePresentation
{
    [mPresentationView continuePresentation];
}

-(void)resetPresentation
{
    [mPresentationView removeAllMediaObjects];
    [mTimelineView setCurrentTime:0];
}

-(void)present:(NEMediaObject*)mediaObj
{
    [mPresentationView addMediaObject:mediaObj];
}

-(void)stopPresentationOf:(NEMediaObject*)mediaObj
{
    [mPresentationView removeMediaObject:mediaObj];
}

-(void)setFeedback:(NEFeedbackObject*)feedbackObj
{
    [mPresentationView setFeedback:feedbackObj];
}

@end
