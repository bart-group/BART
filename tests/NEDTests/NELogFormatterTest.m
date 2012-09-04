//
//  NELogFormatterTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/4/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NELogFormatterTest.h"
#import "NELogFormatter.h"
#import "NEStimEvent.h"
#import "NEMediaText.h"


@implementation NELogFormatterTest

-(void)testStringForTriggerNumber
{
    NELogFormatter* formatter = [[NELogFormatter alloc] init];
    NSString* expected = [NSString stringWithFormat:@"%5lu", 42];
    
    NSString* actual = [formatter stringForTriggerNumber:42];
    
    BOOL success = NO;
    if ([actual compare:expected] == 0) {
        success = YES;
    }
    
    STAssertTrue(success, @"TriggerNumber to string conversion does not work properly!");
    [formatter release];
}

-(void)testStringForStimEvent
{
    NEMediaText *mObj = [[NEMediaText alloc] initWithID:@"foo" andText:@"bar" constrainedBy:@"constraintID"];
    NEStimEvent* event = [[NEStimEvent alloc] initWithTime:24 
                                                  duration:42 
                                               mediaObject:mObj];
    
    NELogFormatter* formatter = [[NELogFormatter alloc] init];
    
    NSString* expected = [NSString stringWithFormat:@"%@%@%@%ld%@%ld%@%@%@{%.0f %0.f}%@",
                                 [formatter eventIdentifier],
                                 [formatter keyValueSeperator],
                                 [formatter beginSetDelimiter],
                                 24l,
                                 [formatter entrySeperator],
                                 42l,
                                 [formatter entrySeperator],
                                 @"foo",
                                 [formatter entrySeperator],
                                 0.0,
                                 0.0,
                                 [formatter endSetDelimiter]];
    
    NSString* actual = [formatter stringForStimEvent:event];
    
    BOOL success = NO;
    if ([actual compare:expected] == 0) {
        success = YES;
    }
    
    STAssertTrue(success, @"StimEvent to string conversion does not work properly!");
    [formatter release];
    [mObj release];
    [event release];
}

@end
