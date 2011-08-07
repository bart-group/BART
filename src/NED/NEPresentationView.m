//
//  NEPresentationView.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEPresentationView.h"
#import "NEFeedbackObject.h"


@interface NEPresentationView (PrivateMethods)

/**
 * Fills the frame given by rect with nothing but black color.
 *
 * \param context Graphics context to use.
 * \param rect    Area that should be painted black.
 */
-(void)clearView:(CGContextRef)context 
                :(NSRect)rect;

@end


@implementation NEPresentationView

//@synthesize feedbackObject;
@synthesize needsDisplay;

-(id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        mMediaObjects     = [[NSMutableArray alloc] initWithCapacity:0];
        mLockMediaObjects = [[NSLock alloc] init];
        mDisplayCounts    = [[NSMutableDictionary alloc] initWithCapacity:0];
//        feedbackObject    = [[NEFeedbackObject alloc] initWithFrame:frameRect];
        feedbackIsSet = NO;
        
        [self setCanDrawConcurrently:YES];
        [self setNeedsDisplay:YES];
    }
    
    return self;
}

-(void)addMediaObject:(NEMediaObject*)mediaObj
{
    [mLockMediaObjects lock];
    if ([mMediaObjects containsObject:mediaObj]) {
        int displayCount = [[mDisplayCounts objectForKey:[mediaObj getID]] intValue];
        displayCount++;
        [mDisplayCounts setObject:[NSNumber numberWithInt:displayCount] forKey:[mediaObj getID]];
        //[mLockMediaObjects unlock];
    } else {
        [mMediaObjects addObject:mediaObj];
        [mDisplayCounts setObject:[NSNumber numberWithInt:1] forKey:[mediaObj getID]];
        //[mLockMediaObjects unlock];
        //[self display];
        [self setNeedsDisplay:YES];
    }
    [mLockMediaObjects unlock];
}

-(void)removeMediaObject:(NEMediaObject*)mediaObj
{
    [mLockMediaObjects lock];
    if ([mMediaObjects containsObject:mediaObj]) {
        int displayCount = [[mDisplayCounts objectForKey:[mediaObj getID]] intValue];
        displayCount--;
        if (displayCount == 0) {
            [mediaObj stopPresentation];
            [mMediaObjects removeObject:mediaObj];
            [mDisplayCounts removeObjectForKey:[mediaObj getID]];
            //[mLockMediaObjects unlock];
            //[self display];
            //return; // To avoid a second unlock.
            [self setNeedsDisplay:YES];
        } else {
            [mDisplayCounts setObject:[NSNumber numberWithInt:displayCount] forKey:[mediaObj getID]];
        }
    }
    [mLockMediaObjects unlock];
}

-(void)removeAllMediaObjects
{
    [mLockMediaObjects lock];
    for (NEMediaObject* mediaObj in mMediaObjects) {
        [mediaObj stopPresentation];
    }
    
    [mMediaObjects removeAllObjects];
    [mDisplayCounts removeAllObjects];
    [mLockMediaObjects unlock];
    
    [self setNeedsDisplay:YES];
}

-(void)pausePresentation
{
    [mLockMediaObjects lock];
    for (NEMediaObject* mediaObj in mMediaObjects) {
        [mediaObj pausePresentation];
    }
    [mLockMediaObjects unlock];
}

-(void)continuePresentation
{
    [mLockMediaObjects lock];
    for (NEMediaObject* mediaObj in mMediaObjects) {
        [mediaObj continuePresentation];
    }
    [mLockMediaObjects unlock];
    
    [self setNeedsDisplay:YES];
}

-(void)setFeedback:(NEFeedbackObject*)feedbackObj
{
    if (feedbackObj == nil
        || feedbackIsSet) {
        [self setSubviews:[NSArray array]];
        feedbackIsSet = NO;
    }
    
    if (feedbackObj) {
        [self addSubview:feedbackObj];
        feedbackIsSet = YES;
    }
}

-(void)drawRect:(NSRect)rect
{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    [self clearView:context :rect];
    
    [mLockMediaObjects lock];
    for (NEMediaObject* mediaObj in mMediaObjects) {
        [mediaObj presentInContext:context andRect:rect];
    }
    [mLockMediaObjects unlock];
    
    [self setNeedsDisplay:NO];
}

-(void)clearView:(CGContextRef)context 
                :(NSRect)rect 
{
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, rect);
}

-(void)dealloc
{
    [mMediaObjects release];
    [mLockMediaObjects release];
    [mDisplayCounts release];
//    [feedbackObject release];
    
    [super dealloc];
}


@end
