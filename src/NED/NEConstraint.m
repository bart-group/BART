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
@synthesize systemVariablesBySource;
@synthesize constraintConditions;
@synthesize numberOfExternalSources;

-(id)init
{

    if (self = [super init])
    {
        constraintID = @"";
        isActive = NO;
        systemVariablesBySource = NULL;
        systemVariablesByID = NULL;
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

            NSString *source = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%ld]/@source", index+1]];
            [arrayAllSourceNames addObject:source];
            NSString *variableName = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%ld]/@systemVariableName", index+1]];
            NSString *variableID = [config getProp:[NSString stringWithFormat:@"$systemVariables/systemVariable[%ld]/@systemVariableID", index+1]];
            
            [dictAllSystemVariables setObject:[NSDictionary dictionaryWithObjectsAndKeys:source, @"source", variableName, @"variableName", nil] forKey:variableID];

        }
        systemVariablesByID = [[NSDictionary alloc] initWithDictionary:dictAllSystemVariables];
        
        // (3) read all available conditions
        NSUInteger nrVariables = [config countNodes:[NSString stringWithFormat:@"%@/conditions/condition", key]];
        NSMutableArray *arrayConditions = [NSMutableArray arrayWithCapacity:nrVariables];
        NSMutableArray *arrayConditionReference = [NSMutableArray arrayWithCapacity:nrVariables];
        for (NSUInteger count = 0; count < nrVariables; count++) {
            NSString *conditionVariableRef = [config getProp:[NSString stringWithFormat:@"%@/conditions/condition[%ld]/@systemVariableRef", key, count+1]];
            [arrayConditionReference addObject:conditionVariableRef];
            [arrayConditions addObject:[[systemVariablesByID objectForKey:conditionVariableRef] objectForKey:@"variableName"]];
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
                NSString *s2 = [[systemVariablesByID valueForKey:sysVRef] valueForKey:@"source"]; 
                if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                    [arrayParams addObject:[[systemVariablesByID valueForKey:sysVRef] valueForKey:@"variableName"]];
                }
                //NSString *source = [dictAllSystemVariables objectForKey:sysVRef]; 
            }
            
            //check actions
            for (NSDictionary *dictAction in constraintActionsThen)
            {
                for( NSDictionary *att in [dictAction objectForKey:@"attributesArray"])
                {
                    if (NSOrderedSame == [[att valueForKey:@"attributeType"] compare:@"systemVariableRef" options:NSCaseInsensitiveSearch])
                    {
                        NSString *sysVName = [att valueForKey:@"attributeName"];
                        NSString *s2 = [[systemVariablesByID valueForKey:sysVName] valueForKey:@"source"];
                        if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                            [arrayParams addObject:sysVName];} 
                    }
                }
            }
            for (NSDictionary *dictAction in constraintActionsElse)
            {
                for( NSDictionary *att in [dictAction objectForKey:@"attributesArray"])
                {
                    if (NSOrderedSame == [[att valueForKey:@"attributeType"] compare:@"systemVariableRef" options:NSCaseInsensitiveSearch])
                    {
                        NSString *sysVName = [att valueForKey:@"attributeName"];
                        NSString *s2 = [[systemVariablesByID valueForKey:sysVName] valueForKey:@"source"];
                        if (NSOrderedSame == [s1 compare:s2 options:NSCaseInsensitiveSearch]){
                            [arrayParams addObject:sysVName];} 
                    }
                }
            }
 
            [dictSystemVariables setObject:arrayParams forKey:s1];
        }
        
        systemVariablesBySource = [[NSDictionary alloc ] initWithDictionary:dictSystemVariables];
        
        
    }

    return self;
}

-(NSArray*)createAllAvailableActions
{

    //todo: in eigene klasse oder global?
    
    NSDictionary *dictActionReplace = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       @"replaceMediaObject",@"actionNameInConfig",
                                       @"replaceMediaObject",@"actionNameInternal",
                                       [NSArray arrayWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"mediaObjectRef", @"attributeName",
                                         @"mediaObjectRef", @"attributeType",
                                         @"", @"attributeValue", nil],
                                        nil], @"attributesArray",
                                       nil];
    
    
    NSDictionary *dictActionSetMO = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"setMediaObjectParameter",@"actionNameInConfig", 
                                     @"setMediaObjectParamter", @"actionNameInternal",
                                     [NSArray arrayWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"systemVariableRef", @"attributeName",
                                       @"systemVariableRef", @"attributeType",
                                       @"", @"attributeValue", nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"parameterName", @"attributeName", 
                                       @"Name", @"attributeType",
                                       @"", @"attributeValue", nil],
                                      nil],@"attributesArray", 
                                     nil];
    
    
    NSDictionary *dictRemoveSE = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"removeCurrentStimulusEvent",@"actionNameInConfig", 
                                  @"removeCurrentStimulusEvent",@"actionNameInternal", 
                                  nil];
    
    
//    NSDictionary *dictAddSE = [[NSDictionary alloc] initWithObjectsAndKeys:@"addStimulusEvent",@"actionNameInConfig", @"addStimulusEvent",@"actionNameInternal", nil];
    NSDictionary *dictInsertNew = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"insertNewStimulusEvent",@"actionNameInConfig",
                                   @"insertNewStimulusEvent", @"actionNameInternal", 
                                   [NSArray arrayWithObjects:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"duration", @"attributeName", 
                                     @"durationTime", @"attributeType",
                                     [NSNumber numberWithUnsignedInt:0], @"attributeValue", nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"mediaObjectRef", @"attributeName",
                                     @"mediaObjectRef", @"attributeType",
                                     @"", @"attributeValue", nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"shiftFollowingStimulusEvents", @"attributeName", 
                                     @"pushFlag", @"attributeType",
                                     [NSNumber numberWithBool:NO], @"attributeValue", nil],
                                    nil], @"attributesArray",
                                   nil];
    
    NSArray *allAvailableActions = [[NSArray alloc] initWithObjects:
                                    dictActionReplace, dictActionSetMO, dictRemoveSE, dictInsertNew, nil];
    
    //[dictAddSE release];
    [dictActionReplace release];
    [dictActionSetMO release];
    [dictInsertNew release];
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
    
    for (NSUInteger index = 0; index < counterActions; index++) {
        //ask each available action
        NSArray *allAvailableActions = [[self createAllAvailableActions] retain];
        for (NSDictionary *element in allAvailableActions)
        {
            if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction[%ld]/%@", key, index+1,[element valueForKey:@"actionNameInConfig"] ]] )
            {
                NSString *fctName = [element valueForKey:@"actionNameInConfig"] ;

                NSMutableArray *arrayCollectAttributes = [NSMutableArray arrayWithCapacity:[[element objectForKey:@"attributesArray"] count]];
                for (NSDictionary *att in [element objectForKey:@"attributesArray"])
                {
                    //make a copy of att
                    NSMutableDictionary *newAtt = [NSMutableDictionary dictionaryWithDictionary:att];

                    NSString *attName = [att objectForKey:@"attributeName"];
                    NSString *attVal;
                    
                    NSLog(@"%@", [NSString stringWithFormat:@"%@/stimulusAction[%ld]/%@/@%@", key,index+1, fctName, attName ]); 
                    if ( 0 != [config countNodes:[NSString stringWithFormat:@"%@/stimulusAction[%ld]/%@/@%@", key,index+1, fctName, attName ]] )
                    {
                        attVal = [config getProp:[NSString stringWithFormat:@"%@/stimulusAction[%ld]/%@/@%@", key,index+1, fctName, attName ]];
                        
                        if (nil != [systemVariablesByID objectForKey:attVal])
                        {
                            [newAtt setValue:[[systemVariablesByID objectForKey:attVal] objectForKey:@"variableName"] forKey:@"attributeValue"];
                        }
                        else{
                            [newAtt setValue:attVal forKey:@"attributeValue"];}
                        [arrayCollectAttributes addObject:newAtt];
                    }

                }
                
                NSString *fctNameInternal = [element valueForKey:@"actionNameInternal"];
                NSArray *arrayAttributes = [NSArray arrayWithArray:arrayCollectAttributes];//to be nonmutable
                NSDictionary *dictAction = [NSDictionary dictionaryWithObjectsAndKeys:fctName, @"functionName", fctNameInternal, @"functionNameInternal", arrayAttributes, @"attributesArray", nil];
                [arrayActions addObject:dictAction];
            }
        }
        [allAvailableActions release];
    }

    return [NSArray arrayWithArray:arrayActions] ;
   
}

-(void)dealloc
{

    [constraintConditions release];
    [constraintActionsThen release];
    [constraintActionsElse release];
    [systemVariablesBySource release];
    [systemVariablesByID release];
    [super dealloc];
}

@end
