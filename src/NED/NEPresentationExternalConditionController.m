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
#import "NED/NEConstraint.h"

@interface NEPresentationExternalConditionController (PrivateMethods)

-(NSError*)buildConstraintDictionary;

@end


@implementation NEPresentationExternalConditionController

COExperimentContext *expContext;
NSArray *constraintsArray;
NSDictionary *dictExternalConditions;


-(id)initWithConstraints:(NSArray*)newConstraintsArray
{
    if ((self = [super init])){
        expContext = [COExperimentContext getInstance];
        if (nil == constraintsArray){
            constraintsArray = newConstraintsArray;
        }
        else{
            [constraintsArray release];
            constraintsArray = [newConstraintsArray retain];
        }
        if ( (nil == [self buildConstraintDictionary])){
            NSLog(@"Can't init %@", self);
            return nil;
        }
       
    }
    return self;
}


-(NSError*)buildConstraintDictionary
{
    NSError *err = nil;
    NSDictionary *dictSerialIOPlugins = [expContext dictSerialIOPlugins];
    NSMutableDictionary *mutableDictExternalCond = [[NSMutableDictionary alloc] initWithCapacity:[constraintsArray count]];
    
    //TODO: implement this in EDL
    //vergleichen constraint source und der Eintrag in mediaObjects
    
    //TODO: 
    //DICT zusammenbasteln das zur Laufzeit übergeben werden kann
    //Key -> constraintID, Object dict mit dem ganzen Kram
    //NSString *externalCondition = @"ASLEyeTrac";
    for (NEConstraint* constraint in constraintsArray)
    {
        NSString *constraintID = [constraint constraintID];
        
        // get all sources for external variables and make unique names
        NSSet *uniqueVariableSources = [NSSet setWithArray:[[constraint variables] allValues] ];
        NSLog(@"Number of Sources: %lu", [uniqueVariableSources count]);
        
        for (NSString *externalDevice in uniqueVariableSources) {
            if (nil != [dictSerialIOPlugins objectForKey:externalDevice])
            {
                [mutableDictExternalCond 
                 setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [dictSerialIOPlugins objectForKey:externalDevice], @"Plugin", 
                            [[constraint variables] allKeysForObject:externalDevice], @"ParamsArray", nil ] 
                 forKey:constraintID ];
            }
        }
    }
    
    dictExternalConditions = [[NSDictionary alloc] initWithDictionary:mutableDictExternalCond];
    [mutableDictExternalCond release];
    
    return err;
}

//-(NSPoint)isConditionFullfilledForEvent:(NEStimEvent*)event
-(NSDictionary*)checkConstraintForID:(NSString*)constraintID;
{
    // todo: get this automatically from config
    //conditions und variables in params und das ganze ins setup - NICHT zur Laufzeit vom paradigma
//    NSString *isDynamic = @"";
//    NSString *dyn = @"DYN";
//    NSString *stat = @"STAT";
//    
//    if ( NSNotFound != [[[event mediaObject] getID] rangeOfString:dyn options:NSCaseInsensitiveSearch].location ){
//        isDynamic = @"YES";
//    }
//    if ( NSNotFound != [[[event mediaObject] getID] rangeOfString:stat options:NSCaseInsensitiveSearch].location ){
//        isDynamic = @"NO";
//    }
//    
//    //setup the params dictionary
//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:isDynamic, @"isDynamic", 
//                          [NSNumber numberWithFloat:[[event mediaObject] position].x], @"xPosition",
//                          [NSNumber numberWithFloat:[[event mediaObject] position].y], @"yPosition",
//                          nil];
    
    
    //call the external device and ask all your questions
    //im Block alle aufrufen
    SerialPort* s = [[dictExternalConditions objectForKey:constraintID] objectForKey:@"Plugin"];
//    SerialPort* s = [dictExternalConditions objectForKey:@"Plugin"];
    if (nil != s){
        NSPoint p= [s isConditionFullfilled:[[dictExternalConditions objectForKey:constraintID] objectForKey:@"ParamsArray"]];
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:p.x], @"eyePosX",[NSNumber numberWithFloat:p.y], @"eyePosY", nil];
    }
//    else
//    {
//       return NSMakePoint(400.0, 300.0);
//    }
//    return NSMakePoint(0.0, 0.0);

    return nil;
    
    
}



-(void)dealloc
{
    [constraintsArray release];
    [dictExternalConditions release];
    [super dealloc];
}


@end