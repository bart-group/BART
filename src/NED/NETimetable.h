//
//  NETimetable.h
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/16/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NEMediaObject.h"
#import "NEStimEvent.h"


/** 
 * A timetable managing all events that will occur during
 * the presentation.
 */
@interface NETimetable : NSObject {
    
    /**
     * All NEMediaObjects that are used for the
     * presentation events.
     */
    NSArray* mediaObjects;
    
    /**
     * The IDs of all media objects (keys of the event dictionary).
     * Hold redundant for better key quering from multiple threads.
     */
    NSArray* mediaObjectIDs;
    
    /**
     * All events how they were originally configured
     * in EDL.
     * Key:   media object ID.
     * Value: NSMutableArrays containing all NEStimEvents
     *        for that particular media object ordered by 
     *        their time property.
     */
    NSMutableDictionary* mOriginalEvents;
    
    /**
     * All events that are about to happen including those
     * which were added or manipulated by the user.
     */
    NSMutableDictionary* mEventsToHappen;
    
    /**
     * All events that happened.
     */
    NSMutableDictionary* mHappenedEvents;
    
    /**
     * Duration of the presentation according to the event
     * with the highest end time 
     * (end time = [event time] + [event duration]).
     */
    NSUInteger    duration;
    
    /**
     * Number of media objects (number of elements in
     * mediaObjects).
     */
    NSUInteger    numberOfMediaObjects;
    
    /** Lock for synchronized access to the timetable. */
    NSLock* mLock;
    
}

@property (readonly) NSArray* mediaObjects;
@property (readonly) NSUInteger duration;
@property (readonly) NSUInteger numberOfMediaObjects;

/**
 * Initializes a newly allocated NETimetable instance with
 * configuration data originating from an EDL file and an
 * array of NEMediaObjects.
 *
 * \param key       The configuration key referencing the
 *                  EDL timetable data.
 * \param mediaObjs An array of NEMediaObjects that are
 *                  referenced in the stimulus events.
 * \return          The fully initialized and usable receiver.
 */
-(id)initWithConfigEntry:(NSString*)key
         andMediaObjects:(NSArray*)mediaObjs;

/**
 * Returns the first event that could happen at a given time.
 * The returned event is then consumed and not returned again
 * for subsequent invocations with the same time. If multiple
 * events happen at the same time: for each invocation a different
 * one is returned and consumed until there is none left.
 *
 * \param time The time at which to search for an event.
 * \return     A NEStimEvent that is about to happen at time.
 *             Nil if there is none.
 */
-(NEStimEvent*)nextEventAtTime:(NSUInteger)time;

/**
 * Returns the first event that could happen at a given time.
 *
 * \param time The time at which to search for an event.
 * \return     A NEStimEvent that is about to happen at time.
 *             Nil if there is none.
 */
-(NEStimEvent*)previewNextEventAtTime:(NSUInteger)time;

/**
 * Returns all media object IDs in no particular order.
 *
 * \return An array of NSStrings representing the media
 *         object IDs.
 */
-(NSArray*)getAllMediaObjectIDs;

/**
 * Returns all happened events for one media object ID ordered
 * by the time they happened.
 *
 * \param mediaObjID ID of the media object that all requested 
 *                   events should have in common.
 * \return           All happened events that are associated with 
 *                   mediaObjID.
 */
-(NSArray*)happenedEventsForMediaObjectID:(NSString*)mediaObjID;


/**
 * Returns all events that are about to happen for one media 
 * object ID ordered by the time they happened.
 *
 * \param mediaObjID ID of the media object that all requested 
 *                   events should have in common.
 * \return           All future events that are associated with 
 *                   mediaObjID.
 */
-(NSArray*)eventsToHappenForMediaObjectID:(NSString*)mediaObjID;

/**
 * Shifts the onset time for all events that are about to happen 
 * for the given time in ms
 *
 * \param shift     the time in ms all upcoming onsets shall be shifted
 * 
 */
-(void)shiftOnsetForAllEventsToHappen:(NSUInteger)shift;


/**
 * Adds an NEStimEvent to the timetable (reciever).
 * 
 * \param event The event to add.
 */
-(void)addEvent:(NEStimEvent*)event;

/**
 * Replaces a stimulus event that happens at some time in
 * the future with an other event.
 *
 * \param toReplace   The NEStimEvent that needs to be replaced.
 * \param replacement The NEStimEvent replacing toReplace.
 */
-(void)replaceEvent:(NEStimEvent*)toReplace
          withEvent:(NEStimEvent*)replacement;

/**
 * Resets the timetable to only the events it was initialized
 * with (it constructed from the EDL configuration entry).
 */
-(void)resetTimetableToOriginalEvents;

/**
 * Resets the timetable. So all events that already happened can
 * happened again. Does NOT reset to the original events it
 * was initialized with. So all events that were changed/added
 * are still available.
 */
-(void)resetTimetable;

@end
