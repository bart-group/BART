//
//  NEViewManager.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NEVIEWMANAGER_H
#define NEVIEWMANAGER_H

#import <Cocoa/Cocoa.h>


@class NEPresentationView;
@class NETimelineWindowController;
@class NETimelineView;
@class NEControlWindowController;
@class NEFeedbackObject;

@class NETimetable;
@class NEPresentationController;

@class NEMediaObject;


/**
 * Manages all view objects. Also offers a facade for all view actions
 * important to the rest of the application (primarily the 
 * presentation controller).
 */
@interface NEViewManager : NSObject {
    
    /** The primary screen for all windows. */
    NSScreen* mPrimaryScreen;
    /** The secondary screen for fullscreen presentation. */
    NSScreen* mSecondaryScreen;
    
    /** 
     * The window containing the presentation view for the 
     * experimenter.
     */
    NSWindow* mPresentationWindow;
    /** WindowController for mPresentationWindow. */
    NSWindowController* mPresentationWindowController;
    /** 
     * PresentationView for the experimenter shown in 
     * mPresentationWindow.
     */
    NEPresentationView* mPresentationView;
    
    
    /** Window containing the timeline view. */
    NSWindow* mTimelineWindow;
    /** WindowController for mTimelineWindow. */
    NETimelineWindowController* mTimelineWindowController;
    
    /** 
     * ScrollView used for clipping and scrolling
     * the timeline view.
     */
    NSScrollView* mTimelineScrollView;
    /**
     * View contained in the timeline window. Shows
     * all presentation events on a timeline.
     */
    NETimelineView* mTimelineView;

    /** 
     * Window containing all the presentation controls
     * (e.g. start button, form for adding events...)
     */
    NSWindow* mControlWindow;
    /** WindowController for mControlWindow. */
    NEControlWindowController* mControlWindowController;
    
    /** 
     * Main controller for handling presentation events
     * and the general presentation flow.
     */
    NEPresentationController* mPresentationController;
}

/**
 * Sets the NETimetable object that contains the event
 * information needed for displaying all events in a graph.
 *
 * \param timetable The timetable containing all events.
 */
-(void)setTimetable:(NETimetable*)timetable;

/**
 * Sets the presentation controller that incooperates all
 * user interactions in the presentation flow.
 *
 * \param presController The presentation controller to set.
 */
-(void)setController:(NEPresentationController*)presController;

/**
 * Shows all windows managed by the receiver.
 *
 * \param sender Sender of the
 */
-(IBAction)showAllWindows:(id)sender;

/**
 * Immediately displays/redraws the presentation view if
 * needed.
 */
-(void)displayPresentationView;

/**
 * Updates the timeline view.
 */
-(void)updateTimeline;

/**
 * Sets the current time of the timeline view.
 *
 * \param newCurrentTime The new time that should be displayed 
 *                       in the timeline view.
 */
-(void)setCurrentTime:(NSUInteger)newCurrentTime;

/**
 * Pauses the playback of all currently active
 * continuous media (audio/video).
 */
-(void)pausePresentation;

/**
 * Continues the playback of all currently paused
 * continuous media (audio/video).
 */
-(void)continuePresentation;

/**
 * Resets the presentation (clears the presentation view
 * and sets the timeline view time back to 0 milliseconds).
 */
-(void)resetPresentation;

/**
 * Starts the presentation of a NEMediaObject.
 * 
 * \param mediaObj The NEMediaObj to present.
 */
-(void)present:(NEMediaObject*)mediaObj;

/**
 * Ends the presentation of a NEMediaObject.
 *
 * \param mediaObj The NEMediaObject whose presentation
 *                 should end.
 */
-(void)stopPresentationOf:(NEMediaObject*)mediaObj;

/**
 * Acknowledges a feedback object to the presentation view.
 * Removes the currently active feedback object if necessary. 
 *
 * \param feedbackObj The NEFeedbackObject to set. Pass nil
 *                    to remove the current feedback object.
 */
-(void)setFeedback:(NEFeedbackObject*)feedbackObj;

@end

#endif //NEVIEWMANAGER_H
