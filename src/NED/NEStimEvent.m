//
//  NEPresentationEvent.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEStimEvent.h"
#import "NERegressorAssignment.h"


@implementation NEStimEvent

@synthesize mOnsetTime = _mOnsetTime;
@synthesize mDuration = _mDuration;
@synthesize mMediaObject = _mMediaObject;
@synthesize isPreviewed = _isPreviewed;

-(id)initWithTime:(NSUInteger)t 
         duration:(NSUInteger)dur
      mediaObject:(NEMediaObject*)obj 
{
    if ((self = [super init])) {
        _mOnsetTime        = t;
        _mDuration    = dur;
        _mMediaObject = [obj retain];
        _isPreviewed = NO;
    }
    
    return self;
}

-(void)dealloc
{
    [_mMediaObject release];
    
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

-(Trial)createTrialFromThis
{
    Trial newTrial;
    newTrial.trialid = 0;
    newTrial.onset = 0;
    newTrial.height = 1;
    newTrial.duration = 0;
    
    if (YES == [_mMediaObject isAssignedToRegressor])
    {
        Trial newTrial;
        
        NERegressorAssignment* t = [_mMediaObject getRegressorAssignment];
        newTrial.trialid = [t trialID];
        // time
        if ((NSInteger)_mOnsetTime > [t timeOffset]){
            newTrial.onset = _mOnsetTime + [t timeOffset];}
        newTrial.duration = _mDuration * [t scaleDuration];
        newTrial.height = [t scaleParametric];

        return newTrial;
            
    }
    return newTrial;
    
}

@end
