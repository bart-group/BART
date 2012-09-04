//
//  NEPresentationController.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef BARTNEPRESENTATIONCONTROLLER_H
#define BARTNEPRESENTATIONCONTROLLER_H

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"
#import "NETimetable.h"
#import "COExperimentContext.h"

@class NEPresentationLogger;
@class NELogFormatter;
@class NEViewManager;
@class NEPresentationExternalConditionController;


extern NSString * const BARTPresentationAddedEventsNotification;


/**
 * Controller for handling events and the general flow of the
 * presentation.
 */
@interface NEPresentationController : NSObject <BARTScannerTriggerProtocol, BARTButtonPressProtocol> {
 
    /*
     * the controller instance to check for Conditions of external devices
     */
    NEPresentationExternalConditionController* mExternalConditionController;
    
@private
    /** The view manager for all windows and views. */
    NEViewManager* mViewManager;
    
    /** 
     * A timetable managing all events that will occur during
     * the presentation.
     */
    NETimetable* mTimetable;
    
    /** 
     * Current time of the presentation relative
     * to the beginning of the presentation
     * (in milliseconds).
     */
    NSUInteger mTime;
    /** Trigger counter.  */
    NSUInteger mTriggerCount;
    /** Repetition time (in milliseconds). */
    NSUInteger mTR;
    /** Time the last trigger happened. */
    NSTimeInterval mLastTriggersTime;
    /** Time of the current tick. */
    NSTimeInterval mCurrentTicksTime;
    
    /**
     * All events that are currently happening and about to end
     * any time in the future.
     */
    NSMutableArray* mEventsToEnd;
    
    /** All events that were changed and their replacements. */
    NSMutableArray* mChangedEvents;
    /** Lock for mChangedEvents. */
    NSLock* mLockChangedEvents;
    /** All events that should be added to the runloop. */
    NSMutableArray* mAddedEvents;
    /** Lock for mAddedEvents. */
    NSLock* mLockAddedEvents;
    
    /** Thread in which the actual presentation runs. */ 
    NSThread* mUpdateThread;
    
    /** The logger receiving all presentation log messages. */
    NEPresentationLogger* mLogger;
}

@property (readwrite, retain, setter = setExternalConditions:) NEPresentationExternalConditionController *mExternalConditionController;
@property (readwrite, setter = setTriggerCount:) NSUInteger mTriggerCount;
@property (readwrite, setter = setLastTriggerTime:) NSTimeInterval mLastTriggersTime;

/**
 * Initializes a newly allocated NESceneController object.
 * 
 * \param view          The view manager for all windows and views. 
 * \param timetable     A timetable managing all events that will occur 
 *                      during the presentation.
 * \return              A initialized NESceneController object.
 */
-(id)initWithView:(NEViewManager*)view
     andTimetable:(NETimetable*)timetable;

///**
// * Increases the trigger count of the receiver.
// */
//-(void)trigger;

/**
 * The first call of trigger after preparing the receiver with this
 * method starts the presentation.
 */
-(void)startListeningForTrigger;

/**
 * Pauses an already running presentation.
 */
-(void)pausePresentation;

/**
 * Continues a paused presentation.
 */
-(void)continuePresentation;

/**
 * Resets/stops the presentation.
 * 
 * \param toOriginalEvents If YES: resets the timetable to the events
 *                         it was initialized with (from the EDL file).
 *                         If NO: all added/changed events are kept, 
 *                         just the presentation time is resetted.
 */
-(void)resetPresentationToOriginal:(BOOL)toOriginalEvents;

/**
 * Requests an update of an event.
 * The request is enqueued until the next iteration of
 * the presentation thread runloop and then performed.
 *
 * \param newEvent The updated event to replace oldEvent.
 * \param oldEvent The event that needs to be replaced.
 */
-(void)enqueueEvent:(NEStimEvent*)newEvent
   asReplacementFor:(NEStimEvent*)oldEvent;

/**
 * Requests the construction of an event which is added
 * to the presentation timetable.
 * The request is enqueued until the next iteration of
 * the presentation thread runloop and then performed.
 *
 * \param t   The event time.
 * \param dur The event duration.
 * \param mID The media object ID for the event.
 */
-(void)requestAdditionOfEventWithTime:(NSUInteger)t 
                             duration:(NSUInteger)dur 
                     andMediaObjectID:(NSString*)mID;

///**
// * Requests the removal of an event, which will be
// * active during a given time, from the timetable
// *
// * \param t Any time between the start and end time
// *          of the event 
// */
//-(void)requestRemovalOfEventDuringTime:(NSUInteger)t 
//                     withMediaObjectID:(NSString*)mID;

/**
 * Returns the duration of the presentation.
 *
 * \return Duration of the presentation in milliseconds.
 */
-(NSUInteger)presentationDuration;

@end

#endif // BARTNEPRESENTATIONCONTROLLER_H
