//
//  NEXMLFormatter.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 5/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEXMLFormatter.h"
#import "NETimetable.h"


static NSString* const EDL_ELEM_TIMETABLE = @"timeTable";

static NSString* const EDL_ELEM_FREESTIMULUSDESIGN = @"freeStimulusDesign";
static NSString* const EDL_ATTR_OVERALLPRESLENGTH = @"overallPresLength";

static NSString* const EDL_ELEM_STIMEVENT = @"stimEvent";
static NSString* const EDL_ATTR_TIME = @"time";
static NSString* const EDL_ATTR_DURATION = @"duration";
static NSString* const EDL_ELEM_MEDIAOBJECTID = @"mObjectID";


@interface NEXMLFormatter (PrivateMethods)

/**
 * Helper method for xmlTreeForTimetable:
 * Generates a XML tree from a NEStimEvent.
 *
 * \param event The NEStimEvent to convert.
 * \return      A XML tree representing the stimulus event
 *              according to EDL specification.
 */
-(NSXMLElement*)xmlTreeForStimEvent:(NEStimEvent*)event;

@end


@implementation NEXMLFormatter

+(NEXMLFormatter*)defaultFormatter
{
    /** Default instance of NEXMLFormatter. */
    static NEXMLFormatter* mDefaultFormatter = nil;
    
    if (!mDefaultFormatter) {
        mDefaultFormatter = [[self alloc] init];
    } 
    
    return mDefaultFormatter;
}

-(NSXMLElement*)xmlTreeForTimetable:(NETimetable*)timetable
{
    NSXMLElement* timetableElem = [NSXMLNode elementWithName:EDL_ELEM_TIMETABLE];
    
    NSXMLElement* freeStimulusDesignElem = [NSXMLNode elementWithName:EDL_ELEM_FREESTIMULUSDESIGN];
    NSXMLNode* overallPresLengthAttr = [NSXMLNode attributeWithName:EDL_ATTR_OVERALLPRESLENGTH 
                                                        stringValue:[NSString stringWithFormat:@"%d", [timetable duration]]];
    NSMutableArray* events = [NSMutableArray arrayWithCapacity:0];
    
    // Build start time sorted array of all events.
    for (NSString* mediaObjID in [timetable getAllMediaObjectIDs]) {
        for (NEStimEvent* event in [timetable happenedEventsForMediaObjectID:mediaObjID]) {
            [NEStimEvent startTimeSortedInsertOf:event inEventList:events];
        }
        for (NEStimEvent* event in [timetable eventsToHappenForMediaObjectID:mediaObjID]) {
            [NEStimEvent startTimeSortedInsertOf:event inEventList:events];
        }
    }
    
    // Build XML hierarchy.
    for (NEStimEvent* event in events) {
        [freeStimulusDesignElem addChild:[self xmlTreeForStimEvent:event]];
    }
    [freeStimulusDesignElem addAttribute:overallPresLengthAttr];
    [timetableElem addChild:freeStimulusDesignElem];
    
    return timetableElem;
}

-(NSXMLElement*)xmlTreeForStimEvent:(NEStimEvent*)event
{
    NSXMLElement* stimEventElem = [NSXMLNode elementWithName:EDL_ELEM_STIMEVENT];
    NSXMLNode* timeAttr     = [NSXMLNode attributeWithName:EDL_ATTR_TIME 
                                               stringValue:[NSString stringWithFormat:@"%d", [event time]]];
    NSXMLNode* durationAttr = [NSXMLNode attributeWithName:EDL_ATTR_DURATION 
                                               stringValue:[NSString stringWithFormat:@"%d", [event duration]]];
    NSXMLElement* mediaObjectIDElem = [NSXMLNode elementWithName:EDL_ELEM_MEDIAOBJECTID 
                                                     stringValue:[[event mediaObject] getID]];
    
    // Build element/attribute hierarchy.
    [stimEventElem addChild:mediaObjectIDElem];
    [stimEventElem addAttribute:timeAttr];
    [stimEventElem addAttribute:durationAttr];
    
    return stimEventElem;
}


@end
