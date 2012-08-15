//
//  NEPresentationControlView.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NETIMELINEVIEW_H
#define NETIMELINEVIEW_H

#import <Cocoa/Cocoa.h>
#import "NEStimEvent.h"
#import "NETimetable.h"


/** 
 * The spot where the graphical representation of a 
 * NEStimEvent (a colored rectangle) was clicked/grabbed.
 */
enum NEGrabSpot {
    NOT_GRABBED = 0,
    LOWERWEST_GRABBED,
    MIDCENTER_GRABBED,
    UPPEREAST_GRABBED
};

/**
 * Represents a timeline overview panel displaying all past, current and future
 * events as bars in a 2-dimensional diagram.
 */
@interface NETimelineView : NSControl {
    
    /** 
     * A timetable containing all events that did/will occur during
     * the presentation.
     */
    NETimetable* mTimetable;
    
    /** Current time in the timeline. */
    NSUInteger mCurrentTime;

    /** Event that is currently selected by the user. */
    NEStimEvent* selectedEvent;
    
    /** 
     * y-Coordinate of the lower edge of the currently
     * selected event bar. 
     */
    CGFloat mSelectedEventBarY;
    
    /**
     * Rectangle representing the dragging square in
     * the lower west corner of the currently selected 
     * event.
     */
    NSRect mLowerWestSquare;
    
    /**
     * Rectangle representing the dragging square in
     * the middle/center of the currently selected event.
     */
    NSRect mMidCenterSquare;
    
    /**
     * Rectangle representing the dragging square in
     * the upper east corner of the currently selected
     * event.
     */
    NSRect mUpperEastSquare;
    
    /**
     * Indicates the spot where the currently selected
     * event was grabbed (lower west, middle/center
     * or upper east) if it was grabbed at all. 
     */
    enum NEGrabSpot mGrabbedAt;
    
    /** 
     * Point where the left mouse button was pressed/
     * the dragging started.
     */
    NSPoint mMouseDownPoint;
    
    /**
     * Point where the left mouse button was released/
     * the dragging ended.
     */
    NSPoint mMouseUpPoint;
}

@property (readonly) NEStimEvent* selectedEvent;

/**
 * Sets the NETimetable object that contains the event
 * information needed for displaying all events in a graph.
 *
 * \param timetable The timetable containing all events.
 */
-(void)setTimetable:(NETimetable*)timetable;

/**
 * Sets the current time of the timeline panel (giving the 
 * view information about where to position the vertical red line
 * representing the current time).
 * Results in a redraws of the timeline panel.
 *
 * \param newCurrentTime The new time that should be displayed in 
 *                       the timeline panel.
 */
-(void)setCurrentTime:(NSUInteger)newCurrentTime;

/**
 * Unselects the currently selected event;
 */
-(void)clearSelection;


@end

#endif //NETIMELINEVIEW_H
