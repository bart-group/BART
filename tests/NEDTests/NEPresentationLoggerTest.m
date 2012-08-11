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
    [logger log:entry1 withTime:120];
    [logger log:entry2 withTime:1000];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%H:%M:%S.%F" allowNaturalLanguage:NO];
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];
    
    NSDictionary *testDictionary1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [dateFormatter stringFromDate:[NSDate date]], @"Time",
                                   [logFormatter stringForOnsetTime:120], @"Onset",
                                   @"0", @"Trigger",
                                   @"Message", @"EventIdent",
                                   entry1, @"EventDescription",
                                   
                                   @"0", @"Duration",
                                   @"0", @"Pos",
                                   nil];
    
    NSDictionary *testDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [dateFormatter stringFromDate:[NSDate date]], @"Time",
                                     [logFormatter stringForOnsetTime:1000], @"Onset",
                                     @"0", @"Trigger",
                                     @"Message", @"EventIdent",
                                     entry2, @"EventDescription",
                                     
                                     @"0", @"Duration",
                                     @"0", @"Pos",
                                     nil];

    
    // GET MESSAGES FROM LOGGER
    NSArray* messages = [logger messages];
    
    BOOL success = NO;
    if ([messages count] == 2) {
            success = YES;
    }
    STAssertTrue(success, @"Logging and receiving messages does not work properly!");
    
    NSDictionary* resDict0 = [messages objectAtIndex:0];
    NSDictionary* resDict1 = [messages objectAtIndex:1];
    STAssertEqualObjects([resDict0 objectForKey:@"Onset"], [testDictionary1 objectForKey:@"Onset"] ,@"Logging onsets doesn't fit");
    STAssertEqualObjects([resDict0 objectForKey:@"Trigger"], [testDictionary1 objectForKey:@"Trigger"] ,@"Logging trigger doesn't fit");
    STAssertEqualObjects([resDict0 objectForKey:@"EventIdent"], [testDictionary1 objectForKey:@"EventIdent"] ,@"Logging EventIdent doesn't fit");
    STAssertEqualObjects([resDict0 objectForKey:@"EventDescription"], [testDictionary1 objectForKey:@"EventDescription"] ,@"Logging EventDescription doesn't fit");
    STAssertEqualObjects([resDict0 objectForKey:@"Duration"], [testDictionary1 objectForKey:@"Duration"] ,@"Logging Duration doesn't fit");
    STAssertEqualObjects([resDict0 objectForKey:@"Pos"], [testDictionary1 objectForKey:@"Pos"] ,@"Logging Pos doesn't fit");
    
    STAssertEqualObjects([resDict1 objectForKey:@"Onset"], [testDictionary2 objectForKey:@"Onset"] ,@"Logging onsets doesn't fit");
    STAssertEqualObjects([resDict1 objectForKey:@"Trigger"], [testDictionary2 objectForKey:@"Trigger"] ,@"Logging trigger doesn't fit");
    STAssertEqualObjects([resDict1 objectForKey:@"EventIdent"], [testDictionary2 objectForKey:@"EventIdent"] ,@"Logging EventIdent doesn't fit");
    STAssertEqualObjects([resDict1 objectForKey:@"EventDescription"], [testDictionary2 objectForKey:@"EventDescription"] ,@"Logging EventDescription doesn't fit");
    STAssertEqualObjects([resDict1 objectForKey:@"Duration"], [testDictionary2 objectForKey:@"Duration"] ,@"Logging Duration doesn't fit");
    STAssertEqualObjects([resDict1 objectForKey:@"Pos"], [testDictionary2 objectForKey:@"Pos"] ,@"Logging Pos doesn't fit");
    
    success = NO;
    [logger clear];
    if ([[logger messages] count] == 0) {
        success = YES;
    }
    
    STAssertTrue(success, @"Clearing the log does not work properly!");
    
}


// TODO:
//-(void)logButtonPress:(NSUInteger)button withTrigger:(NSUInteger)triggerNumber andTime:(NSUInteger)t
-(void)testLogButtonPress
{
    [logger clear];
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];
    
    NSUInteger button = 23;
    NSUInteger onsTime = 87653;
    NSUInteger trNr = 0;
    [logger logButtonPress:button withTrigger:trNr andTime:onsTime];
    
    NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [logFormatter stringForOnsetTime:onsTime], @"Onset",
                                   [logFormatter stringForTriggerNumber:trNr], @"Trigger",
                                   [logFormatter buttonIdentifier], @"EventIdent",
                                   [logFormatter stringForButtonPress:button], @"EventDescription",
                                   @"0", @"Duration",
                                   @"0", @"Pos",
                                   nil];

    NSDictionary* resDict = [[logger messages] objectAtIndex:0];
    
    STAssertEqualObjects([resDict objectForKey:@"Onset"], [testDictionary objectForKey:@"Onset"] ,@"Logging onsets doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Trigger"], [testDictionary objectForKey:@"Trigger"] ,@"Logging trigger doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventIdent"], [testDictionary objectForKey:@"EventIdent"] ,@"Logging EventIdent doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventDescription"], [testDictionary objectForKey:@"EventDescription"] ,@"Logging EventDescription doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Duration"], [testDictionary objectForKey:@"Duration"] ,@"Logging Duration doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Pos"], [testDictionary objectForKey:@"Pos"] ,@"Logging Pos doesn't fit");
    
    [logger clear];

}

//TODO:
-(void)testLogAction
{
    [logger clear];
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];
    
    NSUInteger onsTime = 1000;
    NSUInteger trNr = 0;
    NSString* descr = @"just a description";
    [logger logAction:descr withTrigger:trNr andTime:onsTime];
    
    NSDictionary *testDictionary  = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [logFormatter stringForOnsetTime:onsTime], @"Onset",
                                     [logFormatter stringForTriggerNumber:trNr], @"Trigger",
                                     [logFormatter actionIdentifier], @"EventIdent",
                                     descr, @"EventDescription",
                                     @"0", @"Duration",
                                     @"0", @"Pos",
                                     nil];
    
    NSDictionary* resDict = [[logger messages] objectAtIndex:0];
    
    STAssertEqualObjects([resDict objectForKey:@"Onset"], [testDictionary objectForKey:@"Onset"] ,@"Logging onsets doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Trigger"], [testDictionary objectForKey:@"Trigger"] ,@"Logging trigger doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventIdent"], [testDictionary objectForKey:@"EventIdent"] ,@"Logging EventIdent doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventDescription"], [testDictionary objectForKey:@"EventDescription"] ,@"Logging EventDescription doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Duration"], [testDictionary objectForKey:@"Duration"] ,@"Logging Duration doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Pos"], [testDictionary objectForKey:@"Pos"] ,@"Logging Pos doesn't fit");
    
    [logger clear];


}

//TODO
-(void)testStartEventLog
{
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];

}

//TODO
-(void)testEndEventLog
{
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];
    
}


-(void)testLogTrigger
{
    [logger clear];
    NELogFormatter* logFormatter  = [[NELogFormatter alloc] init];
    
    NSUInteger onsTime = 134000;
    NSUInteger trNr = 198;
    [logger logTrigger:trNr withTime:onsTime];
    
    NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [logFormatter stringForOnsetTime:onsTime], @"Onset",
                                   [logFormatter stringForTriggerNumber:trNr], @"Trigger",
                                   [logFormatter triggerIdentifier], @"EventIdent",
                                   [logFormatter stringForTriggerNumber:trNr], @"EventDescription",
                                   @"0", @"Duration",
                                   @"0", @"Pos",
                                   nil];

    NSDictionary* resDict = [[logger messages] objectAtIndex:0];
    
    STAssertEqualObjects([resDict objectForKey:@"Onset"], [testDictionary objectForKey:@"Onset"] ,@"Logging onsets doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Trigger"], [testDictionary objectForKey:@"Trigger"] ,@"Logging trigger doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventIdent"], [testDictionary objectForKey:@"EventIdent"] ,@"Logging EventIdent doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"EventDescription"], [testDictionary objectForKey:@"EventDescription"] ,@"Logging EventDescription doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Duration"], [testDictionary objectForKey:@"Duration"] ,@"Logging Duration doesn't fit");
    STAssertEqualObjects([resDict objectForKey:@"Pos"], [testDictionary objectForKey:@"Pos"] ,@"Logging Pos doesn't fit");
    
    [logger clear];
    
}

//TODO
-(void)testLogConditions
{
    //has to be implemented
}

//TODO:
//TESTS FOR Writing

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
