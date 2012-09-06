//
//  NEDesignElement.m
//  BARTCommandLine
//
//  Created by Lydia Hellrung on 11/6/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "NEDesignElement.h"
//#import "NEDesignElementStat.h"
#import "NEDesignElementDyn.h"



@implementation NEDesignElement

@synthesize mRepetitionTimeInMs = _mRepetitionTimeInMs;
@synthesize mNumberExplanatoryVariables = _mNumberExplanatoryVariables;
@synthesize mNumberTimesteps = _mNumberTimesteps;
@synthesize mNumberRegressors = _mNumberRegressors;
@synthesize mNumberCovariates = _mNumberCovariates;

-(id)init
{
	if ((self = [super init])){
		_mRepetitionTimeInMs = 0;
		_mNumberExplanatoryVariables = 0;
		_mNumberTimesteps = 0;
		_mNumberRegressors = 0;
		_mNumberCovariates = 0;
	}
	return self;
}

//-(id)initWithDatasetFile:(NSString*)path 
//{
//	if ((self = [super init])){
//		self = [[NEDesignElementVI alloc] initWithFile:path];} 
//    return self;
//}

-(id)initWithDataFromConfig:(COSystemConfig*)config
{
    #pragma unused(config)
    [self doesNotRecognizeSelector:_cmd];
	return nil;
	
}

-(id)initWithDynamicDataFromConfig:(COSystemConfig*)config
{
    if ((self = [super init])){
        self = [[NEDesignElementDyn alloc] initWithConfig:config];
    }
    return self;
}
-(NSError*)writeDesignFile:(NSString*) path
{
    #pragma unused(path)
    [self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
	id newDesign = [[[self class] allocWithZone:zone] init];
	
	[newDesign setRepetitionTime:_mRepetitionTimeInMs];
	[newDesign setNumberExplanatoryVariables: _mNumberExplanatoryVariables];
	[newDesign setNumberTimesteps: _mNumberTimesteps];
	[newDesign setNumberRegressors: _mNumberRegressors];
	[newDesign setNumberCovariates: _mNumberCovariates];
	
	
	return newDesign;
}

-(NSNumber*)getValueFromExplanatoryVariable: (unsigned int)cov atTimestep:(unsigned int)t
{
    #pragma unused(t)
    #pragma unused(cov)
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)setRegressor:(TrialList *)regressor
{
    #pragma unused(regressor)
    [self doesNotRecognizeSelector:_cmd];
	return;
}

-(void)setRegressorTrial:(Trial)trial 
{
    #pragma unused(trial)
	[self doesNotRecognizeSelector:_cmd];
	return;
}

-(void)setCovariate:(float*)covariate forCovariateID:(int)covID
{
    #pragma unused(covID)
    #pragma unused(covariate)
	[self doesNotRecognizeSelector:_cmd];
	return;
}

-(void)setCovariateValue:(float)value forCovariateID:(int)covID atTimestep:(int)timestep
{
    #pragma unused(value)
    #pragma unused(covID)
    #pragma unused(timestep)
	[self doesNotRecognizeSelector:_cmd];
	return;
}

-(NSError*)updateDesign
{
    [self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end





