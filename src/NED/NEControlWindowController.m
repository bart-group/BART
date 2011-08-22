//
//  NEUserInteractionController.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/13/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEControlWindowController.h"
#import "NEPresentationController.h"
#import "NETimelineWindowController.h"


/** Used for trigger simulation. */
static const NSTimeInterval FAKE_TRIGGER_INTERVAL = 1.0;

/** 
 * Error message that is displayed when trying to add an
 * event whose duration exceeds the presentation duration.
 */
static NSString* const TOO_LONG_EVENT_ERROR_MESSAGE = @"Did not add event that exceeded the presentation duration!";


@interface NEControlWindowController ()

/**
 * Used for trigger simulation.
 */
-(void)runTriggerThread;
-(void)fireTrigger;
-(void)resetTrigger;

/**
 * Requests the addition of an event given/represented by 
 * time, duration and media object ID at the presentation
 * controller.
 * 
 * \param time       The event time.
 * \param duration   The event duration.
 * \param mediaObjID The media object ID for the event.
 */
-(void)addEventWithTime:(NSUInteger)time 
               duration:(NSUInteger)duration 
       andMediaObjectID:(NSString*)mediaObjID;

/**
 * Sets the content of each textfield in the GUI to @"" (empty string).
 */
-(void)clearTextFields;

/**
 * Parses a given user input (range or list of values) and builds
 * an array of strings where each string is representing a value.
 * Substitutes a range with a list of values.
 * 
 * \param valueStr The user input string that might be a range or
 *                 list of values.
 * \return         An array of strings each representing a single
 *                 value.
 */
-(NSArray*)parseRangeOrList:(NSString*)valueStr;

/**
 * Determines whether a given input string represents
 * a range of values in typical MATLAB syntax (from:step:to).
 * Otherwise it represents a list of concrete values (including
 * a list only containing value).
 *
 * \param rangeStr The user input that might represent a range
 *                 or list of values.
 * \return         YES if the parameter rangeStr represents a range,
 *                 NO if it represents a list of values.
 */
-(BOOL)isRange:(NSString*)rangeStr;

@property (readwrite) BOOL mIsPaused;

@end


@implementation NEControlWindowController

@synthesize mIsPaused;

-(void)dealloc
{
    if (mTriggerThread) {
        [mTriggerThread release];
    }
    
    [super dealloc];
}

-(void)setPresentationController:(NEPresentationController *)presController
{
    presentationController = presController;
    presentationDuration = [presentationController presentationDuration];
}

-(void)setTimelineWindowController:(NETimelineWindowController*)tmlnWindowController
{
    timelineWindowController = tmlnWindowController;
}

-(IBAction)startPresentation:(id)sender
{
    if (presentationController) {
        if (!mTriggerThread) {
            mTriggerThread = [[NSThread alloc] initWithTarget:self 
                                                     selector:@selector(runTriggerThread) 
                                                       object:nil];
            [mTriggerThread setThreadPriority:1.0];
        }
        mTriggerCount = 0;
        [self setMIsPaused:NO];
        
        [presentationController startListeningForTrigger];
        [mTriggerThread start];
        
        [startButton setEnabled:NO];
        [pauseButton setEnabled:YES];
    }
}

-(void)runTriggerThread
{
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    do {
        [self fireTrigger];
        [NSThread sleepForTimeInterval:FAKE_TRIGGER_INTERVAL];
    } while (![[NSThread currentThread] isCancelled]);
    
    [autoreleasePool drain];
    autoreleasePool = nil;
    
    [NSThread exit];
}

-(void)fireTrigger
{    
    if (mTriggerCount <= 10000
        && ![self mIsPaused]) {
        [presentationController trigger];
        mTriggerCount++;
    } 
//    else {
//        [[NSThread currentThread] cancel];
//        mTriggerCount = 0;
//    }
}

-(void)resetTrigger
{
    if (!mTriggerThread) {
        return;
    }
    
    if ([mTriggerThread isExecuting] || [mTriggerThread isFinished]) {
        [mTriggerThread cancel];
        while (![mTriggerThread isFinished]) ; // Wait until run thread is finished.
    }
    
    [mTriggerThread release];
    mTriggerThread = [[NSThread alloc] initWithTarget:self 
                                             selector:@selector(runTriggerThread) 
                                               object:nil];
}

-(IBAction)pausePresentation:(id)sender
{
//    if (presentationController) {        
//        if ([[pauseButton title] compare:@"Pause"] == 0) {
//            [self setMIsPaused:YES];
//            [presentationController pausePresentation];
//            [pauseButton setTitle:@"Continue"];
//        } else if ([[pauseButton title] compare:@"Continue"] == 0) {
//            [self setMIsPaused:NO];
//            [presentationController continuePresentation];
//            [pauseButton setTitle:@"Pause"];
//        }
//    }
}

-(IBAction)resetPresentation:(id)sender
{
    [self resetTrigger];
    [self setMIsPaused:NO];
    
    if (presentationController) {
        if (sender == eventResetButton) {
            [presentationController resetPresentationToOriginal:YES];
        } else if (sender == timeResetButton) {
            [presentationController resetPresentationToOriginal:NO];
        }
    }
    if (timelineWindowController) {
        [timelineWindowController clearSelection];
    }
    
    [pauseButton setEnabled:NO];
    [pauseButton setTitle:@"Pause"];
    [startButton setEnabled:YES];
    [self clearTextFields];
}

-(IBAction)addStimulusEvent:(id)sender
{    
    [warningMessageLabel setStringValue:@""];
    
    NSArray* times = [self parseRangeOrList:[eventTimeField stringValue]];
    NSArray* durations = [self parseRangeOrList:[eventDurationField stringValue]];
    NSArray* mediaObjIDs = [[eventMediaObjectIDField stringValue] componentsSeparatedByString:@" "];
    
    if ([times count] == [durations count]
        && [times count] == [mediaObjIDs count]) {
        for (NSUInteger i = 0; i < [times count]; i++) {
            NSInteger time = [[times objectAtIndex:i] integerValue];
            NSInteger duration = [[durations objectAtIndex:i] integerValue];
            [self addEventWithTime:time duration:duration andMediaObjectID:[mediaObjIDs objectAtIndex:i]];
        }
    } else if ([times count] == [durations count]
               && [mediaObjIDs count] == 1) {
        for (NSUInteger i = 0; i < [times count]; i++) {
            NSInteger time = [[times objectAtIndex:i] integerValue];
            NSInteger duration = [[durations objectAtIndex:i] integerValue];
            [self addEventWithTime:time duration:duration andMediaObjectID:[mediaObjIDs objectAtIndex:0]];
        }
    } else if ([times count] == [mediaObjIDs count]
               && [durations count] == 1) {
        NSInteger duration = [[durations objectAtIndex:0] integerValue];
        for (NSUInteger i = 0; i < [times count]; i++) {
            NSInteger time = [[times objectAtIndex:i] integerValue];
            [self addEventWithTime:time duration:duration andMediaObjectID:[mediaObjIDs objectAtIndex:i]];
        }
    } else if ([times count] > 1
               && [durations count] == 1
               && [mediaObjIDs count] == 1) {
        NSInteger duration = [[durations objectAtIndex:0] integerValue];
        for (NSUInteger i = 0; i < [times count]; i++) {
            NSInteger time = [[times objectAtIndex:i] integerValue];
            [self addEventWithTime:time duration:duration andMediaObjectID:[mediaObjIDs objectAtIndex:0]];
        }
    } else {
        NSRunAlertPanel (@"Incorrect input for stimulus event addition!", 
                         @"Tried to set non compatible value tuples in event addition dialogue.", 
                         @"OK", NULL, NULL);
    }

}

-(void)addEventWithTime:(NSUInteger)time 
               duration:(NSUInteger)duration 
       andMediaObjectID:(NSString*)mediaObjID
{
    if (time > 0
        && duration > 0
        && (presentationController != nil)) {
        
        if (time + duration <= presentationDuration) {
            [presentationController requestAdditionOfEventWithTime:time 
                                                          duration:duration 
                                                  andMediaObjectID:mediaObjID];
        } else {
            [warningMessageLabel setStringValue:TOO_LONG_EVENT_ERROR_MESSAGE];
            [warningMessageLabel setTextColor:[NSColor redColor]];
        }
    }
}

-(void)clearTextFields
{
    [eventTimeField setStringValue:@""];
    [eventDurationField setStringValue:@""];
    [eventMediaObjectIDField setStringValue:@""];
}

-(NSArray*)parseRangeOrList:(NSString*)valueStr
{
    if ([self isRange:valueStr]) {
        NSArray* valueRange = [valueStr componentsSeparatedByString:@":"];
        NSMutableArray* values = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = [[valueRange objectAtIndex:0] integerValue]; 
             i <= [[valueRange objectAtIndex:2] integerValue]; 
             i += [[valueRange objectAtIndex:1] integerValue]) {
            [values addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        return values;
    } else {
        return [valueStr componentsSeparatedByString:@" "];
    }
}

-(BOOL)isRange:(NSString*)rangeStr
{
    if ([[rangeStr componentsSeparatedByString:@":"] count] == 3) {
        return YES;
    }
    
    return NO;
}

-(void)showEvent:(NEStimEvent*)event
{
    if (event) {
        [eventTimeField setStringValue:[NSString stringWithFormat:@"%d", [event time]]];
        [eventDurationField setStringValue:[NSString stringWithFormat:@"%d", [event duration]]];
        [eventMediaObjectIDField setStringValue:[[event mediaObject] getID]];
    } else {
        [self clearTextFields];
    }
}

@end
