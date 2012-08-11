//
//  NEMediaTextTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaTextTest.h"
#import "NEMediaText.h"


@implementation NEMediaTextTest

-(void)setUp
{
}

-(void)testInitWithIDAndText
{
    NEMediaObject* mediaObject = [[NEMediaText alloc] initWithID:@"foo" andText:@"bar" constrainedBy:@"constraint"];
    
    BOOL success = NO;
    
    if ([[mediaObject getID] compare:@"foo"] == 0) {
        success = YES;
    }
    
    STAssertEquals(YES, success, @"Media object ID did not match the expected one!");
    
    [mediaObject release];
}

-(void)testInitWithIDTextInSizeAndColorAtPostion
{
    NEMediaObject* mediaObject = [[NEMediaText alloc] initWithID:@"baz"
                                                            Text:@"bat"
                                                          inSize:2
                                                        andColor:[NSColor whiteColor]
                                                       atPostion:(NSPoint) {0, 0}
                                                   constrainedBy:@"con"];
    
    BOOL success = NO;
    if (mediaObject) {
        if ([mediaObject isMemberOfClass:[NEMediaText class]]
            && [[mediaObject getID] compare:@"baz"] == 0
            && [[mediaObject getConstraintID] compare:@"con"] == 0) {
            success = YES;
        }
    }
    
    STAssertEquals(YES, success, @"Media object (text) not correctly initialized with ID, text, size, color and position!");
    
    [mediaObject release];
}

-(void)tearDown
{
}

@end
