//
//  NEPresentationEventTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEStimEventTest.h"
#import "NEStimEvent.h"
#import "NEMediaText.h"


@implementation NEStimEventTest

-(void)setUp
{
}

-(void)testInitWithTimeMediaObjectAndIsEndEvent
{
    NEMediaText* mediaObj = [[NEMediaText alloc] initWithID:@"foo"
                                                    andText:@"bar"
                                              constrainedBy:@"con"
                                           andRegAssignment:nil];
    NEStimEvent* event = [[NEStimEvent alloc] initWithTime:42 duration:43 mediaObject:mediaObj];
    
    BOOL success = NO;
    if ([event time] == 42
        && [event duration] == 43
        && [event mediaObject] == mediaObj) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Stimulus event was not initialized correctly!");
    
    [mediaObj release];
    [event release];
}

-(void)tearDown
{
}

@end
