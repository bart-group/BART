//
//  BADesignElement.m
//  BARTCommandLine
//
//  Created by First Last on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BADesignElement.h"
#import "BADesignElementVI.h"
#import "BADesignElementDyn.h"


@implementation BADesignElement

@synthesize mRepetitionTimeInMs;
@synthesize mNumberExplanatoryVariables;
@synthesize mNumberTimesteps;
@synthesize mImageDataType;

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type
{
    // TODO!!
    [self release];
    self = nil;
    self = [[BADesignElementDyn alloc] initWithFile:path ofImageDataType:type];
    
    return self;
}

-(NSError*)writeDesignFile:(NSString*) path
{
    
}



-(void)setRegressor:(TrialList *)regressor
{
    
}

-(void)setRegressorValue:(Trial)value forRegressorID:(int)regID atTimestep:(int)timestep
{
}

-(void)setCovariate:(float*)covariate forCovariateID:(int)covID
{
}

-(void)setCovariateValue:(float)value forCovariateID:(int)covID atTimestep:(int)timestep
{
    
}

@end





