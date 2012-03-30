//
//  NEFeedbackObject.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/12/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEFeedbackObject.h"

/** Time interval between two tick function calls. */
static const NSTimeInterval UPDATE_INTERVAL = 1.0 / 30.0;


@implementation NEFeedbackObject

-(id)init
{
    return nil;
}

-(id)initWithFrame:(NSRect)frameRect
{
    #pragma unused(frameRect)
    return nil;
}

-(id)initWithFrame:(NSRect)frame
     andParameters:(NSDictionary*)params 
{
    if ((self = [super initWithFrame:frame])) {
        if (params) {
            parameters = [params retain];
        } else {
            parameters = [[NSDictionary dictionary] retain];
        }
        
        mTickThread = [[NSThread alloc] initWithTarget:self selector:@selector(runTickThread) object:nil];
        [mTickThread start];
    }
    
    return self;
}

-(void)dealloc
{
    [parameters release];
    [mTickThread release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    #pragma unused(dirtyRect)
    return;
}

-(void)setParameters:(NSDictionary*)newParams
{
    [parameters release];
    parameters = [newParams retain];
}

-(void)runTickThread
{
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];    

    do {
        [self tick];
        [self display];
        [NSThread sleepForTimeInterval:UPDATE_INTERVAL];
    } while (![[NSThread currentThread] isCancelled]);
    
    [autoreleasePool drain];
    autoreleasePool = nil;
    
    [NSThread exit];
}

-(void)tick
{
    return;
}

@end
