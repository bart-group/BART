//
//  NEPresentationControlView.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NETimelineView.h"
#import "NETimelineWindowController.h"


/** 
 * Distance between the axis of coordinates and the
 * timeline view boundaries/frame. 
 */
static const CGFloat FRAME_PADDING = 40.0;

/**
 * The drawn base height of an event in the coordinate
 * system.
 */
static const CGFloat EVENT_BAR_HEIGHT = 20.0;

/**
 * The edge length of the little squares shown on the
 * selected event bar.
 */
static const CGFloat DRAGGER_EDGE_LENGTH = 5.0;


@interface NETimelineView (PrivateMethods)

/**
 * Draws the coordinate system incl. legend.
 * Invoked by drawRect:.
 *
 * \param rect The NSRect to draw in.
 */
-(void)drawCoordinateSystem:(NSRect)rect;

/**
 * Draws a bar for each event into the coordinate system.
 * Invoked by drawRect:.
 *
 * \param rect The NSRect to draw in.
 */
-(void)drawEventBars:(NSRect)rect;

/**
 * Draws little squares used to manipulate the selected
 * event.
 */
-(void)drawSelectedEventMarkers;

/**
 * Draws the area dragged by the user (timespan).
 * Invoked by drawRect:.
 *
 * \param rect The NSRect to draw in.
 */
-(void)drawDraggedArea:(NSRect)rect;

/**
 * Draws the current time (red vertical line) with seconds counter
 * into the coordinate system.
 * Invoked by drawRect:.
 *
 * \param rect The NSRect to draw in.
 */
-(void)drawCurrentTimeLine:(NSRect)rect;

/**
 * Returns the NEStimEvent whose graphical representation
 * (colored rectangle) contains a given point.
 *
 * \param point A point that might lay within the graphical
 *              representation of a NEStimEvent.
 * \return      The NEStimEvent whose graphical representation
 *              contains point. Nil if no such event is
 *              found.
 */
-(NEStimEvent*)getEventForClickedPoint:(NSPoint)point;

/**
 * Determines whether a given point lies within the
 * coordinate system presented in the view.
 *
 * \param point The point that needs to be checked.
 * \return      YES if the point lies within the 
 *              coordinate system - NO if not.
 */
-(BOOL)isPointInCoordinateSystem:(NSPoint)point;

/**
 * Helper method.
 * Returns the NEGrabSpot for a NEStimEvent that was
 * clicked/dragged at mMouseDownPoint.
 * Before calling make sure mMouseDownPoint hit the event.
 *
 * \return The NEGrabSpot at which event was clicked/dragged.
 */
-(enum NEGrabSpot)grabSpotOfEvent:(NEStimEvent*)event;

/**
 * Fills the frame given by rect with nothing but black color.
 *
 * \param context Graphics context to use.
 * \param rect    Area that should be painted black.
 */
-(void)clearView:(CGContextRef)context 
                :(NSRect)rect;

/**
 * Entry point for the drawing thread which continuously
 * redraws the timeline view.
 */
-(void)runDrawThread;

@end


@implementation NETimelineView

@synthesize selectedEvent;

-(id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        mCurrentTime     = 0;
        mTimetable       = [[NETimetable alloc] init];
        mMouseDownPoint  = (NSPoint) {-1.0, -1.0};
        mMouseUpPoint    = (NSPoint) {-1.0, -1.0};
        selectedEvent    = nil;
        mSelectedEventBarY = -1.0 * EVENT_BAR_HEIGHT - 1.0;
        mLowerWestSquare.origin = (NSPoint) {-1.0 * DRAGGER_EDGE_LENGTH - 1.0, -1.0 * DRAGGER_EDGE_LENGTH - 1.0};
        mLowerWestSquare.size   = (NSSize)  {DRAGGER_EDGE_LENGTH, DRAGGER_EDGE_LENGTH};
        mMidCenterSquare.origin = (NSPoint) {-1.0 * DRAGGER_EDGE_LENGTH - 1.0, -1.0 * DRAGGER_EDGE_LENGTH - 1.0};
        mMidCenterSquare.size   = (NSSize)  {DRAGGER_EDGE_LENGTH, DRAGGER_EDGE_LENGTH};
        mUpperEastSquare.origin = (NSPoint) {-1.0 * DRAGGER_EDGE_LENGTH - 1.0, -1.0 * DRAGGER_EDGE_LENGTH - 1.0};
        mUpperEastSquare.size   = (NSSize)  {DRAGGER_EDGE_LENGTH, DRAGGER_EDGE_LENGTH};
        mGrabbedAt       = NOT_GRABBED;

        [self setCanDrawConcurrently:YES];
        [NSThread detachNewThreadSelector:@selector(runDrawThread) toTarget:self withObject:nil];
    }
    
    return self;
}

-(void)runDrawThread
{
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    [[NSThread currentThread] setThreadPriority:0.6];

    do {
        [self setNeedsDisplay:YES];
        [NSThread sleepForTimeInterval:0.037];
    } while (![[NSThread currentThread] isCancelled]);
    
    [autoreleasePool drain];
    autoreleasePool = nil;
    
    [NSThread exit];
}

-(void)dealloc
{
    [mTimetable release];
    [super dealloc];
}

-(void)setTimetable:(NETimetable*)timetable
{
    [timetable retain];
    [mTimetable release];
    mTimetable = timetable;
        
    
    NSRect newFrame;
    newFrame.origin.x    = 0.0;//[self frame].origin.x;
    newFrame.origin.y    = 0.0;//[self frame].origin.y;
    newFrame.size.width  = (2.0 * FRAME_PADDING) + ([mTimetable duration] / 100.0); // 10px per second + padding
    newFrame.size.height = (2.0 * FRAME_PADDING) + ([mTimetable numberOfMediaObjects] * EVENT_BAR_HEIGHT);
    
    [self setFrame:newFrame];
    [self setBounds:newFrame];
    [self setNeedsDisplay:YES];
}

-(void)setCurrentTime:(NSUInteger)newCurrentTime
{
    mCurrentTime = newCurrentTime;
}

-(void)clearSelection
{
    selectedEvent = nil;
    mGrabbedAt    = NOT_GRABBED;
}

-(void)drawRect:(NSRect)rect
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    [self clearView:context :rect];
    CGContextSelectFont(context, "Arial", 11.0, kCGEncodingMacRoman);
    //CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    
    [self drawCoordinateSystem:rect];
    [self drawEventBars:rect];
    [self drawSelectedEventMarkers];
    [self drawCurrentTimeLine:rect];
    [self drawDraggedArea:rect];
}

-(void)drawCoordinateSystem:(NSRect)rect
{
    #pragma unused(rect)
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    // Draw axis of coordinates.
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [NSBezierPath strokeLineFromPoint:NSMakePoint([self frame].origin.x + FRAME_PADDING, [self frame].origin.y + FRAME_PADDING) 
                              toPoint:NSMakePoint([self frame].size.width - FRAME_PADDING, [self frame].origin.y + FRAME_PADDING)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint([self frame].origin.x + FRAME_PADDING, [self frame].origin.y + FRAME_PADDING) 
                              toPoint:NSMakePoint([self frame].origin.x + FRAME_PADDING, [self frame].size.height - FRAME_PADDING)];
    
    // Draw axis legend (one dash each 10px for each second).
    for (NSUInteger curTime = 0; curTime <= [mTimetable duration]; curTime += 1000) {
        [NSBezierPath strokeLineFromPoint:NSMakePoint((curTime / 100.0 + FRAME_PADDING), [self frame].origin.y + FRAME_PADDING - 5.0) 
                                  toPoint:NSMakePoint((curTime / 100.0 + FRAME_PADDING), [self frame].origin.y + FRAME_PADDING)];
    }
}

-(void)drawEventBars:(NSRect)rect
{
    #pragma unused(rect)
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    NSUInteger mediaObjNr = 0;
    

    for (NSString* mediaObjID in [mTimetable getAllMediaObjectIDs]) {
        NSArray* happenedEvents = [[mTimetable happenedEventsForMediaObjectID:mediaObjID] retain];
        NSArray* eventsToHappen = [[mTimetable eventsToHappenForMediaObjectID:mediaObjID] retain];
        
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0); 
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0); 
        CGContextShowTextAtPoint(context, 5.0, (mediaObjNr * EVENT_BAR_HEIGHT) + FRAME_PADDING + 4.0, [mediaObjID cStringUsingEncoding:NSUTF8StringEncoding], [mediaObjID length]);
        
        for (NEStimEvent* event in happenedEvents) {
            NSRect eventRect;
            eventRect.origin.x    = ((CGFloat)[event time] / (CGFloat)[mTimetable duration]) * ([self frame].size.width - (2.0 * FRAME_PADDING)) + FRAME_PADDING;
            eventRect.origin.y    = (mediaObjNr * EVENT_BAR_HEIGHT) + FRAME_PADDING;
            eventRect.size.height = EVENT_BAR_HEIGHT;
            eventRect.size.width  = ([event duration] / 100.0);
            CGContextSetRGBFillColor(context, (mediaObjNr + 1.0) / [mTimetable numberOfMediaObjects], 1.0, (mediaObjNr + 1.0) / [mTimetable numberOfMediaObjects], 1.0);
            CGContextFillRect(context, eventRect);
        }
        [happenedEvents release];
        for (NEStimEvent* event in eventsToHappen) {
            NSRect eventRect;
            eventRect.origin.x    = ((CGFloat)[event time] / (CGFloat)[mTimetable duration]) * ([self frame].size.width - (2.0 * FRAME_PADDING)) + FRAME_PADDING;
            eventRect.origin.y    = (mediaObjNr * EVENT_BAR_HEIGHT) + FRAME_PADDING;
            eventRect.size.height = EVENT_BAR_HEIGHT;
            eventRect.size.width  = ([event duration] / 100.0);
            CGContextSetRGBFillColor(context, (mediaObjNr + 1.0) / [mTimetable numberOfMediaObjects], 1.0, (mediaObjNr + 1.0) / [mTimetable numberOfMediaObjects], 1.0);
            CGContextFillRect(context, eventRect);
        }
        [eventsToHappen release];
        mediaObjNr++;
    }
}

-(void)drawSelectedEventMarkers
{
    if (selectedEvent) {
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1.0);
        
        CGContextFillRect(context, mLowerWestSquare);
        CGContextFillRect(context, mMidCenterSquare);
        CGContextFillRect(context, mUpperEastSquare);
    }
}

-(void)drawDraggedArea:(NSRect)rect
{
    #pragma unused(rect)
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSetRGBStrokeColor(context, 0.5, 0.0, 1.0, 1.0); 
    CGContextSetRGBFillColor(context, 0.5, 0.0, 1.0, 1.0);
    [NSBezierPath strokeLineFromPoint:NSMakePoint(mMouseDownPoint.x, [self frame].origin.y) 
                              toPoint:NSMakePoint(mMouseDownPoint.x, [self frame].size.height)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(mMouseUpPoint.x, [self frame].origin.y) 
                              toPoint:NSMakePoint(mMouseUpPoint.x, [self frame].size.height)];
    
    if (selectedEvent && (mGrabbedAt != NOT_GRABBED)) {
        CGContextSetRGBFillColor(context, 0.5, 0.0, 1.0, 0.7);
        NSRect tempBarRect = NSMakeRect(mMouseDownPoint.x, mSelectedEventBarY, mMouseUpPoint.x - mMouseDownPoint.x, EVENT_BAR_HEIGHT);
        CGContextFillRect(context, tempBarRect);
    }
    
    if (mMouseDownPoint.x - FRAME_PADDING >= 0.0) {
        NSString* currentTimeString = [NSString stringWithFormat:@"%.3fs", (mMouseDownPoint.x - FRAME_PADDING) / 10.0];
        CGContextShowTextAtPoint(context, mMouseDownPoint.x + 2.0, FRAME_PADDING - 35.0, 
                                 [currentTimeString cStringUsingEncoding:NSUTF8StringEncoding], [currentTimeString length]);
    }
    
    if (mMouseUpPoint.x - FRAME_PADDING >= 0.0) {    
        NSString* currentTimeString = [NSString stringWithFormat:@"%.3fs", (mMouseUpPoint.x - FRAME_PADDING) / 10.0];
        CGContextShowTextAtPoint(context, mMouseUpPoint.x + 2.0, FRAME_PADDING - 25.0, 
                                 [currentTimeString cStringUsingEncoding:NSUTF8StringEncoding], [currentTimeString length]);
    }
}

-(void)drawCurrentTimeLine:(NSRect)rect
{
    #pragma unused(rect)
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); 
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGFloat timeCursorPosition = ((CGFloat)mCurrentTime / (CGFloat)[mTimetable duration]) * ([self frame].size.width - (2.0 * FRAME_PADDING));
    [NSBezierPath strokeLineFromPoint:NSMakePoint(timeCursorPosition + FRAME_PADDING, [self frame].origin.y) 
                              toPoint:NSMakePoint(timeCursorPosition + FRAME_PADDING, [self frame].size.height)];
    
    NSString* currentTimeString = [NSString stringWithFormat:@"%.3fs", mCurrentTime / 1000.0];
    CGContextShowTextAtPoint(context, timeCursorPosition + FRAME_PADDING + 2.0, FRAME_PADDING - 15.0, 
                             [currentTimeString cStringUsingEncoding:NSUTF8StringEncoding], [currentTimeString length]);    
}

-(void)mouseDown:(NSEvent*)theEvent
{
    mMouseDownPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mMouseUpPoint   = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if (selectedEvent) {
        // Already selected event gets manipulated.
        if (NSPointInRect(mMouseDownPoint, mLowerWestSquare)) {
            mGrabbedAt = LOWERWEST_GRABBED;
        } else if (NSPointInRect(mMouseDownPoint, mMidCenterSquare)) {
            mGrabbedAt = MIDCENTER_GRABBED;
        } else if (NSPointInRect(mMouseDownPoint, mUpperEastSquare)) {
            mGrabbedAt = UPPEREAST_GRABBED;
        } else {
            [self clearSelection];
        }
    }
    
    if (!selectedEvent) {
        // No event is currently selected. Try to find one at the 
        // location pointed by the user.
        if ([self isPointInCoordinateSystem:mMouseDownPoint]) {
            selectedEvent = [self getEventForClickedPoint:mMouseDownPoint];
            mGrabbedAt = NOT_GRABBED;
        } else {
            [self clearSelection];
        }
        
        // TODO: use responder chain
        id controller = [[self window] windowController];
        if ([controller respondsToSelector:@selector(showEventInControlWindow:)]) {
            [controller showEventInControlWindow:selectedEvent];
        }
    }
//    [self setNeedsDisplay:YES];
}

-(void)mouseDragged:(NSEvent*)theEvent
{
    mMouseUpPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent*)theEvent
{
    mMouseUpPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (mMouseUpPoint.x < FRAME_PADDING) {
        mMouseUpPoint.x =  FRAME_PADDING;
    }
    if (mMouseUpPoint.x > [self frame].size.width - FRAME_PADDING) {
        mMouseUpPoint.x = [self frame].size.width - FRAME_PADDING;
    }

    if (selectedEvent && (mGrabbedAt != NOT_GRABBED)) {
        NSInteger newTime = -1;
        NSInteger newDuration = -1;
        if (mGrabbedAt == LOWERWEST_GRABBED) {
            newTime     = ((NSUInteger)(mMouseUpPoint.x - FRAME_PADDING)) * 100;
            newDuration = [selectedEvent duration] + ([selectedEvent time] - newTime);
        } else if (mGrabbedAt == UPPEREAST_GRABBED) {
            newTime     = [selectedEvent time];
            newDuration = (((NSUInteger)(mMouseUpPoint.x - FRAME_PADDING)) * 100 - newTime);
        } else if (mGrabbedAt == MIDCENTER_GRABBED) {
            newTime = ((NSUInteger)(mMouseUpPoint.x - FRAME_PADDING)) * 100 - ([selectedEvent duration] / 2);
            newDuration = [selectedEvent duration];
            if (newTime < 0) {
                newTime = 0;
            }            
        }
        
        if (newTime < 0) {
            newTime = 0;
        }
        if (newDuration < 0) {
            newDuration = 0;
        }
        if ((NSUInteger)newTime + newDuration > [mTimetable duration]) {
            newTime = [mTimetable duration] - newDuration;
        }
        
        NEStimEvent* newEvent = [[[NEStimEvent alloc] initWithTime:newTime
                                                          duration:newDuration
                                                       mediaObject:[selectedEvent mediaObject]] 
                                         autorelease];
        
        id controller = [[self window] windowController];
        if ([controller respondsToSelector:@selector(replaceEvent:withEvent:)]) {
            [controller replaceEvent:selectedEvent 
                           withEvent:newEvent];
        }
        
        [self clearSelection];
//        [self setNeedsDisplay:YES];
    }
}

-(NEStimEvent*)getEventForClickedPoint:(NSPoint)point
{
    NSUInteger timeForEvent       = ((NSUInteger)(point.x - FRAME_PADDING)) * 100;
    NSUInteger mediaObjNrForEvent = ((NSUInteger)(point.y - FRAME_PADDING)) / 20;
    NSString* keyForEventList     = [[mTimetable getAllMediaObjectIDs] objectAtIndex:mediaObjNrForEvent];
    
    NSEnumerator* eventEnumerator = [[mTimetable eventsToHappenForMediaObjectID:keyForEventList] objectEnumerator];
    NEStimEvent* event;
    while ((event = [eventEnumerator nextObject])) {
        if ([event time] <= timeForEvent
            && ([event time] + [event duration]) >= timeForEvent) {
            
            mLowerWestSquare.origin.x = ([event time] / 100.0) + FRAME_PADDING;
            mLowerWestSquare.origin.y = (mediaObjNrForEvent * EVENT_BAR_HEIGHT) + FRAME_PADDING; 
            mSelectedEventBarY = mLowerWestSquare.origin.y;
            mMidCenterSquare.origin.x = mLowerWestSquare.origin.x + ([event duration] / 200.0) - (DRAGGER_EDGE_LENGTH / 2.0);
            mMidCenterSquare.origin.y = mLowerWestSquare.origin.y + 8.0;
            mUpperEastSquare.origin.x = ([event time] + [event duration]) / 100.0 + FRAME_PADDING - DRAGGER_EDGE_LENGTH;
            mUpperEastSquare.origin.y = ((mediaObjNrForEvent + 1) * EVENT_BAR_HEIGHT) + FRAME_PADDING - DRAGGER_EDGE_LENGTH;

            return event;
        }
    }
    
    return nil;
}
-(BOOL)isPointInCoordinateSystem:(NSPoint)point
{
    if (point.x < FRAME_PADDING 
        || point.x >= [self frame].size.width - FRAME_PADDING
        || point.y < FRAME_PADDING
        || point.y >= [self frame].size.height - FRAME_PADDING) {
        return NO;
    }
    
    return YES;
}
-(enum NEGrabSpot)grabSpotOfEvent:(NEStimEvent*)event
{
    CGFloat eventXMin = ([event time] / 100.0) + FRAME_PADDING;
    CGFloat eventXMax = (([event time] + [event duration]) / 100.0) + FRAME_PADDING;
    if (mMouseDownPoint.x < eventXMin + 4.0) {
        return LOWERWEST_GRABBED;
    } else if (mMouseDownPoint.x > eventXMax - 4.0) {
        return UPPEREAST_GRABBED;
    } else {
        return MIDCENTER_GRABBED;
    }
}

-(void)clearView:(CGContextRef)context 
                :(NSRect)rect 
{
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, rect);
}

@end
