//
//  NEPresentationExternalConditionController.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEPresentationExternalConditionController.h"
#import "CLETUS/COExperimentContext.h"

@implementation NEPresentationExternalConditionController

COExperimentContext *expContext;

-(id)init
{
    if ((self = [super init])){
        expContext = [COExperimentContext getInstance];
    }
    return self;
}




-(BOOL)isConditionFullfilledForMediaObjectID:(NSString*)mediaObjectID
{
    
        return NO;
}

@end
