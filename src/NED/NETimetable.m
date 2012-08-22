//
//  NETimetable.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/16/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NETimetable.h"
#import "COExperimentContext.h"


@interface NETimetable (PrivateMethods)

/**
 * Helper method for initWithConfigEntry:andMediaObjects:.
 * Does the actual constructing of the NEStimEvents from
 * the EDL configuration and puts those into mEventsToHappen.
 *
 * \param key       The configuration key referencing the
 *                  EDL timetable data.
 */
-(void)buildEventsForTimetable:(NSString*)key;

/**
 * Removes masked events from a time-sorted array of NEStimEvent
 * objects.
 * The array must not contain any masked events before the
 * parameter event was inserted.
 *
 * \param eventList The mutable Array that may contain masked
 *                  events due to a recent addition of an event.
 * \param event     The last event that was added to eventList
 *                  and that might mask events.
 */
-(void)removeMaskedEventsIn:(NSMutableArray*)eventList
                 startingAt:(NEStimEvent*)event;

@end


@implementation NETimetable

@synthesize mediaObjects = _mediaObjects;
@synthesize duration = _duration;
@synthesize numberOfMediaObjects = _numberOfMediaObjects;
//@synthesize dictMediaObjects;

dispatch_queue_t serialAccessQueueTimetable;


-(id)initWithConfigEntry:(NSString*)key
         andMediaObjects:(NSArray*)mediaObjs
{
    if ((self = [super init])) {
        
        serialAccessQueueTimetable = dispatch_queue_create("de.mpg.cbs.NETimetableSerialAccessQueue", DISPATCH_QUEUE_SERIAL);
        
        
        _mediaObjects         = [mediaObjs retain];
        _duration             = 0;
        _numberOfMediaObjects = [mediaObjs count];
        mediaObjectIDs       = [NSArray array];
        mEventsToHappen      = [[NSMutableDictionary alloc] initWithCapacity:0];
        mHappenedEvents      = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        /********/
        NSMutableDictionary *dictMO = [[NSMutableDictionary alloc] initWithCapacity:_numberOfMediaObjects];
        
        /********/
        for (NEMediaObject* mObj in _mediaObjects) {
            mediaObjectIDs = [mediaObjectIDs arrayByAddingObject:[mObj getID]];
            [mEventsToHappen setObject:[NSMutableArray arrayWithCapacity:1] forKey:[mObj getID]];
            [mHappenedEvents setObject:[NSMutableArray arrayWithCapacity:1] forKey:[mObj getID]];
            /********/
            [dictMO setValue:mObj forKey:[mObj getID]];
            
            /********/
        }
        [mediaObjectIDs retain];
        /********/
        dictMediaObjects = [[NSDictionary alloc] initWithDictionary:dictMO];
        [dictMO release];
        
        /********/
        
        [self buildEventsForTimetable:key];
        
        mOriginalEvents      = [mEventsToHappen mutableCopy];
        for (NSString* key in [mOriginalEvents allKeys]) {
            [mOriginalEvents setValue:[[[mEventsToHappen objectForKey:key] mutableCopy] autorelease] forKey:key];
        }
    }
    
    return self;
}

-(void)dealloc
{
    
    [_mediaObjects release];
    [mediaObjectIDs release];
    [mEventsToHappen release];
    [mHappenedEvents release];
    [mOriginalEvents release];
    dispatch_release(serialAccessQueueTimetable);
    
    [super dealloc];
}

-(void)buildEventsForTimetable:(NSString*)key
{
    NSUInteger repeats;
    NSString* stimDesignKey = [key stringByAppendingFormat:@"/blockStimulusDesign"];
    
    // Determine whether block or free stimulus design is used.
    if ([[[COExperimentContext getInstance] systemConfig] getProp:stimDesignKey]) {
        repeats = [[[[COExperimentContext getInstance] systemConfig] getProp:[stimDesignKey stringByAppendingFormat:@"/@repeats"]] integerValue];
    } else {
        stimDesignKey       = [key stringByAppendingFormat:@"/freeStimulusDesign"];
        repeats = 1;
    }
    _duration = [[[[COExperimentContext getInstance] systemConfig] getProp:[stimDesignKey stringByAppendingFormat:@"/@overallPresLength"]] integerValue];
    
    NSUInteger eventCounter  = 1;
    NSString* eventKey  = [stimDesignKey stringByAppendingFormat:@"/stimEvent[1]"];
    NSString* eventProp = [[[COExperimentContext getInstance] systemConfig] getProp:eventKey];
    NSUInteger repeatCounter = 1;
    NSUInteger timeOffset = 0;
    NSUInteger blockDuration = 0;
    
    // Build events - also the repeated ones.
    while ((repeatCounter <= repeats)
           && (eventProp != nil)) {
        NSUInteger eventTime     = [[[[COExperimentContext getInstance] systemConfig] getProp:[NSString stringWithFormat:@"%@/@time", eventKey]] integerValue];
        NSUInteger eventDuration = [[[[COExperimentContext getInstance] systemConfig] getProp:[NSString stringWithFormat:@"%@/@duration", eventKey]] integerValue];
        NSString*  mediaObjID    = [[[COExperimentContext getInstance] systemConfig] getProp:[NSString stringWithFormat:@"%@/mObjectID", eventKey]];
        
        if (repeatCounter == 1
            && (eventTime + eventDuration) > blockDuration) {
            blockDuration = eventTime + eventDuration;
        }
        
        for (NEMediaObject* obj in _mediaObjects) {
            if ([[obj getID] compare:mediaObjID] == 0) {
                NEStimEvent* event = [[NEStimEvent alloc] initWithTime:(((repeatCounter - 1) * timeOffset) + eventTime)
                                                              duration:eventDuration
                                                           mediaObject:obj];
                
                [NEStimEvent startTimeSortedInsertOf:event inEventList:[mEventsToHappen objectForKey:mediaObjID]];
                [event release];
            }
        }
        
        eventCounter++;
        eventKey = [stimDesignKey stringByAppendingFormat:@"/stimEvent[%ld]", eventCounter];
        eventProp = [[[COExperimentContext getInstance] systemConfig] getProp:eventKey];
        
        // Check for block repeat or outro stimuli if current eventProp is nil.
        if (!eventProp) {
            if (repeatCounter <= repeats) {
                if (repeatCounter == 1) {
                    timeOffset = blockDuration;
                }
                repeatCounter++;
                eventCounter = 1;
                eventKey  = [stimDesignKey stringByAppendingFormat:@"/stimEvent[1]"];
                eventProp = [[[COExperimentContext getInstance] systemConfig] getProp:eventKey];
            } else {
                eventKey  = [key stringByAppendingFormat:@"/outro/stimEvent[1]"];
                eventProp = [[[COExperimentContext getInstance] systemConfig] getProp:eventKey];
            }
        }
    }
}

-(NEStimEvent*)previewNextEventAtTime:(NSUInteger)time
{
    __block NEStimEvent* retEvent = nil;
    dispatch_sync(serialAccessQueueTimetable, ^{
        for (NSString* mediaObjectID in mediaObjectIDs) {
            NSMutableArray* eventsForMediaObject = [mEventsToHappen objectForKey:mediaObjectID];
            if ([eventsForMediaObject count] > 0) {
                
                NEStimEvent* event = [eventsForMediaObject objectAtIndex:0];
                if ( ([event time] <= time) && (NO == [event isPreviewed]) )  {
                    [event setPreviewed:YES];
                    retEvent = event;
                    return;
                }
            }
        }
    });
    return retEvent;
}


-(NEStimEvent*)nextEventAtTime:(NSUInteger)time
{
    __block NEStimEvent* retEvent = nil;
    dispatch_sync(serialAccessQueueTimetable, ^{
        
        [mediaObjectIDs enumerateObjectsUsingBlock:^( id mediaObjectID, NSUInteger idx, BOOL *stop) {
        //for (NSString* mediaObjectID in mediaObjectIDs) {
            
            #pragma unused(idx)
            NSMutableArray* eventsForMediaObject = [mEventsToHappen objectForKey:mediaObjectID];
            if ([eventsForMediaObject count] > 0) {
                NEStimEvent* event = [eventsForMediaObject objectAtIndex:0];
                if ([event time] <= time) {
                    
                    if ([event time] + [event duration] > time) {
                        [[mHappenedEvents objectForKey:mediaObjectID] addObject:event];
                        [eventsForMediaObject removeObject:event];
                        retEvent = event;
                        *stop = YES;
                    } else {
                        [eventsForMediaObject removeObject:event];
                    }
                }
            }
        }];
    });
    return retEvent;
}

-(NSArray*)getAllMediaObjectIDs
{
    return mediaObjectIDs;
}

-(NEMediaObject*)getMediaObjectByID:(NSString*)moID
{
    return [dictMediaObjects objectForKey:moID];
}


-(NSArray*)happenedEventsForMediaObjectID:(NSString*)mediaObjID
{
    __block NSArray* happendEvents = nil;
    dispatch_sync(serialAccessQueueTimetable, ^{
        happendEvents = [[[mHappenedEvents valueForKey:mediaObjID] copy] autorelease];
    });
    return happendEvents;
}

-(NSArray*)eventsToHappenForMediaObjectID:(NSString*)mediaObjID
{
    __block NSArray* eventsToHappen = nil;
    dispatch_sync(serialAccessQueueTimetable, ^{
        eventsToHappen = [[[mEventsToHappen valueForKey:mediaObjID] copy] autorelease];
    });
    return eventsToHappen;
}

-(void)addEvent:(NEStimEvent*)event
{
    dispatch_sync(serialAccessQueueTimetable, ^{
        if ([event time] + [event duration] <= _duration
            && [event duration] > 0) {
            
            NSMutableArray* eventsForMediaObject = [mEventsToHappen objectForKey:[[event mediaObject] getID]];
            [NEStimEvent startTimeSortedInsertOf:event inEventList:eventsForMediaObject];
            [self removeMaskedEventsIn:eventsForMediaObject startingAt:event];
        }
    });
}

-(void)replaceEvent:(NEStimEvent*)toReplace
          withEvent:(NEStimEvent*)replacement
{
    dispatch_sync(serialAccessQueueTimetable, ^{
        
        NSMutableArray* eventsForMediaObject = [mEventsToHappen objectForKey:[[toReplace mediaObject] getID]];
        [eventsForMediaObject removeObject:toReplace];
        
        if ([replacement duration] > 0) {
            [NEStimEvent startTimeSortedInsertOf:replacement inEventList:eventsForMediaObject];
            [self removeMaskedEventsIn:eventsForMediaObject startingAt:replacement];
        }
    });
}

-(void)removeMaskedEventsIn:(NSMutableArray*)eventList
                 startingAt:(NEStimEvent*)event
{
    NSMutableArray* maskedEvents = [[NSMutableArray alloc] initWithCapacity:0];
    NSUInteger eventEndTime   = [event time] + [event duration];
    NSUInteger eventIndex     = [eventList indexOfObject:event];
    
    // Check whether event is masking/masked by its predecessor.
    if (eventIndex > 0) {
        NEStimEvent* previousEvent = [eventList objectAtIndex:(eventIndex - 1)];
        NSUInteger previousEndTime = [previousEvent time] + [previousEvent duration];
        if (previousEndTime >= [event time]) {
            if (previousEndTime >= eventEndTime) {
                [maskedEvents addObject:event];
            } else {
                NEStimEvent* replacement = [[NEStimEvent alloc] initWithTime:[previousEvent time]
                                                                    duration:(eventEndTime - [previousEvent time])
                                                                 mediaObject:[event mediaObject]];
                [eventList replaceObjectAtIndex:eventIndex withObject:replacement];
                event = replacement;
                [replacement release];
                [maskedEvents addObject:previousEvent];
            }
        }
    }
    
    NSUInteger nextEventIndex = eventIndex + 1;
    
    // Check whether event masks events following it.
    while (nextEventIndex < [eventList count]) {
        NEStimEvent* nextEvent = [eventList objectAtIndex:nextEventIndex];
        if ([nextEvent time] <= eventEndTime) {
            NSUInteger nextEventEndTime = [nextEvent time] + [nextEvent duration];
            if (nextEventEndTime > eventEndTime) {
                NEStimEvent* replacement = [[NEStimEvent alloc] initWithTime:[event time]
                                                                    duration:(nextEventEndTime - [event time])
                                                                 mediaObject:[event mediaObject]];
                [eventList replaceObjectAtIndex:eventIndex withObject:replacement];
                [replacement release];
                nextEventIndex = [eventList count]; // Negate loop condition.
            }
            [maskedEvents addObject:nextEvent];
            nextEventIndex++;
        } else {
            nextEventIndex = [eventList count]; // Negate loop condition.
        }
    }
    
    [eventList removeObjectsInArray:maskedEvents];
    [maskedEvents release];
}

-(void)resetTimetableToOriginalEvents
{
    [mEventsToHappen release];
    mEventsToHappen = [mOriginalEvents mutableCopy];
    
    for (NSString* mediaObjID in mediaObjectIDs) {
        [mEventsToHappen setValue:[[[mOriginalEvents objectForKey:mediaObjID] mutableCopy] autorelease] forKey:mediaObjID];
        [[mHappenedEvents valueForKey:mediaObjID] removeAllObjects];
    }
}

-(void)resetTimetable
{
    for (NSString* mediaObjID in mediaObjectIDs) {
        
        NSMutableArray* happendEventsForMediaObj = [mHappenedEvents valueForKey:mediaObjID];
        for (NEStimEvent* eventToAdd in happendEventsForMediaObj) {
            
            [NEStimEvent startTimeSortedInsertOf:eventToAdd inEventList:[mEventsToHappen valueForKey:mediaObjID]];
        }
        
        [happendEventsForMediaObj removeAllObjects];
    }
}

-(void)shiftOnsetForAllEventsToHappen:(NSUInteger)shift
{
    dispatch_sync(serialAccessQueueTimetable, ^{
        
        __block const NSUInteger timeShift = shift;
        [mEventsToHappen
         enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
         usingBlock:^(id mediaID, id stimArray, BOOL *stop) {
             //
                #pragma unused(mediaID)
                #pragma unused(stop)
             [(NSArray*) stimArray enumerateObjectsWithOptions:NSEnumerationConcurrent
                                                    usingBlock:^(id stimEvent, NSUInteger idx, BOOL *stop)
              {
                  
                #pragma unused(stop)
                #pragma unused(idx)
                  [(NEStimEvent*) stimEvent setTime:([(NEStimEvent*) stimEvent time]+timeShift)];
                  [stimEvent setPreviewed:NO];
              }];
             
         }];
        _duration = _duration+shift;
    });
}

@end
