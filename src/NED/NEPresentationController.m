//
//  NEPresentationController.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//


//internal presentation stuff
#import "NEPresentationController.h"
#import "NEMediaText.h"
#import "NEStimEvent.h"
#import "NEPresentationLogger.h"
#import "NELogFormatter.h"
#import "NEViewManager.h"
#import "NEPresentationExternalConditionController.h"

//Feedback stuff
#import "NEFeedbackHeli.h"
#import "NEFeedbackThermo.h"

//config 
#import "COExperimentContext.h"


/** The time interval for one update tick in milliseconds. */
#define TICK_TIME 5
/** The time interval for the update in seconds.*/
static const NSTimeInterval UPDATE_INTERVAL = TICK_TIME * 0.001;


/* Simple tuple class because Cocoa lacks one... */
@interface _NETuple : NSObject
{
    id first;
    id second;
}

@property (readonly) id first;
@property (readonly) id second;

-(id)initWithFirst:(id)fst 
         andSecond:(id)snd;

@end

@implementation _NETuple

@synthesize first;
@synthesize second;

-(id)initWithFirst:(id)fst 
         andSecond:(id)snd
{
    if ((self = [super init])) {
        first  = [fst retain];
        second = [snd retain];
    }
    
    return self;
}

-(void)dealloc
{
    [first release];
    [second release];
    [super dealloc];
}

@end
/* END Tuple class. */


@interface NEPresentationController (PrivateMethods)



/**
 * Entry point for mUpdateThread: creates an autorelease 
 * pool, continuously updates the timetable and views unti
 * the presentation is over and finally cleans the thread.
 */
-(void)runUpdateThread;

/**
 * Simulates one time tick (currently 20ms).
 */
-(void)tick;

/**
 * Integrates all events from mChangedEvents into mTimetable
 * (and removes those from mChangedEvents).
 */
-(void)updateTimetable;

/**
 * Handles events starting at mTime (submits the media object
 * to the PresentationView and adds to event to mEventsToEnd).
 */
-(void)handleStartingEvents;

/**
 * Handles events ending at mTime (removing the media object
 * from the PresentationView).
 */
-(void)handleEndingEvents;

/**
 * Resets all time and trigger measuring variables to 0.
 */
-(void)resetTimeAndTriggerCount;

/**
 * checks for the fullfillment of the external conditions
 */
-(BOOL)checkForExternalConditionsForEvent:(NEStimEvent*)event;

/**
 * starts the updateThread ,i.e. the real start of the presentation
 */
-(void)startPresentation;

@end


@implementation NEPresentationController

@synthesize mTriggerCount;
@synthesize mLastTriggersTime;
@synthesize mExternalConditionController;



-(id)initWithView:(NEViewManager*)view
     andTimetable:(NETimetable*)timetable
{
    if ((self = [super init])) {
        mViewManager = [view retain];
        mTimetable = [timetable retain];
        
        mEventsToEnd       = [[NSMutableArray alloc] initWithCapacity:0];
        mAddedEvents       = [[NSMutableArray alloc] initWithCapacity:0];
        mLockAddedEvents   = [[NSLock alloc] init];
        mChangedEvents     = [[NSMutableArray alloc] initWithCapacity:0];
        mLockChangedEvents = [[NSLock alloc] init];
        
        mLogger = [NEPresentationLogger getInstance];
        
        mUpdateThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUpdateThread) object:nil];
        mTR           = (NSUInteger) [[[[COExperimentContext getInstance] systemConfig] getProp:@"$TR"] integerValue];
        [self resetTimeAndTriggerCount];
        
        [mViewManager setTimetable:mTimetable];
        [mViewManager setController:self];
        
        //register itself as an observer for the trigger messages from the sacnner
        COExperimentContext *expContext = [COExperimentContext getInstance];
        [expContext addOberserver:self forProtocol:@"BARTScannerTriggerProtocol"];
        
        
        // TODO: hard-coded! get info from elsewhere!
//        // Helicopter feedback.
//        NSRect feedbackRect = NSMakeRect(200.0, 200.0, 400.0, 200.0);
//        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"0.0", @"minHeight",
//                                                                          @"100.0", @"maxHeight",
//                                                                          @"0.0", @"minFirerate",
//                                                                          @"3.0", @"maxFirerate", nil];
//        NEFeedbackObject* feedback = [[NEFeedbackHeli alloc] initWithFrame:feedbackRect
//                                                               andParameters:params];
//        [mViewManager setFeedback:feedback];
//        [feedback release];
        
//        // Thermometer feedback.
//        NSRect feedbackRect = NSMakeRect(350.0, 50.0, 100.0, 500.0);
//        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"0.0", @"minTemperature",
//                                                                          @"50.0", @"maxTemperature", nil];
//        NEFeedbackObject* feedback = [[NEFeedbackThermo alloc] initWithFrame:feedbackRect
//                                                               andParameters:params];
//        [mViewManager setFeedback:feedback];
//        [feedback release];
    }
    
    return self;
}

-(void)dealloc
{
    [mViewManager release];
    [mTimetable release];
    
    [mEventsToEnd release];
    [mChangedEvents release];
    [mLockChangedEvents release];
    [mAddedEvents release];
    [mLockAddedEvents release];
    
    [mUpdateThread release];
    
    [super dealloc];
}

-(void)triggerArrived:(NSNotification*)aNotification
{
    if (0 == [[aNotification object] unsignedLongValue])
    {
        [self startPresentation];
    }

    NSUInteger triggerCount = [self mTriggerCount] + 1;//tr
  
    [mLogger logTrigger:triggerCount withTime:mTime];
    
    [self setMTriggerCount:triggerCount];
    [self setMLastTriggersTime:[NSDate timeIntervalSinceReferenceDate]];
}

-(void)requestAdditionOfEventWithTime:(NSUInteger)t 
                             duration:(NSUInteger)dur 
                     andMediaObjectID:(NSString*)mID
{
    if (t < mTime) {
        return;
    }
    
    for (NEMediaObject* mediaObj in [mTimetable mediaObjects]) {
        if ([[mediaObj getID] compare:mID] == 0) {
            NEStimEvent* event = [[NEStimEvent alloc] initWithTime:t 
                                                          duration:dur 
                                                       mediaObject:mediaObj];
            if ([mUpdateThread isExecuting]) {
                [mLockAddedEvents lock];
                [mAddedEvents addObject:event];
                [mLockAddedEvents unlock];
                
            } else {
                [mTimetable addEvent:event];
                [mViewManager updateTimeline];
            }
            [event release];
            return;
        }
    }
}

-(void)enqueueEvent:(NEStimEvent*)newEvent
   asReplacementFor:(NEStimEvent*)oldEvent
{
    if ([mUpdateThread isExecuting]) {
        _NETuple* tuple = [[_NETuple alloc] initWithFirst:oldEvent andSecond:newEvent];
        [mLockChangedEvents lock];
        [mChangedEvents addObject:tuple];
        [mLockChangedEvents unlock];
        [tuple release];
    } else {
        [mTimetable replaceEvent:oldEvent 
                       withEvent:newEvent];
    }
}

-(NSUInteger)presentationDuration
{
    return [mTimetable duration];
}

-(void)startListeningForTrigger
{
    if (![mUpdateThread isExecuting] 
        && ![mUpdateThread isCancelled]) {
        
        [self resetTimeAndTriggerCount];
       
    }
}

-(void)pausePresentation
{
    if ([mUpdateThread isExecuting]) {
        [mUpdateThread cancel];
        [mViewManager pausePresentation];
    }
}

-(void)stopPresentation
{
    if ([mUpdateThread isExecuting]) {
        [mUpdateThread cancel];
        [mViewManager pausePresentation];
    }
}

-(void)startPresentation
{
    mLastTriggersTime = [NSDate timeIntervalSinceReferenceDate];
    [mUpdateThread start];
}


-(void)continuePresentation
{
    if ([mUpdateThread isFinished]) {
        [mUpdateThread release];
        mUpdateThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUpdateThread) object:nil];
        [mUpdateThread start];
        [mViewManager continuePresentation];
    }
}

-(void)resetPresentationToOriginal:(BOOL)toOriginalEvents
{
    if ([mUpdateThread isExecuting] || [mUpdateThread isFinished]) {
        [mUpdateThread cancel];
        while (![mUpdateThread isFinished]) ; // Wait until run thread is finished.
    }
    
    [mUpdateThread release];
    mUpdateThread = [[NSThread alloc] initWithTarget:self selector:@selector(runUpdateThread) object:nil];
    [self resetTimeAndTriggerCount];
    [mEventsToEnd removeAllObjects];
    
    [mViewManager resetPresentation];

    if (toOriginalEvents) {
        [mTimetable resetTimetableToOriginalEvents];
    } else {
        [mTimetable resetTimetable];
    }
    
    /** BEGIN Test log output
     *
     * TODO: place elsewere and get tolerance from config!
     */
    printf("### Log ###\n");
    [mLogger printToFilePath:@"/tmp/MyLogFile.log"];
    [mLogger print];
    printf("\n");
//    printf("### Violations ###\n");
//    for (NSString* violationMsg in [mLogger allMessagesViolatingTolerance:7]) {
//        printf("%s\n", [violationMsg cStringUsingEncoding:NSUTF8StringEncoding]);
//    }
//    NSUInteger over100 = [[mLogger allMessagesViolatingTolerance:100] count] / 2;
//    printf(">100: %ld\n", over100);
//    NSUInteger over20  = [[mLogger allMessagesViolatingTolerance:20] count] / 2 - over100;
//    printf(">20:  %ld\n", over20);
//    NSUInteger over7   = [[mLogger allMessagesViolatingTolerance:7] count] / 2 - (over20 + over100);
//    printf(">7:   %ld\n", over7);
    [mLogger clear];
    /** END Test log output. */
}

-(void)runUpdateThread
{
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];

    [mUpdateThread setThreadPriority:1.0];
    
    while ([self mTriggerCount] == 0) {
        // TODO: find suitable sleep interval!
    }
    
    do {
        [self tick];
        [NSThread sleepForTimeInterval:UPDATE_INTERVAL];
    } while (![[NSThread currentThread] isCancelled]);
        
    [autoreleasePool drain];
    autoreleasePool = nil;
    
    [NSThread exit];
}

-(void)tick
{
    mCurrentTicksTime = [NSDate timeIntervalSinceReferenceDate];
    NSUInteger timeDifference = (NSUInteger) ((mCurrentTicksTime - [self mLastTriggersTime]) * 1000.0);
    //mTime = [self mTriggerCount] * mTR + timeDifference;

    
    if (mTime <= [mTimetable duration]) {
        if (timeDifference < mTR - TICK_TIME) {
            mTime = ([self mTriggerCount] - 1) * mTR + timeDifference;
        }
        
        //ask for conditions
        NEStimEvent *event = [mTimetable previewNextEventAtTime:mTime];
        //TODO if else part
        [self checkForExternalConditionsForEvent:event];
        
        
        [mViewManager setCurrentTime:mTime];
        
        [self updateTimetable];
        [self handleStartingEvents];
        [self handleEndingEvents];
        [mViewManager displayPresentationView];
        
    } else {
        [mUpdateThread cancel];
    }
}

-(BOOL)checkForExternalConditionsForEvent:(NEStimEvent *)event
{
    if (NO == [[event mediaObject] isDependentFromConstraint])
    {
        return YES;
    }
    else{
        
        //NSPoint p = [mExternalConditionController isConditionFullfilledForEvent:event];
        
        NSDictionary *dict = [mExternalConditionController checkConstraintForID:[[event mediaObject] getConstraintID]];
        //if ( (0.0 == p.x) || (0.0 == p.y) )
        if (nil != dict)
        {
            //shift all coming events 20 ms
            [mTimetable shiftOnsetForAllEventsToHappen:20];
            return NO;
        }
        
        
        //get position from external device and set this to coming event
        //[[event mediaObject] setPosition:p];
        
        
        return YES;
    }
    
}

-(void)updateTimetable
{
    // Add events.
    [mLockAddedEvents lock];
    for (NEStimEvent* event in mAddedEvents) {
        [mTimetable addEvent:event];
    }
    [mAddedEvents removeAllObjects];
    [mLockAddedEvents unlock];
    
    // Replace events.
    [mLockChangedEvents lock];
    for (_NETuple* eventTuple in mChangedEvents) {
        [mTimetable replaceEvent:[eventTuple first] 
                       withEvent:[eventTuple second]];
    }
    [mChangedEvents removeAllObjects];
    [mLockChangedEvents unlock];
    
    // Remove events.
    // TODO: implement removal of events.
}

-(void)handleStartingEvents
{
    NEStimEvent* event = [mTimetable nextEventAtTime:mTime];
    while (event) {
        
        [mViewManager present:[event mediaObject]];
        [NEStimEvent endTimeSortedInsertOf:event 
                               inEventList:mEventsToEnd];
        [mLogger logStartingEvent:event withTrigger:[self mTriggerCount] andTime:mTime];
        
        event = [mTimetable nextEventAtTime:mTime];
    }
}

-(void)handleEndingEvents
{
    BOOL done = NO;
    while ([mEventsToEnd count] > 0
           && !done) {
        NEStimEvent* event = [mEventsToEnd objectAtIndex:0];
        if (([event time] + [event duration]) <= mTime) {
            
            [mViewManager stopPresentationOf:[event mediaObject]];
            [mEventsToEnd removeObject:event];
            [mLogger logEndingEvent:event withTrigger:[self mTriggerCount] andTime:mTime];
            
        } else {
            done = YES;
        }
    }
}

-(void)resetTimeAndTriggerCount
{
    mTime = 0;
    [self setMTriggerCount:0];
    //[mLogger printToFilePath:@"/tmp/MyLogFile.log"];
}



-(void)terminusFromScannerArrived:(NSNotification *)msg
{
    NSLog(@"%@", msg);
    [self resetPresentationToOriginal:NO];
}

@end
