//
//  NEPresentationEvent.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"


/**
 * Represents a stimulus event in the presentation.
 */
@interface NEStimEvent : NSObject {
    
    /**
     * Time at which the event should occur (relative to 
     * beginning of the presentation).
     */
    NSUInteger time;
    
    /**
     * Duration of the event.
     */
    NSUInteger duration;
    
    /**
     * NEMediaObject that should be presented or hidden.
     */
    NEMediaObject* mediaObject;

}

@property (readwrite) NSUInteger time;
@property (readwrite) NSUInteger duration;
@property (retain) NEMediaObject* mediaObject;

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
