//
//  NEMediaObjectTest.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/9/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaObjectTest.h"
#import "NEMediaObject.h"
#import "NEMediaText.h"
#import "NEMediaAudio.h"


@implementation NEMediaObjectTest

-(void)setUp
{
    config = [COSystemConfig getInstance];
    [config fillWithContentsOfEDLFile:@"pseudoStimulusDataFree.edl"];
}

-(void)testInitWithConfigEntry
{
    NSString* entryKeyText  = @"/rtExperiment/stimulusData/mediaObjectList/mediaObject[1]";
    NEMediaObject* objText  = [[NEMediaObject alloc] initWithConfigEntry:entryKeyText];
    BOOL textSuccess  = [objText isMemberOfClass:[NEMediaText class]];
    
    NSString* entryKeyAudio = @"/rtExperiment/stimulusData/mediaObjectList/mediaObject[5]";
    NEMediaObject* objAudio = [[NEMediaObject alloc] initWithConfigEntry:entryKeyAudio];
    BOOL audioSuccess = [objAudio isMemberOfClass:[NEMediaAudio class]];
    
    STAssertEquals(YES, textSuccess, @"Media object is no NEMediaText object!");
    STAssertEquals(YES, audioSuccess, @"Media object is no NEMediaAudio object!");
    
    [objText release];
    [objAudio release];
}

-(void)tearDown
{
}

@end
