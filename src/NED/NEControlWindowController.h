//
//  NEControlWindowController.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/13/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEStimEvent.h"

@class NEPresentationController;
@class NETimelineWindowController;

/**
 * Controls a xib-Window that provides presentation control
 * elements to the user (PresentationControl.xib).
 */
@interface NEControlWindowController : NSWindowController {
    
    /**
     * Visual control elements (buttons and textfields)
     * referencing objects in PresentationControl.xib.
     */
    IBOutlet NSButton* startButton;
    IBOutlet NSButton* pauseButton;
    IBOutlet NSButton* timeResetButton;
    IBOutlet NSButton* eventResetButton;
    
    IBOutlet NSButton* addStimEventButton;
//    IBOutlet NSButton* removeStimEventButton;
    IBOutlet NSTextField* eventTimeField;
    IBOutlet NSTextField* eventDurationField;
    IBOutlet NSTextField* eventMediaObjectIDField;
    
    IBOutlet NSTextField* warningMessageLabel;
    
    IBOutlet NSButton* checkBoxStimulation;
    
    /** 
     * Duration of the presentation.
     * Needed for warning when trying to add an event
     * whose duration exceeds the presentationDuration.
     */
    NSUInteger presentationDuration;
    
    /**
     * The presentation controller managing the presentation.
     * All user interactions are requested to be performed by
     * this controller at the next appropriate time.
     */
    NEPresentationController* presentationController;
    
    /**
     * The controller managing the timeline window where the
     * user can manipulate single events and gets a general
     * overview of the presentation flow.
     */
    NETimelineWindowController* timelineWindowController;
    
    
    /**
     * Used to simulate the trigger.
     */
    NSUInteger mTriggerCount;
    NSThread* mTriggerThread;
    BOOL mIsPaused;
}

@property (readwrite) BOOL stimulationMode;

/**
 * Sets the presentation controller that incooperates all
 * user interactions in the presentation flow.
 *
 * \param presController The presentation controller to set.
 */
-(void)setPresentationController:(NEPresentationController *)presController;

/**
 * Sets the controller managing the timeline window where all
 * events are shown and can be manipulated by the user.
 *
 * \param tmlnWindowController The timeline window controller to set.
 */
-(void)setTimelineWindowController:(NETimelineWindowController*)tmlnWindowController;

/**
 * Invoked when startButton is pressed (starts the presentation).
 *
 * \param sender The sender of the action.
 */
-(IBAction)startPresentation:(id)sender;

/**
 * Invoked when pauseButton is pressed. Toggles to continue when
 * presentation is paused and vice versa (pauses/continues
 * presentation).
 *
 * \param sender The sender of the action.
 */
-(IBAction)pausePresentation:(id)sender;

/**
 * Invoked when resetButton is pressed (resets the presentation
 * to its original state).
 *
 * \param sender The sender of the action.
 */
-(IBAction)resetPresentation:(id)sender;

/**
 * Requests the addition of a stimulus event created from
 * primitive values (time, duration and media object ID
 * textfield values) at the presentation controller.
 *
 * \param sender The sender of the action.
 */
-(IBAction)addStimulusEvent:(id)sender;

///**
// * Requests the removal of one or more stimulus events
// * at the presentation controller based on the parameters 
// * in the textfields (time, duration and media object ID).
// *
// * \param sender The sender of the action.
// */
//-(IBAction)removeStimulusEvent:(id)sender;

/**
 * Displays the information about one event (time, duration
 * and media object ID) in the appropriate textfields.
 *
 * \param event The event whose attributes should be displayed.
 *              If nil is passed all textfields are cleared.
 */
-(void)showEvent:(NEStimEvent*)event;

@end
