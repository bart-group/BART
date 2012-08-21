//
//  NERegressorAssignment.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/13/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NERegressorAssignment.h"
#import "COExperimentContext.h"


@implementation NERegressorAssignment

@synthesize mAssignmentDescription = _mAssignmentDescription;
@synthesize mScaleFactorDuration = _mScaleFactorDuration;
@synthesize mScaleFactorParameter = _mScaleFactorParameter;
@synthesize mTimeOffset = _mTimeOffset;
@synthesize mRegressorID = _mRegressorID;
@synthesize mTrialID = _mTrialID;

-(id)init
{
    if (self = [super init])
    {
        _mAssignmentDescription = @"";
        _mScaleFactorDuration = 1.0;
        _mScaleFactorParameter = 1.0;
        _mTimeOffset = 0;
        _mRegressorID = @"";
        _mTrialID = 0;
    }
    return self;
}

-(id)initWithFunctionID:(NSString*)funcID andRegID:(NSString*)regID
{
    
    if (self = [super init])
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
        NSUInteger countFct = [config countNodes:@"$transferFunctions/transferFunction"];
        for (NSUInteger i = 0; i < countFct;  i++)
        {
            NSString* request = [NSString stringWithFormat:@"$transferFunctions/transferFunction[%ld]/@transferFunctionID", i+1];
            
            NSString* requestedFunc = [config getProp:request];
            if ( NSOrderedSame == [requestedFunc compare:funcID])
            {
                NSString* requestD = [NSString stringWithFormat:@"$transferFunctions/transferFunction[%ld]/@durationScaleFactor", i+1];
                NSString* requestO = [NSString stringWithFormat:@"$transferFunctions/transferFunction[%ld]/@timeOffset", i+1];
                NSString* requestP = [NSString stringWithFormat:@"$transferFunctions/transferFunction[%ld]/@parametricScaleFactor", i+1];
                
                _mScaleFactorDuration = [[f numberFromString:[config getProp:requestD]] floatValue];
                _mTimeOffset = [[f numberFromString:[config getProp:requestO]] integerValue];
                _mScaleFactorParameter = [[f numberFromString:[config getProp:requestP]] floatValue];
            }
        }
        
        _mRegressorID = regID;
        // get additionally the trialID out of this
        // it's an internal variable to fasten the adding in regressors
        // let's see if it really improves this
        // regAssignments just exists in dynamic Designs
        // now read all the trials for each event
        
        NSUInteger nrRegs = [config countNodes:@"$dynDesign/dynamicTimeBasedRegressor"];
        for (NSUInteger i = 0; i < nrRegs; i++)
        {
            NSString * tempRegID = [config getProp:[NSString stringWithFormat:@"$dynDesign/dynamicTimeBasedRegressor[%lu]/@regressorID", i+1]];
            if (NSOrderedSame == [tempRegID compare:regID]){
                _mTrialID = i+1;
            }
        }
        
        [f release];
        
    }
    return self;
}

//-(Trial)createTrialFromStimEvent
//{
//    Trial newTrial;
//    newTrial.trialid  = 0;
//    newTrial.onset    = 0;
//    newTrial.duration = 0;
//    newTrial.height   = 1;
//    
//    return newTrial;
//}



@end

