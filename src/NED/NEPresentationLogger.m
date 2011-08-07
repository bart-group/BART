//
//  NEPresentationLogger.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/26/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEPresentationLogger.h"
#import "COExperimentContext.h"


/**
 * Private class for representing all the event information
 * parsed from one log message.
 */
@interface _NEParsedEvent : NSObject
{
    /** Date of the log entry for this particular event. */
    NSDate* dateHappend;
    /** 
     * Log string representation of the corresponding 
     * NEStimEvent (including start or end event flag).
     */
    NSString* stimEventString;
    /** 
     * Indicates whether the event was ending at the time
     * of the log entry.
     */
    BOOL isEndingEvent;
    /**
     * Start time of the event relative to the first trigger
     * (in milliseconds).
     */
    NSUInteger time;
    /** Duration of the event (in milliseconds). */
    NSUInteger duration;
    /** 
     * ID of the media object that is presented with
     * this event.
     */
    NSString* mediaObjectID;
    /** Number of the last trigger happend before this event. */
    NSUInteger triggerCount;
    
    /** Formatter for log messages. */
    NELogFormatter* formatter;
}

@property (readonly) NSDate* dateHappend;
@property (readonly) NSString* stimEventString;
@property (readonly) BOOL isEndingEvent;
@property (readonly) NSUInteger time;
@property (readonly) NSUInteger duration;
@property (readonly) NSString* mediaObjectID;
@property (readonly) NSUInteger triggerCount;

/**
 * Initializer for _NEParsedEvent objects
 *
 * \param tHappend The date of the log entry for
 *                 this particular event.
 * \param event    Log string representation of a 
 *                 NEStimEvent (including start or
 *                 end event flag).
 * \param trCount  Last trigger number before the
 *                 event was logged.
 * \return         A initialized _NEParsedEvent object.
 */
-(id)initWithDate:(NSDate*)tHappend
     stimEventStr:(NSString*)event
     triggerCount:(NSUInteger)trCount;

/**
 * Helper method for initWithDate::::.
 * Extracts the time, duration, isEndEvent and
 * mediaObjectID information from eventStr.
 *
 * \param eventStr Log string representation of a
 *                 NEStimEvent (including start or
 *                 end event flag).
 */
-(void)parseEventString:(NSString*)eventStr;

@end

@implementation _NEParsedEvent

@synthesize dateHappend;
@synthesize stimEventString;
@synthesize isEndingEvent;
@synthesize time;
@synthesize duration;
@synthesize mediaObjectID;
@synthesize triggerCount;

-(id)initWithDate:(NSDate*)tHappend
     stimEventStr:(NSString*)event
     triggerCount:(NSUInteger)trCount
{
    if ((self = [super init])) {
        formatter = [NELogFormatter defaultFormatter];
        
        dateHappend  = [tHappend retain];
        stimEventString = [event retain];
        [self parseEventString:event];
        triggerCount = trCount;
    }
    
    return self;
}

-(void)parseEventString:(NSString*)eventStr
{
    NSString* event = eventStr;
    NSString* startEventPrefix  = [NSString stringWithFormat:@"%@%@%@", 
                                                               [formatter startEventIdentifier],
                                                                 [formatter eventIdentifier], 
                                                                   [formatter keyValueSeperator]];
    NSString* endEventPrefix    = [NSString stringWithFormat:@"%@%@%@", 
                                                               [formatter endEventIdentifier], 
                                                                 [formatter eventIdentifier], 
                                                                   [formatter keyValueSeperator]];
    
    if ([event hasPrefix:startEventPrefix]) {
        isEndingEvent = NO;
        event = [event stringByReplacingOccurrencesOfString:startEventPrefix withString:@""];
    } else if ([event hasPrefix:endEventPrefix]) {
        isEndingEvent = YES;
        event = [event stringByReplacingOccurrencesOfString:endEventPrefix withString:@""];
    }
    
    event = [[event stringByReplacingOccurrencesOfString:[formatter beginSetDelimiter] withString:@""] 
                    stringByReplacingOccurrencesOfString:[formatter endSetDelimiter] withString:@""];
    
    NSArray* eventComponents = [event componentsSeparatedByString:[formatter entrySeperator]];
    
    time = [[eventComponents objectAtIndex:0] integerValue];
    duration = [[eventComponents objectAtIndex:1] integerValue];
    mediaObjectID = [eventComponents objectAtIndex:2];
}

-(void)dealloc
{
    [dateHappend release];
    [stimEventString release];
    [super dealloc];
}

@end


@interface NEPresentationLogger (PrivateMethods)

/**
 * Helper method for allMessagesViolatingTolerance:.
 * Does the actual checking for violations with a given _NEParsedEvent
 * array, an array of (trigger) NSDates and the time tolerance.
 *
 * \param parsedEvents An array of _NEParsedEvents containing all event
 *                     information parsed from the log.
 * \param triggerDates An array of NSDates - one for each trigger
 *                     (index of the date in triggerDates is equal to the
 *                      trigger number).
 * \return             All logged events that violated the time tolerance
 *                     and the last trigger that was recorded before each of
 *                     those events.
 */
-(NSArray*)checkForViolationsIn:(NSArray*)parsedEvents
               withTriggerDates:(NSArray*)triggerDates
                   andTolerance:(NSUInteger)tolerance;

@end


@implementation NEPresentationLogger

-(id)init
{
    if ((self = [super init])) {
        mMessages = [[NSMutableArray alloc] initWithCapacity:100];
        mDateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%Y-%m-%d|%H:%M:%S.%F" allowNaturalLanguage:NO];
        mLogFormatter  = [[NELogFormatter alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [mMessages release];
    [mDateFormatter release];
    [mLogFormatter release];
    [super dealloc];
}

+(NEPresentationLogger*)sharedInstance
{
    /** Singleton object of NEPresentationLogger. */
    static NEPresentationLogger* mSingleton = nil;
    
	if (!mSingleton) {
		mSingleton = [[self alloc] init];
	} 
	
	return mSingleton;
}

-(void)log:(NSString*)msg
{
    [mMessages addObject:[NSString stringWithFormat:@"%@ %@", 
                                                      [mDateFormatter stringFromDate:[NSDate date]], 
                                                         msg]];
}

-(void)logTrigger:(NSUInteger)triggerNumber
{
    [mMessages addObject:[NSString stringWithFormat:@"%@ %@", 
                                                      [mDateFormatter stringFromDate:[NSDate date]], 
                                                         [mLogFormatter stringForTriggerNumber:triggerNumber]]];
}

-(void)logStartingEvent:(NEStimEvent*)event 
            withTrigger:(NSUInteger)triggerNumber
{
    // Not using [self log] due to time reasons.
    [mMessages addObject:[NSString stringWithFormat:@"%@ %@%@ %@",
                                                      [mDateFormatter stringFromDate:[NSDate date]],
                                                         [mLogFormatter startEventIdentifier],
                                                           [mLogFormatter stringForStimEvent:event], 
                                                              [mLogFormatter stringForTriggerNumber:triggerNumber]]];
}

-(void)logEndingEvent:(NEStimEvent*)event 
          withTrigger:(NSUInteger)triggerNumber
{
    // Not using [self log] due to time reasons.
    [mMessages addObject:[NSString stringWithFormat:@"%@ %@%@ %@",
                                                      [mDateFormatter stringFromDate:[NSDate date]],
                                                         [mLogFormatter endEventIdentifier],
                                                           [mLogFormatter stringForStimEvent:event], 
                                                              [mLogFormatter stringForTriggerNumber:triggerNumber]]];
}

-(NSArray*)messages
{
    return [[mMessages copy] autorelease];
}

-(void)print
{
    for (NSString* msg in mMessages) {
        printf("%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}


-(void)printToFilePath:(NSString*)path
{
    FILE* fp = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "w");
    for (NSString* msg in [self messages]) {
        fprintf(fp, "%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    fclose(fp);
}

-(void)printToNSLog
{
    for (NSString* msg in mMessages) {
        NSLog(@"%@", msg);
    }
}

-(void)clear;
{
    [mMessages release];
    mMessages = [[NSMutableArray alloc] initWithCapacity:100];
}

-(NSArray*)allMessagesViolatingTolerance:(NSUInteger)tolerance
{
    NSMutableArray* triggerDates = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* parsedEvents = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString* msg in mMessages) {
        NSArray* msgComponents = [msg componentsSeparatedByString:[mLogFormatter keyValuePairSeperator]];
        NSDate* msgDate = [mDateFormatter dateFromString:[msgComponents objectAtIndex:0]];
        
        // Message might represent a trigger message.
        if ([msgComponents count] == 2) {
            NSString* possibleTriggerStr = [msgComponents objectAtIndex:1];
            NSString* triggerMsgPrefix = [NSString stringWithFormat:@"%@%@", 
                                                                      [mLogFormatter triggerIdentifier], 
                                                                        [mLogFormatter keyValueSeperator]];
            if ([possibleTriggerStr hasPrefix:triggerMsgPrefix]) {
                [triggerDates addObject:msgDate];
            }
            
        // Message might represent a event message.
        } else if ([msgComponents count] == 3) {
            NSString* possibleEventStr = [msgComponents objectAtIndex:1];
            NSString* possibleTriggerStr = [msgComponents objectAtIndex:2];
            
            NSString* startEventPrefix  = [NSString stringWithFormat:@"%@%@%@", 
                                                                       [mLogFormatter startEventIdentifier],
                                                                         [mLogFormatter eventIdentifier], 
                                                                           [mLogFormatter keyValueSeperator]];
            NSString* endEventPrefix    = [NSString stringWithFormat:@"%@%@%@", 
                                                                       [mLogFormatter endEventIdentifier], 
                                                                         [mLogFormatter eventIdentifier], 
                                                                           [mLogFormatter keyValueSeperator]];
            NSString* triggerNrPrefix   = [NSString stringWithFormat:@"%@%@", 
                                                                       [mLogFormatter triggerIdentifier],
                                                                         [mLogFormatter keyValueSeperator]];
            
            if (([possibleEventStr hasPrefix:startEventPrefix] || [possibleEventStr hasPrefix:endEventPrefix])
                && [possibleTriggerStr hasPrefix:triggerNrPrefix]) {
                
                _NEParsedEvent* event = [[_NEParsedEvent alloc] initWithDate:msgDate 
                                                                stimEventStr:possibleEventStr 
                                                                triggerCount:[[possibleTriggerStr stringByReplacingOccurrencesOfString:triggerNrPrefix 
                                                                                                                            withString:@""] integerValue]];
                [parsedEvents addObject:event];
                [event release];
            }
        }
    }
    
    return [self checkForViolationsIn:parsedEvents 
                     withTriggerDates:triggerDates 
                         andTolerance:tolerance];
}

-(NSArray*)checkForViolationsIn:(NSArray*)parsedEvents
               withTriggerDates:(NSArray*)triggerDates
                   andTolerance:(NSUInteger)tolerance
{
    NSInteger repetitionTime = [[[[COExperimentContext getInstance] systemConfig] getProp:@"$TR"] integerValue];
    NSMutableArray* violations = [NSMutableArray arrayWithCapacity:0];
    
    for (_NEParsedEvent* event in parsedEvents) {
        // Possible error source: indices of the trigger array!
        NSDate* triggerDateForEvent = [triggerDates objectAtIndex:[event triggerCount] - 1];
        NSUInteger timeDifference = (NSUInteger) ([[event dateHappend] timeIntervalSinceDate:triggerDateForEvent] * 1000.0);
        NSUInteger tolerableOffset;
        
        if ([event isEndingEvent]) {
            tolerableOffset = [event time] + [event duration];
        } else {
            tolerableOffset = [event time];
        }
        tolerableOffset -= ([event triggerCount] * repetitionTime);
        
        if ((timeDifference >= tolerableOffset)
            && (timeDifference - tolerableOffset > tolerance)) {
            // Violation!
            NSString* serilizedEventMsg = [NSString stringWithFormat:@"%@ %@ %@", 
                                                                       [mDateFormatter stringFromDate:[event dateHappend]], 
                                                                          [event stimEventString], 
                                                                             [mLogFormatter stringForTriggerNumber:[event triggerCount]]];
            
            for (NSString* msg in mMessages) {
                if ([msg compare:serilizedEventMsg] == 0) {
                    [violations addObject:[NSString stringWithFormat:@"%@ %@", 
                                                                       [mDateFormatter stringFromDate:triggerDateForEvent],
                                                                         [mLogFormatter stringForTriggerNumber:[event triggerCount]]]];
                    [violations addObject:serilizedEventMsg];
                }
            }
        }
    }
    
    return violations;
}

@end
