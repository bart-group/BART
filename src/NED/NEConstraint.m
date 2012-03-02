//
//  NEConstraint.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 2/28/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEConstraint.h"
#import "CLETUS/COExperimentContext.h"

@interface NEConstraint (PrivateMethods)

-(NSArray*)createActionListForType:(NSString*)type;
-(NSArray*)createAllAvailableActions;
@end

@implementation NEConstraint

@synthesize isActive;
@synthesize constraintActionsThen;
@synthesize constraintID;
@synthesize constraintActionsElse;
@synthesize systemVariables;
@synthesize constraintConditions;

-(id)init
{

    if (self = [super init])
    {
        constraintID = @"";
        isActive = NO;
        systemVariables = NULL;
        constraintConditions = NULL;
        constraintActionsThen = NULL;
        constraintActionsElse = NULL;
    }
    return self;
}


-(id)initWithConfigEntry:(NSString*)key
{
    
    if (self = [super init])
    {
        COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    
        // (1) set ID and status
        constraintID = [config getProp:[NSString stringWithFormat:@"%@/@constraintID", key]];
        isActive = YES;
        
        // (2) read all available systemVariables
        NSMutableArray *arrayVariables = [NSMutableArray arrayWithCapacity:1];
        //read all available systemVariables
        NSUInteger counterSystemVariables = [config countNodes:[NSString stringWithFormat:@"%@/systemVariables/systemVariable", key]];
        //NSString *sysVariables = [config getProp:[NSString stringWithFormat:@"%@/systemVariables/systemVariable[1]", key]];
        for (NSUInteger index = 0; index < counterSystemVariables; index++) {

            NSString *source = [config getProp:[NSString stringWithFormat:@"%@/systemVariables/systemVariable[%d]/@source", key, counterSystemVariables]];
            NSString *variableName = [config getProp:[NSString stringWithFormat:@"%@/systemVariables/systemVariable[%d]/@variableName", key, counterSystemVariables]];
            
            NSDictionary *dictSystemVariables = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"variableName", variableName, @"source", source, nil];
            
            [arrayVariables addObject:dictSystemVariables];
        }
        systemVariables = [NSArray arrayWithArray:arrayVariables];
        
        // (3) real all available conditions
        NSUInteger nrVariables = [config countNodes:[NSString stringWithFormat:@"%@/condition/systemVariableReference", key]];
        NSMutableArray *arrayConditions = [NSMutableArray arrayWithCapacity:nrVariables];
        for (NSUInteger count = 0; count < nrVariables; count++) {
            NSString *conditionVariable = [config getProp:[NSString stringWithFormat:@"%@/condition/systemVariableReference[%d]/@variableName", key, count]];
            [arrayConditions addObject:conditionVariable];
        } 
        
        constraintConditions = [NSArray arrayWithArray:arrayConditions];

        // (4) read all actions
        constraintActionsThen = [self createActionListForType:@"actions_then"];
        constraintActionsElse = [self createActionListForType:@"actions_else"];
               
        
        
    }

    return self;
}

-(NSArray*)createAllAvailableActions
{

    //todo: in eigene klasse oder global?
    
    NSDictionary *dictActionReplace = [[NSDictionary alloc] initWithObjectsAndKeys:@"replaceMediaObject",@"actionNameInConfig", @"replaceMediaObject",@"actionNameInternal",@"newObject",@"valueToSet", nil];
    NSDictionary *dictActionSetMO = [[NSDictionary alloc] initWithObjectsAndKeys:@"setMediaObjectParameter",@"actionNameInConfig", @"setMediaObjectParamter",@"actionNameInternal",@"parameterName",@"parameterName", @"newValue",@"valueToSet", nil];
    NSDictionary *dictRemoveSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"removeCurrentStimulusEvent",@"actionNameInConfig", @"removeCurrentStimulusEvent",@"actionNameInternal", nil];
    NSDictionary *dictAddSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"addStimulusEvent",@"actionNameInConfig", @"addStimulusEvent",@"actionNameInternal", nil];
    NSDictionary *dictChangeTimingSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"changeTimingStimulusEvent",@"actionNameInConfig", @"changeTimingStimulusEvent", @"actionNameInternal", @"parameterName", @"parameterName", @"newValue",@"valueToSet", nil];
    
    NSArray *allAvailableActions = [[NSArray alloc] initWithObjects:dictActionReplace, dictActionSetMO, dictRemoveSE, dictAddSE, dictChangeTimingSE, nil];
    
    [dictAddSE release];
    [dictActionReplace release];
    [dictActionSetMO release];
    [dictChangeTimingSE release];
    [dictRemoveSE release];
    
    return [allAvailableActions retain];

}

-(NSArray*)createActionListForKey:(NSString *)type
{
    //TODO: Wie verschiedene Fktname und Parameter aufloesen?
    NSString *path = [NSString stringWithFormat:@"$refConstraints/%@", type];
    
    COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    NSUInteger counterActions = [config countNodes:[NSString stringWithFormat:@"%@/action", path] ];
    NSMutableArray *arrayActions = [NSMutableArray arrayWithCapacity:counterActions];
    //NSUInteger counterActionsElse  = [config countNodes:[NSString stringWithFormat:@"%@/action", path ]];
    //NSMutableArray *arrayActionsElse = [NSMutableArray arrayWithCapacity:counterActionsElse];
    
    for (NSUInteger index=0; index < counterActions; index++) {
        //ask each available action
        NSArray *allAvailableActions = [self createAllAvailableActions];
        for (id element in allAvailableActions)
        {
            if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@", path, [element objectForKey:@"actionNameInConfig"] ]] )
            {
                NSString *paraName = NULL;
                NSString *valName = NULL;
                NSString *fctName = [config getProp:[NSString stringWithFormat:@"%@/action/%@", path, [element objectForKey:@"actionNameInternal"] ]];
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"parameterName"] ]] )
                {
                    paraName = [config getProp:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"parameterName"] ]];
                }
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"valueToSet"] ]] )
                {
                    valName = [config getProp:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"valueToSet"] ]];
                }
                
                NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", paraName, @"parameterName", valName, @"valueName", nil];
                [arrayActions addObject:dictAction];
                
            }
            
        }
    }
    return arrayActions;
    //constraintActionsThen = [NSArray arrayWithArray:arrayActionsThen];
    
//    for (NSUInteger index=0; index < counterActionsElse; index++) {
//        //ask each available action
//        for (id element in allAvailableActions)
//        {
//            if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/actions_else/action/%@", key, [element objectForKey:@"actionNameInConfig"] ]] )
//            {
//                NSString *paraName = NULL;
//                NSString *valName = NULL;
//                NSString *fctName = [config getProp:[NSString stringWithFormat:@"%@/actions_else/action/%@", key, [element objectForKey:@"actionNameInternal"] ]];
//                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/actions_else/action/%@/@%@", key, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"parameterName"] ]] )
//                {
//                    paraName = [config getProp:[NSString stringWithFormat:@"%@/actions_else/action/%@/@%@", key, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"parameterName"] ]];
//                }
//                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/actions_else/action/%@/@%@", key, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"valueToSet"] ]] )
//                {
//                    valName = [config getProp:[NSString stringWithFormat:@"%@/actions_else/action/%@/@%@", key, [element objectForKey:@"actionNameInConfig"], [element objectForKey:@"valueToSet"] ]];
//                }
//                
//                NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", paraName, @"parameterName", valName, @"valueName", nil];
//                [arrayActionsElse addObject:dictAction];
//                
//            }
//            
//        }
//    }
    //constraintActionsElse = [NSArray arrayWithArray:arrayActionsElse];

}

@end
