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
@synthesize needsDisplay = _needsDisplay;

dispatch_queue_t serialPresentationViewAccessQueue;

-(id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        serialPresentationViewAccessQueue = dispatch_queue_create("de.mpg.cbs.NEPresentationViewSerialAccessQueue", DISPATCH_QUEUE_SERIAL);
        
        mMediaObjects     = [[NSMutableArray alloc] initWithCapacity:0];
        //mLockMediaObjects = [[NSLock alloc] init];
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
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        if ([mMediaObjects containsObject:mediaObj]) {
            int displayCount = [[mDisplayCounts objectForKey:[mediaObj getID]] intValue];
            displayCount++;
            [mDisplayCounts setObject:[NSNumber numberWithInt:displayCount] forKey:[mediaObj getID]];
        } else {
            [mMediaObjects addObject:mediaObj];
            [mDisplayCounts setObject:[NSNumber numberWithInt:1] forKey:[mediaObj getID]];
            [self setNeedsDisplay:YES];
        }
    });
}

-(void)removeMediaObject:(NEMediaObject*)mediaObj
{
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        if ([mMediaObjects containsObject:mediaObj]) {
            int displayCount = [[mDisplayCounts objectForKey:[mediaObj getID]] intValue];
            displayCount--;
            if (displayCount == 0) {
                [mediaObj stopPresentation];
                [mMediaObjects removeObject:mediaObj];
                [mDisplayCounts removeObjectForKey:[mediaObj getID]];
                [self setNeedsDisplay:YES];
            } else {
                [mDisplayCounts setObject:[NSNumber numberWithInt:displayCount] forKey:[mediaObj getID]];
            }
        }
    });
}

-(void)removeAllMediaObjects
{
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        [mMediaObjects enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id mediaObj, NSUInteger idx, BOOL *stop) {
            
            #pragma unused(stop)
            #pragma unused(idx)
            [mediaObj stopPresentation];
        }];
        
        [mMediaObjects removeAllObjects];
        [mDisplayCounts removeAllObjects];
        [self setNeedsDisplay:YES];
    });
}

-(void)pausePresentation
{
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        [mMediaObjects enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id mediaObj, NSUInteger idx, BOOL *stop) {
            #pragma unused(stop)
            #pragma unused (idx)
            [mediaObj pausePresentation];
        }];
    });
}

-(void)continuePresentation
{
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        [mMediaObjects enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id mediaObj, NSUInteger idx, BOOL *stop) {
            #pragma unused(stop)
            #pragma unused (idx)
            [mediaObj continuePresentation];
        }];
        [self setNeedsDisplay:YES];
    });
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
    dispatch_sync(serialPresentationViewAccessQueue, ^{
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        [self clearView:context :rect];
        [mMediaObjects enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id mediaObj, NSUInteger idx, BOOL *stop) {
            #pragma unused(stop)
            #pragma unused (idx)
            [mediaObj presentInContext:context andRect:rect];
        }];
        [self setNeedsDisplay:NO];
    });
}

-(void)clearView:(CGContextRef)context
                :(NSRect)rect 
{
    //TODO: von außen setzbar machen
    CGContextSetRGBFillColor(context, 0.77255, 0.77255, 0.77255, 1.0);
    CGContextFillRect(context, rect);
}

-(void)dealloc
{
    [mMediaObjects release];
    //[mLockMediaObjects release];
    [mDisplayCounts release];
    dispatch_release(serialPresentationViewAccessQueue);
//    [feedbackObject release];
    
    [super dealloc];
}


@end
