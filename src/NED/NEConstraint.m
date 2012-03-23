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

-(NSArray*)createActionListForKey:(NSString*)key;
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
        NSMutableDictionary *dictAllSystemVariables = [NSMutableDictionary dictionaryWithCapacity:counterSystemVariables];
        NSMutableArray *arrayAllSourceNames = [NSMutableArray arrayWithCapacity:1];
        
        for (NSUInteger index = 0; index < counterSystemVariables; index++) {

            NSString *source = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@source", index+1]];
            [arrayAllSourceNames addObject:source];
            NSString *variableName = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@systemVariableName", index+1]];
            NSString *variableID = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%d]/@systemVariableID", index+1]];
            
            [dictAllSystemVariables setObject:[NSDictionary dictionaryWithObjectsAndKeys:source, @"source", variableName, @"variableName", nil] forKey:variableID];

        }
        
        // (3) read all available conditions
        NSUInteger nrVariables = [config countNodes:[NSString stringWithFormat:@"%@/conditions/condition", key]];
        NSMutableArray *arrayConditions = [NSMutableArray arrayWithCapacity:nrVariables];
        NSMutableArray *arrayConditionReference = [NSMutableArray arrayWithCapacity:nrVariables];
        for (NSUInteger count = 0; count < nrVariables; count++) {
            NSString *conditionVariableRef = [config getProp:[NSString stringWithFormat:@"%@/conditions/condition[%d]/@systemVariableRef", key, count+1]];
            [arrayConditionReference addObject:conditionVariableRef];
            [arrayConditions addObject:[[dictAllSystemVariables objectForKey:conditionVariableRef] objectForKey:@"variableName"]];
        } 
        // TODO: namen einsortieren enstprechend der Bedingung
        constraintConditions = [[NSArray alloc] initWithArray:arrayConditions];

        // (4) read all actions
        
        constraintActionsThen = [[NSArray alloc] initWithArray:[self createActionListForKey:[NSString stringWithFormat:@"%@/stimulusActions_then", key]]];
                                                    
        constraintActionsElse = [[NSArray alloc] initWithArray:[self createActionListForKey:[NSString stringWithFormat:@"%@/stimulusActions_else", key]]];
            
        //connect relevant systemVariables for this constraint from all actions and conditions
        NSMutableDictionary *dictSystemVariables = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSSet *uniqueVariableSources = [NSSet setWithArray:arrayAllSourceNames];
        //NSLog(@"Number of Sources: %lu", [uniqueVariableSources count]);
        
        for (NSString *s1 in uniqueVariableSources) {
        
            NSMutableArray *arrayParams = [NSMutableArray arrayWithCapacity:1];
            
            
            //check conditions
            for (NSString *sysVRef in arrayConditionReference) {
                //NSString *s1 = [uniqueVariableSources valueAtIndex:indSource];
                NSString *s2 = [[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"source"]; 
                if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                    [arrayParams addObject:[[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"variableName"]];
                }
                //NSString *source = [dictAllSystemVariables objectForKey:sysVRef]; 
            }
            
            //check actions
            for (NSDictionary *dictAction in constraintActionsThen)
            {
                NSString *sysVRef = [dictAction valueForKey:@"systemVariableRef"]; 
                if (nil !=sysVRef){
                    NSString *s2 = [[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"source"];
                    if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                        [arrayParams addObject:[[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"variableName"]];
                    } 
                }
            }
            for (NSDictionary *dictAction in constraintActionsElse)
            {
                NSString *sysVRef = [dictAction valueForKey:@"systemVariableRef"]; 
                if (nil !=sysVRef){
                    NSString *s2 = [[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"source"];
                    if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                        [arrayParams addObject:[[dictAllSystemVariables valueForKey:sysVRef] valueForKey:@"variableName"]];
                    } 
                }
            }
 
            [dictSystemVariables setObject:arrayParams forKey:s1];
        }
        
        systemVariables = [[NSDictionary alloc ] initWithDictionary:dictSystemVariables];
        
        
    }

    return self;
}

-(NSArray*)createAllAvailableActions
{

    //todo: in eigene klasse oder global?
    
    NSDictionary *dictActionReplace = [[NSDictionary alloc] initWithObjectsAndKeys:@"replaceMediaObject",@"actionNameInConfig", @"replaceMediaObject",@"actionNameInternal",@"mediaObjectRef",@"valueToSet", nil];
    NSDictionary *dictActionSetMO = [[NSDictionary alloc] initWithObjectsAndKeys:@"setMediaObjectParameter",@"actionNameInConfig", @"setMediaObjectParamter",@"actionNameInternal",@"parameterName",@"parameterName", @"systemVariableRef",@"valueToSet", nil];
    NSDictionary *dictRemoveSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"removeCurrentStimulusEvent",@"actionNameInConfig", @"removeCurrentStimulusEvent",@"actionNameInternal", nil];
//    NSDictionary *dictAddSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"addStimulusEvent",@"actionNameInConfig", @"addStimulusEvent",@"actionNameInternal", nil];
    NSDictionary *dictChangeTimingSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"changeTimingStimulusEvent",@"actionNameInConfig", @"changeTimingStimulusEvent", @"actionNameInternal", @"parameterName", @"parameterName", @"newValue",@"valueToSet", nil];
    
    NSArray *allAvailableActions = [[NSArray alloc] initWithObjects:dictActionReplace, dictActionSetMO, dictRemoveSE, dictChangeTimingSE, nil];
    
    //[dictAddSE release];
    [dictActionReplace release];
    [dictActionSetMO release];
    [dictChangeTimingSE release];
    [dictRemoveSE release];
    
    return [allAvailableActions autorelease];

}

-(NSArray*)createActionListForKey:(NSString *)key
{
    //TODO: Wie verschiedene Fktname und Parameter aufloesen?
    //NSString *path = [NSString stringWithFormat:@"$refConstraints/%@", type];
    
    COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    NSUInteger counterActions = [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction", key] ];
    NSMutableArray *arrayActions = [NSMutableArray arrayWithCapacity:counterActions];
    
    for (NSUInteger index=0; index < counterActions; index++) {
        //ask each available action
        NSArray *allAvailableActions = [[self createAllAvailableActions] retain];
        for (NSDictionary *element in allAvailableActions)
        {
            if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction[%d]/%@", key, index+1,[element valueForKey:@"actionNameInConfig"] ]] )
            {
                NSString *paraName = @"";
                NSString *paraKey = [element valueForKey:@"parameterName"];
                NSString *valName = @"";
                NSString *valKey = [element valueForKey:@"valueToSet"];
                NSString *fctName = [element valueForKey:@"actionNameInConfig"] ;
                
                NSLog(@"%@", [NSString stringWithFormat:@"%@/stimulusAction[%d]/%@/@%@", key,index+1, fctName, paraKey ]); 
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction[%d]/%@/@%@", key,index+1, fctName, paraKey ]] )
                {
                    paraName = [config getProp:[NSString stringWithFormat:@"%@/stimulusAction[%d]/%@/@%@", key,index+1, fctName, paraKey ]];
                }
                if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction[%d]/%@/@%@", key,index+1, fctName, valKey ]] )
                {
                    valName = [config getProp:[NSString stringWithFormat:@"%@/stimulusAction[%d]/%@/@%@", key,index+1, fctName, valKey ]];
                }
                
                NSString *fctNameInternal = [element valueForKey:@"actionNameInternal"];
                
                if (nil == paraKey){
                    NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", fctNameInternal, @"functionNameInternal", valName, valKey, nil];
                    [arrayActions addObject:dictAction];
                }
                else if (nil == valKey){
                    //todo : this case doesn't make sense
                    NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", fctNameInternal, @"functionNameInternal", paraName, paraKey, nil];
                    [arrayActions addObject:dictAction];
                }
                else{
                    NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", fctNameInternal, @"functionNameInternal", paraName, paraKey, valName, valKey, nil];
                    [arrayActions addObject:dictAction];
                }
                
                
            }
            
        }
        [allAvailableActions release];
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
