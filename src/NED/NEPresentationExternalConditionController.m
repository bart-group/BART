//
//  NEPresentationExternalConditionController.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEPresentationExternalConditionController.h"
#import "CLETUS/COExperimentContext.h"
#import "NEMediaObject.h"
#import "BARTSerialIOFramework/SerialPort.h"

@interface NEPresentationExternalConditionController (PrivateMethods)

-(NSError*)setExternalConditionsForMediaObjects;

@end


@implementation NEPresentationExternalConditionController

COExperimentContext *expContext;
NSArray *mediaObjectsArray;
NSDictionary *dictExternalConditions;

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
        if ( (nil != [self setExternalConditionsForMediaObjects])){
            NSLog(@"Can't init %@", self);
            return nil;
        }
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
        [mutableDictExternalCond setObject:[dictSerialIOPlugins objectForKey:externalCondition] forKey:mediaObjID];
    }
    
    dictExternalConditions = [[NSDictionary alloc] initWithDictionary:mutableDictExternalCond];
    return err;
}

-(BOOL)isConditionFullfilledForMediaObjectID:(NSString*)mediaObjectID
{
    return [(SerialPort*)[dictExternalConditions objectForKey:mediaObjectID] isConditionFullfilled];
        
}


-(void)dealloc
{
    [mediaObjectsArray release];
    [super dealloc];
}


@end