//
//  BADesignElement.h
//  BARTCommandLine
//
//  Created by First Last on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BAElement.h"


@interface BADesignElement : BAElement {

    int repetitionTimeInMs;
    int numberCovariates;
    int numberTimesteps;
    enum ImageDataType imageDataType;
    
}

@property (readonly, assign) int repetitionTimeInMs;
@property (readonly, assign) int numberCovariates;
@property (readonly, assign) int numberTimesteps;
@property (readonly, assign) enum ImageDataType imageDataType;


-(id)initWithDatasetFile:(NSString*)path ofImageDataType:(enum ImageDataType)type;

-(NSNumber*)getValueFromCovariate: (int)cov atTimestep:(int)t;

@end


