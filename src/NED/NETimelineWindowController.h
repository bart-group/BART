//
//  NETimelineWindowController.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/14/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef BARTNETIMELINEWINDOWCONTROLLER_H
#define BARTNETIMELINEWINDOWCONTROLLER_H

#import <Cocoa/Cocoa.h>
#import "NETimelineView.h"

@class NEPresentationController;
@class NEControlWindowController;

/**
 * Controls a xib-window containing NETimelineView object
 * (PresentationTimeline.xib).
 */
@interface NETimelineWindowController : NSWindowController {
    
    /**
     * The scroll view contained in the window managed by
     * this NETimelineWindowController (self).
     */
    IBOutlet NSScrollView* scrollView;
    
    /**
     * The timeline view contained in scrollView.
     */
    NETimelineView* timelineView;

    /**
     * The presentation controller managing the presentation.
     * All user interactions are requested to be performed by
     * this controller at the next appropriate time.
     */
    NEPresentationController* presentationController;
    
    /**
     * The controller managing the control window where the
     * user can manipulate the general flow/state of the 
     * presentation.
     */
    NEControlWindowController* controlWindowController;
    
}

@property (readonly) NETimelineView* timelineView;

/**
 * Sets the presentation controller that incooperates all
 * user interactions in the presentation flow.
 *
 * \param presController The presentation controller to set.
 */
-(void)setPresentationController:(NEPresentationController*)presController;

/**
 * Sets the controller managing the control window where the user
 * can manipulate the general flow/state of the presentation.
 *
 * \param ctrlWindowController The control window controller to set.
 */
-(void)setControlWindowController:(NEControlWindowController*)ctrlWindowController;

/**
 * Requests a replacement of an event with a newer one at
 * the presentation controller.
 *
 * \param toReplace   Outdated event that is replaced by replacement.
 * \param replacement Updated event that replaces toReplace.
 */
-(void)replaceEvent:(NEStimEvent*)toReplace
          withEvent:(NEStimEvent*)replacement;

/**
 * Requests the display of an event in the textfields of the control
 * window managed by the control window controller (which must be
 * acknowledged to the receiver previously by invoking 
 * setControlWindowController:)
 *
 * \param toShow The stimulus event that should be shown in the
 *               control window's textfields.
 */
-(void)showEventInControlWindow:(NEStimEvent*)toShow;

/**
 * Calls clearSelection of the timeline view contained in
 * the window managed by the receiver.
 */
-(void)clearSelection;

@end

#endif // BARTNETIMELINEWINDOWCONTROLLER_H