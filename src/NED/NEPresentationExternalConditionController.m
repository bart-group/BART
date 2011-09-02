//
//  NEPresentationExternalConditionController.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEPresentationExternalConditionController.h"
#import "CLETUS/COExperimentContext.h"
#import "BARTSerialIOFramework/SerialPort.h"
#import "NED/NEStimEvent.h"

@interface NEPresentationExternalConditionController (PrivateMethods)

-(NSError*)setExternalConditionsForMediaObjects;

@end


@implementation NEPresentationExternalConditionController

COExperimentContext *expContext;
NSArray *mediaObjectsArray;
NSDictionary *dictExternalConditions;

NSUInteger numberOfTrialsInBlock;

-(id)initWithMediaObjects:(NSArray*)newMediaObjects
{
    if ((self = [super init])){
        expContext = [COExperimentContext getInstance];
        if (nil == mediaObjectsArray){
            mediaObjectsArray = newMediaObjects;
        }
        else{
            [mediaObjectsArray release];
            mediaObjectsArray = [newMediaObjects retain];
        }
        if ( (nil == [self setExternalConditionsForMediaObjects])){
            NSLog(@"Can't init %@", self);
            return nil;
        }
        numberOfTrialsInBlock = 12;

    }
    return self;
}


-(NSError*)setExternalConditionsForMediaObjects
{
    NSError *err = nil;
    NSDictionary *dictSerialIOPlugins = [expContext dictSerialIOPlugins];
    NSMutableDictionary *mutableDictExternalCond = [[NSMutableDictionary alloc] initWithCapacity:[mediaObjectsArray count]];
    
    //TODO: implement this in EDL
    NSString *externalCondition = @"ASLEyeTrac";
    for (NEMediaObject* mediaObj in mediaObjectsArray)
    {
        NSString *mediaObjID = [mediaObj getID];
        //NSString *externalCondition = [mediaObjID getExternalCondition];
        if (nil != [dictSerialIOPlugins objectForKey:externalCondition]){
            [mutableDictExternalCond setObject:[dictSerialIOPlugins objectForKey:externalCondition] forKey:mediaObjID];
        }
    }
    
    dictExternalConditions = [[NSDictionary alloc] initWithDictionary:mutableDictExternalCond];
    [mutableDictExternalCond release];
    return err;
}

-(NSPoint)isConditionFullfilledForEvent:(NEStimEvent*)event
{
    // todo: get this automatically from config
    NSString *isDynamic = @"";
    NSString *dyn = @"DYN";
    NSString *stat = @"STAT";
    
    if ( NSNotFound != [[[event mediaObject] getID] rangeOfString:dyn options:NSCaseInsensitiveSearch].location ){
        isDynamic = @"YES";
    }
    if ( NSNotFound != [[[event mediaObject] getID] rangeOfString:stat options:NSCaseInsensitiveSearch].location ){
        isDynamic = @"NO";
    }
    
    //setup the params dictionary
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:isDynamic, @"isDynamic", 
                          [NSNumber numberWithFloat:[[event mediaObject] position].x], @"xPosition",
                          [NSNumber numberWithFloat:[[event mediaObject] position].y], @"yPosition",
                          nil];
    
    
    //call the external device and ask all your questions
    SerialPort* s = [dictExternalConditions objectForKey:[[event mediaObject] getID]];
    if (nil != s){
        return [s isConditionFullfilled:params];
    }
    else
    {
       return NSMakePoint(400.0, 300.0);
    }
    return NSMakePoint(0.0, 0.0);
        
}

-(NSEvent*)getAction:(NSEvent*)event
{
        
}

-(void)dealloc
{
    [mediaObjectsArray release];
    [dictExternalConditions release];
    [super dealloc];
}


@end