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
@synthesize numberOfExternalSources;

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
        //numberOfExternalSources = 0;
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
        NSUInteger counterSystemVariables = [config countNodes:@"$systemVariables/systemVariable"];
        NSMutableDictionary *dictSystemVariables = [NSMutableDictionary dictionaryWithCapacity:counterSystemVariables];
        
        for (NSUInteger index = 0; index < counterSystemVariables; index++) {

            NSString *source = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@source", index]];
            NSString *variableName = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@systemVariableName", index]];
            NSString *variableID = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@systemVariableID", index]];
            
            [dictSystemVariables setObject:[NSDictionary dictionaryWithObjectsAndKeys:source, @"source", variableName, variableName, nil] forKey:variableID];

        }
        systemVariables = [[NSDictionary alloc ] initWithDictionary:dictSystemVariables];//[NSArray arrayWithArray:arrayVariables];
        
        // (3) read all available conditions
        NSUInteger nrVariables = [config countNodes:[NSString stringWithFormat:@"%@/conditions/condition", key]];
        NSMutableArray *arrayConditions = [NSMutableArray arrayWithCapacity:nrVariables];
        for (NSUInteger count = 0; count < nrVariables; count++) {
            NSString *conditionVariable = [config getProp:[NSString stringWithFormat:@"%@/conditions/condition[%d]/systemVariableRef", key, count]];
            [arrayConditions addObject:conditionVariable];
        } 
        
        constraintConditions = [[NSArray alloc] initWithArray:arrayConditions];

        // (4) read all actions
        constraintActionsThen = [[NSArray alloc] initWithArray:[self createActionListForType:@"actions_then"]];
        constraintActionsElse = [[NSArray alloc] initWithArray:[self createActionListForType:@"actions_else"]];
               
        
        
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
    
    NSArray *allAvailableActions = [NSArray arrayWithObjects:dictActionReplace, dictActionSetMO, dictRemoveSE, dictAddSE, dictChangeTimingSE, nil];
    
    [dictAddSE release];
    [dictActionReplace release];
    [dictActionSetMO release];
    [dictChangeTimingSE release];
    [dictRemoveSE release];
    
    return [allAvailableActions autorelease];

}

-(NSArray*)createActionListForType:(NSString *)type
{
    //TODO: Wie verschiedene Fktname und Parameter aufloesen?
    NSString *path = [NSString stringWithFormat:@"$refConstraints/%@", type];
    
    COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    NSUInteger counterActions = [config countNodes:[NSString stringWithFormat:@"%@/action", path] ];
    NSMutableArray *arrayActions = [NSMutableArray arrayWithCapacity:counterActions];
    
    for (NSUInteger index=0; index < counterActions; index++) {
        //ask each available action
        NSArray *allAvailableActions = [self createAllAvailableActions];
        for (NSDictionary *element in allAvailableActions)
        {
            if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@", path, [element objectForKey:@"actionNameInConfig"] ]] )
            {
                NSString *paraName = @"";
                NSString *paraKey = [element valueForKey:@"parameterName"];
                NSString *valName = @"";
                NSString *valKey = [element valueForKey:@"valueToSet"];
                NSString *fctName = [config getProp:[NSString stringWithFormat:@"%@/action/%@", path, [element objectForKey:@"actionNameInConfig"] ]];
                
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], paraKey ]] )
                {
                    paraName = [config getProp:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], paraKey ]];
                }
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], valKey ]] )
                {
                    valName = [config getProp:[NSString stringWithFormat:@"%@/action/%@/@%@", path, [element objectForKey:@"actionNameInConfig"], valKey ]];
                }
                
                NSString *fctNameInternal = [element valueForKey:@"actionNameInternal"];
                
                NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", fctNameInternal, @"functionNameInternal", paraName, paraKey, valName, valKey, nil];
                [arrayActions addObject:dictAction];
                
            }
            
        }
    }

    return arrayActions;
   
}

-(void)dealloc
{

    [constraintConditions release];
    [constraintActionsThen release];
    [constraintActionsElse release];
    [systemVariables release];
    [super dealloc];
}

@end
