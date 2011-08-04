//
//  NETimetableTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/22/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NETimetableTest.h"
#import "NETimetable.h"

@implementation NETimetableTest

-(void)setUp
{
    config = [COSystemConfig getInstance];
    [config fillWithContentsOfEDLFile:@"pseudoStimulusDataFree.edl"];

    mediaObjects = [NSMutableArray arrayWithCapacity:0];
    
    for (int mediaObjectNr = 1; 
         mediaObjectNr <= [config countNodes:@"/rtExperiment/stimulusData/mediaObjectList/mediaObject"]; 
         mediaObjectNr++) {
        
        NSString* entryKey = [NSString stringWithFormat:@"/rtExperiment/stimulusData/mediaObjectList/mediaObject[%d]", mediaObjectNr];
        NEMediaObject* mObj = [[NEMediaObject alloc] initWithConfigEntry:entryKey];
        [mediaObjects addObject:mObj];
        [mObj release];
    }
}

-(void)testAddEvent
{
    NETimetable* timetable = [[NETimetable alloc] initWithConfigEntry:@"/rtExperiment/stimulusData/timeTable" 
                                                      andMediaObjects:mediaObjects];
    NEMediaObject* mediaObj = [mediaObjects objectAtIndex:2];
    NSString* mediaObjID    = [mediaObj getID];
    NEStimEvent* eventToAdd = [[NEStimEvent alloc] initWithTime:1234 duration:4321 mediaObject:mediaObj];
    
    NSUInteger numberOfEventsPreAddition = [[timetable eventsToHappenForMediaObjectID:mediaObjID] count];
    [timetable addEvent:eventToAdd];
    
    BOOL success = NO;
    if ([[timetable eventsToHappenForMediaObjectID:mediaObjID] count]
        == numberOfEventsPreAddition + 1) {
        success = YES;
    }
    
    NEStimEvent* addedEvent = [timetable nextEventAtTime:1234];
    while (addedEvent && (eventToAdd != addedEvent)) {
        addedEvent = [timetable nextEventAtTime:1234];
    }
    if (addedEvent == eventToAdd) {
        success = success && YES;
    } else {
        success = NO;
    }

    [eventToAdd release];
    [timetable release];
    
    STAssertEquals(YES, success, @"Adding an event to a timetable does not work properly!");
}

-(void)testInitWithConfigEntry
{
    NETimetable* timetable = [[NETimetable alloc] initWithConfigEntry:@"/rtExperiment/stimulusData/timeTable" 
                                                      andMediaObjects:mediaObjects];
    BOOL success = NO;
    if ([[timetable getAllMediaObjectIDs] count] == [timetable numberOfMediaObjects]
        && [timetable numberOfMediaObjects] == 6
        && [timetable duration] == 270000
        && [[timetable eventsToHappenForMediaObjectID:@"mo1"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo2"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo3"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo4"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo5"] count] == 1
        && [[timetable eventsToHappenForMediaObjectID:@"mo6"] count] == 1
        && [[timetable happenedEventsForMediaObjectID:@"mo1"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo2"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo3"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo4"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo5"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo6"] count] == 0) {
        success = YES;
    }
    
    [timetable release];
    
    STAssertEquals(YES, success, @"Timetable was not initialized correctly with config entry!");
}

-(void)testNextEventAtTime
{
    NETimetable* timetable = [[NETimetable alloc] initWithConfigEntry:@"/rtExperiment/stimulusData/timeTable" 
                                                      andMediaObjects:mediaObjects];
    
    NSUInteger requiredSuccesses = 0;
    for (NSString* mediaObjID in [timetable getAllMediaObjectIDs]) {
        requiredSuccesses += [[timetable eventsToHappenForMediaObjectID:mediaObjID] count];
    }
    
    NSUInteger successes = 0;
    NSUInteger currentTime = 0;
    NEStimEvent* event;
    while (currentTime <= [timetable duration]) {
        event = [timetable nextEventAtTime:currentTime];
        if (event) {
            if ([event time] <= currentTime
                && [[timetable happenedEventsForMediaObjectID:[[event mediaObject] getID]] containsObject:event]) {
                successes++;
            }
        }
        currentTime += 23;
    }
    
    [timetable release];
    
    STAssertEquals(requiredSuccesses, successes, @"Method nextEventAtTime of NETimetable does not work as intended!");
}

-(void)testReplaceEvent
{
    NETimetable* timetable = [[NETimetable alloc] initWithConfigEntry:@"/rtExperiment/stimulusData/timeTable" 
                                                      andMediaObjects:mediaObjects];
    NEMediaObject* aMediaObj = [mediaObjects objectAtIndex:0];
    
    
    NEStimEvent* replacement = [[NEStimEvent alloc] initWithTime:2 
                                                        duration:4 
                                                     mediaObject:aMediaObj];
    NEStimEvent* replacementWithZeroDur = [[NEStimEvent alloc] initWithTime:4 
                                                                   duration:0 
                                                                mediaObject:aMediaObj];
    
    
    NEStimEvent* toReplace = [[timetable eventsToHappenForMediaObjectID:[aMediaObj getID]] objectAtIndex:0];
    
    BOOL success = NO;
    
    // Check normal replacing (removal of toReplace and addition of replacement).
    [timetable replaceEvent:toReplace withEvent:replacement];
    if (![[timetable eventsToHappenForMediaObjectID:[aMediaObj getID]] containsObject:toReplace]
        && [[timetable eventsToHappenForMediaObjectID:[aMediaObj getID]] containsObject:replacement]) {
        success = YES;
    }
    
    // Check whether replacing an event with an other event that has 0 as duration,
    // removes the event and does NOT insert the other event.
    [timetable replaceEvent:replacement withEvent:replacementWithZeroDur];
    if (![[timetable eventsToHappenForMediaObjectID:[aMediaObj getID]] containsObject:replacement]
        && ![[timetable eventsToHappenForMediaObjectID:[aMediaObj getID]] containsObject:replacementWithZeroDur]) {
        success = success && YES;
    } else {
        success = NO;
    }
    
    [replacement release];
    [replacementWithZeroDur release];
    [timetable release];
    
    STAssertEquals(YES, success, @"Replacing events in the timetable does not work properly!");
}

-(void)testResetTimetableToOriginalEvents
{
    NETimetable* timetable = [[NETimetable alloc] initWithConfigEntry:@"rtExperiment/stimulusData/timeTable"
                                                     andMediaObjects:mediaObjects];
    // Consume all events in the timetable.
    NSUInteger time = 0;
    while (time <= [timetable duration]) {
        NEStimEvent* event = [timetable nextEventAtTime:time];
        while (event) {
            event = [timetable nextEventAtTime:time];
        }
        time += 1000;
    }
    
    BOOL success = NO;
    if ([[timetable eventsToHappenForMediaObjectID:@"mo1"] count] == 0
        && [[timetable eventsToHappenForMediaObjectID:@"mo2"] count] == 0
        && [[timetable eventsToHappenForMediaObjectID:@"mo3"] count] == 0
        && [[timetable eventsToHappenForMediaObjectID:@"mo4"] count] == 0
        && [[timetable eventsToHappenForMediaObjectID:@"mo5"] count] == 0
        && [[timetable eventsToHappenForMediaObjectID:@"mo6"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo1"] count] == 3
        && [[timetable happenedEventsForMediaObjectID:@"mo2"] count] == 3
        && [[timetable happenedEventsForMediaObjectID:@"mo3"] count] == 3
        && [[timetable happenedEventsForMediaObjectID:@"mo4"] count] == 3
        && [[timetable happenedEventsForMediaObjectID:@"mo5"] count] == 1
        && [[timetable happenedEventsForMediaObjectID:@"mo6"] count] == 1) {
        success = YES;
    }
    
    [timetable resetTimetableToOriginalEvents];
    
    if ([[timetable eventsToHappenForMediaObjectID:@"mo1"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo2"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo3"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo4"] count] == 3
        && [[timetable eventsToHappenForMediaObjectID:@"mo5"] count] == 1
        && [[timetable eventsToHappenForMediaObjectID:@"mo6"] count] == 1
        && [[timetable happenedEventsForMediaObjectID:@"mo1"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo2"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo3"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo4"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo5"] count] == 0
        && [[timetable happenedEventsForMediaObjectID:@"mo6"] count] == 0) {
        success = success && YES;
    } else {
        success = NO;
    }
    
    [timetable release];
    
    STAssertEquals(YES, success, @"ResetTimetableToOriginalEvents does not work as intended!");
}

-(void)tearDown
{
}

@end
