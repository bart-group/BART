//
//  BADesignElement.h
//  BARTCommandLine
//
//  Created by First Last on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAElement.h"

enum BADesignElementError {
    TR_NOT_SPECIFIED,
    NUMBERTIMESTEPS_NOT_SPECIFIED,
    FILEOPEN,
    TXT_SCANFILE,
    ILLEGAL_INPUT_FORMAT,
    NO_EVENTS_FOUND,
    EVENT_NUMERATION,
    MAX_TRIALS,
    WRITE_OUTPUT
};

typedef struct TrialStruct{
    int   id;               // Stimulus number.
    float onset;
    float duration;         // in seconds
    float height;
} Trial;

typedef struct TrialListStruct {
    Trial trial;
    struct TrialListStruct *next;
} TrialList;



@interface BADesignElement : BAElement {

    int repetitionTimeInMs;
    int numberExplanatoryVariables;
    int numberTimesteps;
    enum ImageDataType imageDataType;
    
}

@property (readonly, assign) int repetitionTimeInMs;
@property (readonly, assign) int numberExplanatoryVariables;
@property (readonly, assign) int numberTimesteps;
@property (readonly, assign) enum ImageDataType imageDataType;

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

-(NSError*)writeDesignFile:(NSString*)path;

-(NSNumber*)getValueFromExplanatoryVariable: (int)cov atTimestep:(int)t;

-(void)setRegressor:(TrialList *)regressor;
-(void)setRegressorTrial:(Trial)trial; 
-(void)setCovariate:(float*)covariate forCovariateID:(int)covID;
-(void)setCovariateValue:(float)value forCovariateID:(int)covID atTimestep:(int)timestep;

@end


