//
//  NEPresentationEvent.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEStimEvent.h"


@implementation NEStimEvent

@synthesize time;
@synthesize duration;
@synthesize mediaObject;

-(id)initWithTime:(NSUInteger)t 
         duration:(NSUInteger)dur
      mediaObject:(NEMediaObject*)obj 
{
    if ((self = [super init])) {
        time        = t;
        duration    = dur;
        mediaObject = [obj retain];
    }
    
    return self;
}

-(void)dealloc
{
    [mediaObject release];
    
    [super dealloc];
}

+(void)startTimeSortedInsertOf:(NEStimEvent*)event
                   inEventList:(NSMutableArray*)eventList
{
    NSUInteger insertIndex = 0;
    while (insertIndex <= [eventList count]) {
        if (insertIndex == [eventList count]) {
            [eventList addObject:event];
            insertIndex = [eventList count];
            
        } else {
            if ([[eventList objectAtIndex:insertIndex] time] > [event time]) {
                [eventList insertObject:event atIndex:insertIndex];
                insertIndex = [eventList count];
            }
        }
        
        insertIndex++;
    }
}

+(void)endTimeSortedInsertOf:(NEStimEvent*)event
                 inEventList:(NSMutableArray*)eventList
{
    NSUInteger insertIndex = 0;
    while (insertIndex <= [eventList count]) {
        if (insertIndex == [eventList count]) {
            [eventList addObject:event];
            insertIndex = [eventList count];
            
        } else {
            NEStimEvent* eventAtIndex = [eventList objectAtIndex:insertIndex];
            if (([event time] + [event duration])
                < ([eventAtIndex time] + [eventAtIndex duration])) {
                [eventList insertObject:event atIndex:insertIndex];
                insertIndex = [eventList count];
            }
        }
        
        insertIndex++;
    }
}

@end
