//
//  NEXMLFormatterTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/10/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEXMLFormatterTest.h"
#import "COSystemConfig.h"
#import "NETimetable.h"
#import "NEXMLFormatter.h"


@implementation NEXMLFormatterTest

-(void)setUp
{
    config = [COSystemConfig getInstance];
    [config fillWithContentsOfEDLFile:@"pseudoStimulusDataBlock.edl"];
    
    mediaObjects = [NSMutableArray arrayWithCapacity:0];
    
    for (int mediaObjectNr = 1; 
         mediaObjectNr <= [config countNodes:@"/rtExperiment/stimulusData/mediaObjectList/mediaObject"]; 
         mediaObjectNr++) {
        
        NSString* entryKey = [NSString stringWithFormat:@"/rtExperiment/stimulusData/mediaObjectList/mediaObject[%d]", mediaObjectNr];
        NEMediaObject* mObj = [[NEMediaObject alloc] initWithConfigEntry:entryKey];
        [mediaObjects addObject:mObj];
        [mObj release];
    }
    
    timetable = [[NETimetable alloc] initWithConfigEntry:@"/rtExperiment/stimulusData/timeTable" 
                                         andMediaObjects:mediaObjects];
}

-(void)testXMLTreeForTimetable
{
    NEXMLFormatter* xmlFormatter = [[NEXMLFormatter alloc] init];
    NSXMLElement* edlTimetable = [xmlFormatter xmlTreeForTimetable:timetable];
    
    BOOL success = [[edlTimetable name] isEqualToString:@"timeTable"]
                   && [[[edlTimetable childAtIndex:0] name] isEqualToString:@"freeStimulusDesign"];
    
    for (NSXMLNode* stimEventNode in [[edlTimetable childAtIndex:0] children]) {
        
        if ([stimEventNode kind] == NSXMLElementKind) {
            NSUInteger eventTime     = [[[(NSXMLElement*)stimEventNode attributeForName:@"time"] stringValue] integerValue];
            NSUInteger eventDuration = [[[(NSXMLElement*)stimEventNode attributeForName:@"duration"] stringValue] integerValue];
            NSXMLNode* mediaObjectIDNode = [(NSXMLElement*)stimEventNode childAtIndex:0];
            NSString* mediaObjectID = [mediaObjectIDNode stringValue];
            
            NEStimEvent* event = [timetable nextEventAtTime:eventTime];
            
            success = success && (eventTime == [event time])
                              && (eventDuration == [event duration])
                              && [[mediaObjectIDNode name] isEqualToString:@"mObjectID"]
                              && [[[event mediaObject] getID] isEqualToString:mediaObjectID];
        }
    }
    
    STAssertTrue(success, @"Method testXMLTreeForTimetable failed!");

    [xmlFormatter release];
}

-(void)tearDown
{
    [timetable release];
}

@end
