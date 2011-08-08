//
//  NEPresentationLoggerTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/28/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEPresentationLoggerTest.h"


@implementation NEPresentationLoggerTest

-(void)setUp
{
    logger = [NEPresentationLogger getInstance];
    config = [[COExperimentContext getInstance] systemConfig];
    [config fillWithContentsOfEDLFile:@"pseudoStimulusDataFree.edl"];
}

-(void)testLogMessagesClear
{
    [logger clear];
    
    NSString* entry1 = @"foo";
    NSString* entry2 = @"bar";
    [logger log:entry1];
    [logger log:entry2];
    NSArray* messages = [logger messages];
    
    BOOL success = NO;
    if ([messages count] == 2) {
        if ([[messages objectAtIndex:0] hasSuffix:entry1]
            && [[messages objectAtIndex:1] hasSuffix:entry2]) {
            success = YES;
        }
    }
    
    STAssertTrue(success, @"Logging and receiving messages does not work properly!");
    
    success = NO;
    [logger clear];
    if ([[logger messages] count] == 0) {
        success = YES;
    }
    
    STAssertTrue(success, @"Clearing the log does not work properly!");
}

//-(void)testAllMessagesViolatingTolerance
//{
//    [logger clear];
//    
//    [logger log:@"T:0"];
//    [NSThread sleepForTimeInterval:0.003];
//    [logger log:@"SE:{0,1000,mo1} T:0 TTIME:0"];
//    [NSThread sleepForTimeInterval:0.997];
//    [logger log:@"SE:{1000,1000,mo2} T:0 TTIME:1000"];
//    [logger log:@"EE:{0,1000,mo1} T:0 TTIME:1000"];
//    [NSThread sleepForTimeInterval:1.0];
//    [logger log:@"T:1"];
//    [logger log:@"EE:{1000,1000,mo2} T:1 TTIME:0"];
//    [NSThread sleepForTimeInterval:0.006];
//    [logger log:@"SE:{2000,1000,mo1} T:1 TTIME:0"];
//    [NSThread sleepForTimeInterval:0.994];
//    [logger log:@"EE:{2000,1000,mo1} T:1 TTIME:0"];
//    [NSThread sleepForTimeInterval:1.0];
//    [logger log:@"T:2"];
//    [logger log:@"SE:{4000,1000,mo1} T:2 TTIME:0"];
//    [NSThread sleepForTimeInterval:1.011];
//    [logger log:@"EE:{4000,1000,mo1} T:2 TTIME:0"];
//    
//    [logger printToFilePath:@"/tmp/logPresentationEvents.txt"];
//    
//    NSArray* violations = [logger allMessagesViolatingTolerance:2];
//    FILE* fp = fopen("/tmp/eventTimeViolations.txt", "w");
//    for (NSString* violation in violations) {
//        fprintf(fp, "%s\n", [violation cStringUsingEncoding:NSUTF8StringEncoding]);
//    }
//    fclose(fp);
//}

-(void)tearDown
{
}

@end
