//
//  NEPresentationEvent.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#ifndef NESTIMEVENT_H
#define NESTIMEVENT_H

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"
#import "NEDesignElement.h"

/**
 * Represents a stimulus event in the presentation.
 */
@interface NEStimEvent : NSObject {
}
/**
 * Time at which the event should occur (relative to
 * beginning of the presentation).
 */
@property (readwrite, getter = time, setter = setTime:) NSUInteger mOnsetTime;
/**
 * Duration of the event.
 */
@property (readwrite, getter = duration, setter = setDuration:) NSUInteger mDuration;
/**
 * NEMediaObject that should be presented or hidden.
 */
@property (retain, getter = mediaObject) NEMediaObject* mMediaObject;
/*
 * Flag if event already previewed
 */
@property (readwrite, getter = isPreviewed, setter = setPreviewed:) BOOL isPreviewed;

/**
 * Initializes a NEPresentationEvent object.
 *
 * \param t   Time of the event in milliseconds (relative to beginning of the presentation).
 * \param dur Duration of the event. Irrelevant for end events (any NSUInteger number can be 
 *               passed in this case - duration will always be set to zero).
 * \param obj A media object that should be presented on or removed from the scene.
 */
-(id)initWithTime:(NSUInteger)t 
         duration:(NSUInteger)dur
      mediaObject:(NEMediaObject*)obj;

/*
 * creates a trial from this event via a the regressor assignment function
 * 
 * \return the new created Trial that can be used for the design matrix
 */
-(Trial)createTrialFromThis;

/**
 * Utility method.
 * Inserts a single event into the chronically sorted eventList
 * (sorted after time).
 *
 * \param event     Event that should be inserted
 * \param eventList Sorted event list.
 */
+(void)startTimeSortedInsertOf:(NEStimEvent*)event
                   inEventList:(NSMutableArray*)eventList;

/**
 * Utility method.
 * Inserts a single event into the chronically sorted eventList
 * (sorted end time = time + duration).
 *
 * \param event     Event that should be inserted
 * \param eventList Sorted event list.
 */
+(void)endTimeSortedInsertOf:(NEStimEvent*)event
                 inEventList:(NSMutableArray*)eventList;

@end

#endif //NESTIMEVENT_H