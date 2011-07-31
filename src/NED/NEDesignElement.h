//
//  NEDesignElement.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 11/6/09.
//  Copyright 2009 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAElement.h"

enum NEDesignElementError {
    TR_NOT_SPECIFIED,
    NUMBERTIMESTEPS_NOT_SPECIFIED,
	NUMBERCOVARIATES_NOT_SPECIFIED,
	NUMBERREGRESSORS_NOT_SPECIFIED,
	REGRESSOR_PARAMETRIC_SCALE_NOT_SPECIFIED,
	REGRESSOR_DURATION_NOT_SPECIFIED,
	CONVOLUTION_KERNEL_NOT_SPECIFIED,
    FILEOPEN,
    TXT_SCANFILE,
    ILLEGAL_INPUT_FORMAT,
    NO_EVENTS_FOUND,
    EVENT_NUMERATION,
    MAX_TRIALS,
    WRITE_OUTPUT
};

typedef struct TrialStruct{
    unsigned int id;               // Stimulus number.
    float onset;
    float duration;         // in seconds
    float height;
} Trial;

typedef struct TrialListStruct {
    Trial trial;
    struct TrialListStruct *next;
} TrialList;



@interface NEDesignElement : NSObject {

    unsigned int mRepetitionTimeInMs;
    unsigned int mNumberExplanatoryVariables;
    unsigned int mNumberTimesteps;
    unsigned int mNumberRegressors;
	unsigned int mNumberCovariates;  
	enum ImageDataType mImageDataType;
    
}

@property ( assign) unsigned int mRepetitionTimeInMs;
@property ( assign) unsigned int mNumberExplanatoryVariables;
@property ( assign) unsigned int mNumberTimesteps;
@property ( assign) unsigned int mNumberRegressors;
@property ( assign) unsigned int mNumberCovariates;   
@property ( assign) enum ImageDataType mImageDataType;

-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

/**
 * Initialize a Design  element from an edl configuration
 * the edl configuration has to be initialized
 * \param type the type of the image data - IMAGE_DATA_FLOAT || IMAGE_DATA_SHORT
 *
 * returns an object of DesignElement
 */
-(id)initWithDynamicDataOfImageDataType:(enum ImageDataType)type;


/**
 * write the design file to the given path
 * \param path to write the file
 * returns nil on success
 */
-(NSError*)writeDesignFile:(NSString*)path;

/**
 * get the value from regressor or covariate at a timestep
 * \param cov the column number the value is in
 * \param t the row number the value is in - means timestep
 */
-(NSNumber*)getValueFromExplanatoryVariable: (unsigned int)cov atTimestep:(unsigned int)t;

/**
 * set a whole column as a regressor
 * \param regressor a whole TrialList 
 */
-(void)setRegressor:(TrialList *)regressor;

/**
 * set a single trial in a regressor
 * \param regressor a single Trial 
 */

-(void)setRegressorTrial:(Trial)trial; 

/**
 * set a whole column as a covariate
 * \param covariate a whole covariate vector
 * \param covID the ID of the covariate to set 
 */

-(void)setCovariate:(float*)covariate forCovariateID:(int)covID;

/**
 * set a single value in one covariate
 * \param value to set for a covariate 
 * \param covID set value for ID of the covariate 
 * \param timestep set value at the timestep
 */
-(void)setCovariateValue:(float)value forCovariateID:(int)covID atTimestep:(int)timestep;

@end

